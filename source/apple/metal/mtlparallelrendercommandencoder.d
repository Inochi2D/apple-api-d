/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    MTLParallelRenderCommandEncoder
*/
module apple.metal.mtlparallelrendercommandencoder;
import apple.metal;
import apple.foundation;

import apple.os;
import apple.objc;
import apple.objc : selector;

mixin RequireAPIs!(Metal, Foundation);

/**
    An interface that encodes a render pass into a command buffer, 
    including all its draw calls and configuration.
*/
@ObjectiveC @ObjcProtocol
class MTLParallelRenderCommandEncoder : MTLCommandEncoder {
@nogc nothrow:
public:

    /**
        Base constructor
    */
    this(id self) { super(self); }


    // Link
    mixin ObjcLink!("_MTLParallelRenderCommandEncoder");
}