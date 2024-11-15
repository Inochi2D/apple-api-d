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
class NSObject : DRTBindable, NSObjectProtocol {
@nogc nothrow:
public:

    /**
        Base constructor
    */
    this(id self) { super(self); }
    
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
        Creates a stack allocated wrapper for the object
        that gets released when it goes out of scope.
    */
    auto autorelease() {
        return DRTAutoRelease(this);
    }

    // Link NSObject.
    mixin ObjcLink;
}

/**
    Calls the `alloc` function for the object.
*/
id alloc(NSObject obj_) nothrow @nogc {
    return NSObject.message!id(obj_.objc_type(), "alloc");
}

/**
    Calls the `init` function for the object instance.
*/
id initialize(id self_) nothrow @nogc {
    return NSObject.message!id(self_, "init");
}