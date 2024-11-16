/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    D Runtime Integration for Objective-C
*/
module apple.objc.rt.drt.scoped;
import apple.objc.rt.base;
import apple.objc.rt.abi;
import apple.objc.rt.meta;
import apple.objc.block;
import apple.objc;
import numem.core.memory;
import apple.os;
import core.stdc.math;
import numem.core.memory;
import numem.events;

mixin RequireAPIs!(ObjC);

@nogc nothrow:

/**
    A struct which wraps an DRTBindable type and calls the
    retain and release functions automatically.
*/
struct DRTScope(T) if (is(T : DRTBindable)) {
nothrow @nogc:
public:
    T self_;
    alias self_ this;

    ~this() {
        this.self_.release();
    }

    // Postblit
    this(this) {
        this.self_.retain();
    }

    // Constructor
    this(T self_) {
        this.self_ = self_;
    }
}

/**
    Returns an autorelease version of `self_`.
*/
DRTScope!T scoped(T)(T self_) if (is(T : DRTBindable)) {
    return DRTScope!T(self_);
}
