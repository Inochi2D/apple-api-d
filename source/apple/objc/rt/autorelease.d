/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    Implementation of auto release pool blocks.
*/
module apple.objc.rt.autorelease;
import apple.objc.rt.base;
import apple.os;

import apple.objc : ObjC;
mixin RequireAPIs!(ObjC);

import numem.core.memory;
import numem.core.memory.alloc : assumeNoGC;

/**
    Creates an auto-release pool scope with the given delegate.
*/
void autoreleasepool(scope void delegate() scope_) {
    auto scope_fn = assumeNoGC!(typeof(scope_))(scope_);
    
    void* ctx = objc_autoreleasePoolPush();
        scope_fn();

    debug(trace) _objc_autoreleasePoolPrint();

    objc_autoreleasePoolPop(ctx);
}

/**
    Should be called at the beginning of a thread.
*/
void __ar_threadbegin() {

    // Initialize a bottom release pool, just in case.
    if (!arr_bottom)
        arr_bottom = objc_autoreleasePoolPush();
}

/**
    Should be called at the end of a thread.
*/
void __ar_threadend() {
    if (arr_bottom) {
        objc_autoreleasePoolPop(arr_bottom);
        arr_bottom = null;
    }
}


private:
extern(C) @nogc nothrow:

// Thread local.
void* arr_bottom;

// Auto release pool
extern void* objc_autoreleasePoolPush();
extern void  objc_autoreleasePoolPop(void*);

debug(trace) extern void _objc_autoreleasePoolPrint();