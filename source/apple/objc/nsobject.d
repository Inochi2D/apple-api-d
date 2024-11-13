/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    Bindings to NSObject and NSObjectProtocol
*/
module apple.objc.nsobject;
import apple.os;

import apple.objc : ObjC;
mixin RequireAPIs!(ObjC);

import apple.objc.rt;
import apple.objc.rt : selector;

import numem.core.memory;

@ObjectiveC
interface NSObjectProtocol {
@nogc nothrow:

    /**
        Returns the class object for the receiver’s class.
    */
    Class getClass(); // Implemented via ObjcLink

    /**
        Returns the superclass for this object
    */
    @property Class superclass();

    /**
        Returns a Boolean value that indicates whether the receiver and a given object are equal.
    */
    bool isEqual(inout(id) obj) @selector("isEqual:");

    /**
        Returns an integer that can be used as a table address in a hash table structure.
    */
    @property NSUInteger hash();

    /**
        Increments the receiver’s reference count.
    */
    void retain() @selector("retain");

    /**
        Decrements the receiver’s reference count.
    */
    void release() @selector("release");
}

/**
    Base class of all Objective-C classes.
*/
@ObjectiveC
class NSObject : NSObjectProtocol {
@nogc nothrow:
private:
    id self_;

    /**
        Decrements the receiver’s reference count.
    */
    void objc_dealloc() @selector("dealloc");

protected:

    /**
        Allows updating self value.
    */
    id self(id newValue) {
        this.self_ = newValue;
        return this.self_;
    }
    
    /**
        Associates a D type with a key for this Objective-C instance.
    */
    final
    void associate(K, V)(K key, V value) {
        
        // NOTE: We're misusing an Objective-C feature here to, basically
        // store a pointer back to the D object via Objective-C
        // associated objects.
        // OBJC_ASSOCIATION_ASSIGN being unsafe should allow this.
        objc_setAssociatedObject(this.self_, cast(void*)key, cast(id)value, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN);
    }

    /**
        Removes an association by key.
    */
    final
    void disassociate(K)(K key) {
        objc_setAssociatedObject(this.self_, cast(void*)key, null, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN);
    }

    /**
        Gets the association for this class
    */
    final
    T getAssociation(T, K)(K key) {
        return cast(T)objc_getAssociatedObject(this.self_, key);
    }

    /**
        Base constructor of all NSObject-derived instances
    */
    this() {
        this.self_ = this.message!id(this.getClass(), "alloc");

        if (!isAssociated)
            this.associate(_OBJC_D_GLUE, this);
    }

    /**
        Calls the default init function
    */
    final
    ref auto init() {
        this.self_ = this.message!id(this.getClass(), "init");
        return this;
    }

public:

    /**
        Instantiates object with a pre-existing object instance id.
    */
    this(id selfId, bool retain=false) {
        this.self_ = selfId;

        if (!isAssociated)
            this.associate(_OBJC_D_GLUE, this);
        
        // Ref counting.
        if (retain)
            this.retain();
    }

    /**
        Destructor of all NSObject-derived instances
    */
    ~this() {

        // Remove assocation if there is one.
        if (this.isAssociated)
            this.disassociate(_OBJC_D_GLUE);
        
        this.release();
    }

    /**
        Gets the underlying Objective-C reference.
    */
    final id self() => self_;

    /**
        Gets the handle of the association for this objective-c class.
    */
    final NSObject handle() => this.getAssociation!NSObject(_OBJC_D_GLUE);

    /**
        Forcefully deallocates the Objective-C object
        and the wrapper class.

        The class will be invalid after calling this.
    */
    @system
    final
    void deallocate() {
        auto selfHandle = this.handle();
        
        this.objc_dealloc();
        nogc_delete(selfHandle);
    }

    /**
        Gets whether this this object has an association with
        its D wrapper class.
    */
    final
    bool isAssociated() => objc_getAssociatedObject(this.self_, _OBJC_D_GLUE) !is null;
    
    /**
        Gets whether this object conforms to the specified prototype.
    */
    bool conformsTo(T)() if (isObjectiveCProtocol!T) {
        return class_conformsToProtocol(this.getClass(), T.PROTOCOL);
    }

    /**
        Implements equality comparison
    */
    bool opEquals(T)(T other) @nobind if (is(T : NSObject)) {
        return this.isEqual(other.self_);
    }

    /**
        Sends a message (calls a function) based on the given selector.
    */
    T message(T, Args...)(const(char)* selector, Args args) inout {
        return sendMessage!(T, Args)(cast(id)this.self_, sel_registerName(selector), args);
    }

    /**
        Sends a message (calls a function) based on the given selector.
        A class instance will need to be specified.
    */
    static T message(T, Args...)(Class target, const(char)* selector, Args args) {
        return sendMessage!(T, Args)(cast(id)target, sel_registerName(selector), args);
    }

    // Link NSObject.
    mixin ObjcLink;
}

/**
    Wraps NSObject to a D type.

    This wrapped type is *NOT* managed by the GC,
    make sure to use the convenience `free` function.
*/
pragma(inline, true)
auto ref wrap(T)(idref!T ref_) @nogc if (is(T : NSObject)) {
    auto rval = cast(T)objc_getAssociatedObject(ref_, _OBJC_D_GLUE);
    
    if (!rval)
        rval = nogc_new!T(ref_);

    return rval;
}

/**
    Gets a selector by its name.

    Returns null if the selector wasn't found.
*/
SEL getSelector(const(char)* selector) {
    return sel_getUid(selector);
}

private {
    extern(C) __gshared const(char)* _OBJC_D_GLUE = "_OBJC_D_GLUE";
}