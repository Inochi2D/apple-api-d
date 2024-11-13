/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    MTLCommandBuffer
*/
module apple.metal.mtlcommandbuffer;
import apple.metal;
import apple.foundation;
import apple.coredata;
import apple.coregraphics;
import apple.uikit;
import apple.os;
import apple.objc.rt;
import apple.objc.rt : selector;

mixin RequireAPIs!(Metal, Foundation);

/**
    A container that stores a sequence of GPU commands that you encode into it.
*/
@ObjectiveC
class MTLCommandBuffer : NSObject {
@nogc nothrow:
public:

    /// Create MTLCommandBuffer from ref.
    this(id ref_) { super(ref_); }

    // Link
    mixin ObjcLink!("_MTLCommandBuffer");
}

