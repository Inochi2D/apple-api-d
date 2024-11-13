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
abstract
class NSObject : NSObjectProtocol {
@nogc nothrow:
private:
    id self_;

protected:

    /**
        Sends a message (calls a function) based on the given selector.
    */
    T message(T, Args...)(const(char)* selector, Args args) {
        return sendMessage!(T, Args)(this.self(), sel_registerName(selector), args);
    }

    /**
        Sends a message to super class (calls a function) based on the given selector.
    */
    T messageSuper(T, Args...)(const(char)* selector, Args args) {
        return sendMessageSuper!(T, Args)(this.superclass(), sel_registerName(selector), args);
    }

    /**
        Sends a message (calls a function) based on the given selector.
        A class instance will need to be specified.
    */
    static T message(T, Args...)(Class target, const(char)* selector, Args args) {
        return sendMessage!(T, Args)(cast(id)target, sel_registerName(selector), args);
    }

    /**
        Allows updating self value.
    */
    id self(id newValue) {
        this.self_ = newValue;
        return this.self_;
    }

    /**
        Base constructor of all NSObject-derived instances
    */
    this() {
        this.self_ = this.message!id(this.getClass(), "alloc");
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
        
        // Ref counting.
        if (retain)
            this.retain();
    }

    /**
        Destructor of all NSObject-derived instances
    */
    ~this() {
        this.release();
    }

    /**
        Gets the underlying Objective-C reference.
    */
    final id self() => self_;

    /**
        Frees all memory assocaited with this instance.
    */
    @system
    final
    void free() {
        objc_destructInstance(self_);
        object_dispose(self_);
        this.self_ = null;
    }
    
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

    // Link NSObject.
    mixin ObjcLink;
}

/**
    Gets a selector by its name.

    Returns null if the selector wasn't found.
*/
SEL getSelector(const(char)* selector) {
    return sel_getUid(selector);
}