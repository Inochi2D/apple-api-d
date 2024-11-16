/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    MTLCommandBuffer
*/
module apple.metal.mtlcommandencoder;
import apple.metal;
import apple.foundation;

import apple.os;
import apple.objc;
import apple.objc : selector;

mixin RequireAPIs!(Metal, Foundation);

/**
    An encoder that writes GPU commands into a command buffer.
*/
@ObjectiveC @ObjcProtocol
class MTLCommandEncoder : NSObject {
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

    /**
        Declares that all command generation from the encoder is completed.
    */
    void endEncoding() @selector("endEncoding");

    /**
        Inserts a debug string into the captured frame data.
    */
    void insertDebugSignpost(NSString label) @selector("insertDebugSignpost:");

    /**
        Pushes a specific string onto a stack of debug group strings for the command encoder.
    */
    void pushDebugGroup(NSString label) @selector("pushDebugGroup:");

    /**
        Pops the latest string off of a stack of debug group strings for the command encoder.
    */
    void popDebugGroup() @selector("popDebugGroup");

    // Link
    mixin ObjcLink!("_MTLCommandEncoder");
}