/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    MTLTexture
*/
module apple.metal.mtlbuffer;
import apple.metal;
import apple.foundation;
import apple.coredata;
import apple.coregraphics;
import apple.uikit;
import apple.os;

import apple.iosurface;

import apple.objc;
import apple.objc.rt;
import apple.objc.rt : selector;

mixin RequireAPIs!(Metal, Foundation);

@ObjectiveC
class MTLBuffer : NSObject {
@nogc nothrow:
public:
    
}