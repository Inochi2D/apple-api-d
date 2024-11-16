/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    Bindings to NSAutoreleasePool
*/
module apple.foundation.nsautoreleasepool;
import apple.foundation;
import apple.os;

import apple.objc : ObjC;
mixin RequireAPIs!(ObjC);

import apple.objc;
import apple.objc : selector;

import numem.core.memory;
import numem.core.memory.alloc : assumeNoGC;

@nogc:

/**
    An object that supports Cocoa’s reference-counted memory management system.
*/
@ObjectiveC
class NSAutoreleasePool : NSObject {
@nogc nothrow:
public:

    /**
        Adds a given object to the active autorelease pool in the current thread. 
    */
    static void add(id obj_) @selector("addObject:");

    /**
        Base constructor
    */
    this(id self) { super(self); }

    /**
        Creates a new auto release pool
    */
    this() { super(); }

    /**
        Adds a given object to the receiver 
    */
    void add(id obj_) @selector("addObject:");

    /**
        In a reference-counted environment, releases and pops the receiver; in a garbage-collected environment, 
        triggers garbage collection if the memory allocated since the last collection is greater than the current threshold.
    */
    void drain() @selector("drain");

    // Link NSAutoreleasePool.
    mixin ObjcLink;
}

/**
    Creates an auto-release pool scope with the given delegate.
*/
void autoreleasepool(scope void delegate() scope_) {
    auto scope_fn = assumeNoGC!(typeof(scope_))(scope_);

    NSAutoreleasePool pool = nogc_new!NSAutoreleasePool();
    scope(exit) pool.drain();

    scope_fn();
}