/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    MTLEvent
*/
module apple.metal.mtlevent;
import apple.metal;
import apple.foundation;

import apple.os;
import apple.objc;
import apple.objc : selector;

mixin RequireAPIs!(Metal, Foundation);

/**
    A memory fence to capture, track, and manage resource dependencies across command encoders.
*/
@ObjectiveC @ObjcProtocol
class MTLEvent : NSObject {
@nogc nothrow:
public:

    /**
        The GPU device that created the command queue.
    */
    @property MTLDevice device() const;

    /**
        An optional name that can help you identify the command queue.
    */
    @property NSString label();
    @property void label(NSString);

    /**
        Base constructor
    */
    this(id self) { super(self); }


    // Link
    mixin ObjcLink;
}