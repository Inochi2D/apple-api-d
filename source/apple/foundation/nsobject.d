/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    Bindings to NSObject and NSObjectProtocol
*/
module apple.foundation.nsobject;
import apple.foundation.nstypes;
import apple.os;

import apple.objc : ObjC;
mixin RequireAPIs!(ObjC);

import apple.objc;
import apple.objc.rt;
import apple.objc.rt : selector;
import numem.core.memory;

@ObjectiveC
interface NSObjectProtocol {
@nogc nothrow:

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
class NSObject : NSObjectProtocol, DRTBindable {
@nogc nothrow:
private:
    id self_;

    /**
        Decrements the receiver’s reference count.
    */
    void objc_dealloc() @selector("dealloc");

protected:

    /**
        Allocates an instance of the object.
    */
    final
    id alloc() => this.message!id(this.objc_type(), "alloc");

    /**
        Calls base init function.
    */
    final
    id init() => this.message!id(this.objc_type(), "init");

    /**
        Allows updating self value.
    */
    @objc_ignore
    @property id self(id newValue) { this.self_ = newValue; return self_; }

public:

    /**
        Gets the underlying Objective-C type
        Either a Class or Protocol.
    */
    final
    @objc_ignore
    @property id objc_type() inout => cast(id)SELF_TYPE;

    /**
        Gets the underlying Objective-C reference.
    */
    @objc_ignore
    @property id self() inout => cast(id)self_;

    /**
        Destructor of all NSObject-derived instances
    */
    ~this() {
        if (self_) {
            drt_wrap_remove(self_);
            this.release();
            this.self_ = null;
        }
    }

    /**
        Base constructor
    */
    this(id self) { this.self_ = self; }

    /**
        Called when the DRT type is being wrapped.
    */
    void notifyWrap(id byWhom) { }

    /**
        Called when the DRT type is being unwrapped.
    */
    void notifyUnwrap(id byWhom) { }

    /**
        Called when the DRT type is being destroyed.
    */
    void notifyDealloc(id byWhom) { 
        this.self_ = null;

        // This won't free other instances!
        NSObject self = this;
        nogc_delete(self);
    }

    /**
        Gets the handle of the association for this objective-c class.
    */
    final id drt_handle() => drt_get_handle(self_);
    
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