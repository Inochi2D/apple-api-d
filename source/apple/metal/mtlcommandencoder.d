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
import apple.coredata;
import apple.coregraphics;
import apple.uikit;
import apple.os;

import apple.objc;
import apple.objc : selector;
import apple.metal.mtlrenderpipeline;

mixin RequireAPIs!(Metal, Foundation);

enum MTLPrimitiveType : NSUInteger {
    Point = 0,
    Line = 1,
    LineStrip = 2,
    Triangle = 3,
    TriangleStrip = 4,
}

enum MTLVisibilityResultMode : NSUInteger {
    Disabled = 0,
    Boolean = 1,
    Counting  = 2,
}

struct MTLScissorRect {
    NSUInteger x;
    NSUInteger y;
    NSUInteger width;
    NSUInteger height;
}

struct MTLViewport {
    double originX;
    double originY;
    double width;
    double height;
    double znear;
    double zfar;
}

enum MTLCullMode : NSUInteger {
    None = 0,
    Front = 1,
    Back = 2,
}

enum MTLWinding : NSUInteger {
    Clockwise = 0,
    CounterClockwise = 1,
}

enum MTLDepthClipMode : NSUInteger {
    Clip = 0,
    Clamp = 1,
}

enum MTLTriangleFillMode : NSUInteger {
    Fill = 0,
    Lines = 1,
}

struct MTLDrawPrimitivesIndirectArguments {
    uint vertexCount;
    uint instanceCount;
    uint vertexStart;
    uint baseInstance;
}

struct MTLDrawIndexedPrimitivesIndirectArguments {
    uint indexCount;
    uint instanceCount;
    uint indexStart;
    int  baseVertex;
    uint baseInstance;
}

struct MTLVertexAmplificationViewMapping {
    uint viewportArrayIndexOffset;
    uint renderTargetArrayIndexOffset;
}

struct MTLDrawPatchIndirectArguments {
    uint patchCount;
    uint instanceCount;
    uint patchStart;
    uint baseInstance;
}

/**

    NOTE: edgeTessellationFactor and insideTessellationFactor are 
    interpreted as half (16-bit floats) 
*/
struct MTLQuadTessellationFactorsHalf {
    ushort[4] edgeTessellationFactor;
    ushort[2] insideTessellationFactor;
}

/**

    NOTE: edgeTessellationFactor and insideTessellationFactor are 
    interpreted as half (16-bit floats) 
*/
struct MTLTriangleTessellationFactorsHalf {
    ushort[3] edgeTessellationFactor;
    ushort insideTessellationFactor;
}

enum MTLRenderStages : NSUInteger {
    Vertex   = (1UL << 0),
    Fragment = (1UL << 1),
    Tile = (1UL << 2),
    Object = (1UL << 3),
    Mesh = (1UL << 4),
}

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

/**
    An interface that encodes a render pass into a command buffer, 
    including all its draw calls and configuration.
*/
@ObjectiveC @ObjcProtocol
class MTLRenderCommandEncoder : MTLCommandEncoder {
@nogc nothrow:
public:

    /**
        Base constructor
    */
    this(id self) { super(self); }

    /**
        Configures the encoder with a render or tile pipeline state instance 
        that applies to your subsequent draw commands.
    */
    void setRenderPipelineState(MTLRenderPipelineState pipelineState) @selector("setRenderPipelineState:");

    /**
        Encodes a command that instructs the GPU to pause before starting one or 
        more stages of the render pass until a pass updates a fence.
    */
    void waitForFence(MTLFence fence, MTLRenderStages stages) @selector("waitForFence:beforeStages:");

    /**
        Encodes a command that instructs the GPU to pause before starting one or 
        more stages of the render pass until a pass updates a fence.
    */
    void updateFence(MTLFence fence, MTLRenderStages stages) @selector("updateFence:afterStages:");

    /**
        Sets the active vertex buffer
    */
    void setVertexBuffer(MTLBuffer buffer, NSUInteger offset, NSUInteger stride, NSUInteger index) @selector("setVertexBuffer:offset:attributeStride:atIndex:");

    // Link
    mixin ObjcLink!("_MTLRenderCommandEncoder");
}

/**
    An interface that encodes a render pass into a command buffer, 
    including all its draw calls and configuration.
*/
@ObjectiveC @ObjcProtocol
class MTLComputeCommandEncoder : MTLCommandEncoder {
@nogc nothrow:
public:

    /**
        Base constructor
    */
    this(id self) { super(self); }


    // Link
    mixin ObjcLink!("_MTLComputeCommandEncoder");
}

/**
    An interface that encodes a render pass into a command buffer, 
    including all its draw calls and configuration.
*/
@ObjectiveC @ObjcProtocol
class MTLBlitCommandEncoder : MTLCommandEncoder {
@nogc nothrow:
public:

    /**
        Base constructor
    */
    this(id self) { super(self); }


    // Link
    mixin ObjcLink!("_MTLBlitCommandEncoder");
}


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