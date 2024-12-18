/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    MTLCommandBuffer
*/
module apple.metal.mtlrendercommandencoder;
import apple.metal;
import apple.foundation;

import apple.os;
import apple.objc;
import apple.objc : selector;

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
    An interface that encodes a render pass into a command buffer, 
    including all its draw calls and configuration.
*/
@ObjectiveC @ObjcProtocol
class MTLRenderCommandEncoder : MTLCommandEncoder {
@nogc nothrow:
public:

    /**
        The width of the tiles, in pixels, for the render command encoder.
    */
    @property NSUInteger tileWidth() const;

    /**
        The height of the tiles, in pixels, for the render command encoder.
    */
    @property NSUInteger tileHeight() const;

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
        Configures the store action for a color attachment.
    */
    void setColorStoreAction(MTLStoreAction storeAction, NSUInteger atIndex) @selector("setColorStoreAction:atIndex:");

    /**
        Configures the store action options for a color attachment.
    */
    void setColorStoreActionOptions(MTLStoreActionOptions storeActionOptions, NSUInteger atIndex) @selector("setColorStoreActionOptions:atIndex:");

    /**
        Configures the store action for the depth attachment.
    */
    void setDepthStoreAction(MTLStoreAction storeAction, NSUInteger atIndex) @selector("setDepthStoreAction:atIndex:");

    /**
        Configures the store action options for a depth attachment.
    */
    void setDepthStoreActionOptions(MTLStoreActionOptions storeActionOptions, NSUInteger atIndex) @selector("setDepthStoreActionOptions:atIndex:");

    /**
        Configures the store action for a stencil  attachment.
    */
    void setStencilStoreAction(MTLStoreAction storeAction, NSUInteger atIndex) @selector("setStencilStoreAction:atIndex:");

    /**
        Configures the store action options for a stencil  attachment.
    */
    void setStencilStoreActionOptions(MTLStoreActionOptions storeActionOptions, NSUInteger atIndex) @selector("setStencilStoreActionOptions:atIndex:");

    /**
        Configures each pixel component value, including alpha, 
        for the render pipeline’s constant blend color.
    */
    void setBlendColor(float r, float g, float b, float a) @selector("setBlendColorRed:green:blue:alpha:");

    /**
        Configures how subsequent draw commands rasterize triangle and triangle strip primitives.
    */
    void setTriangleFillMode(MTLTriangleFillMode fillMode) @selector("setTriangleFillMode:");

    /**
        Configures which face of a primitive, such as a triangle, is the front.
    */
    void setFrontFacingWinding(MTLWinding winding) @selector("setFrontFacingWinding:");

    /**
        Configures how the render pipeline determines 
        which primitives to remove.
    */
    void setCullMode(MTLCullMode winding) @selector("setCullMode:");

    /**
        Configures the combined depth and stencil state.
    */
    // void setDepthStencilState(MTLDepthStencilState depthStencilState) @selector("setDepthStencilState:");

    /**
        Configures the adjustments a render pass applies to depth values from 
        fragment functions by a scaling factor and bias.
    */
    void setDepthBias(float depthBias, float slopeScale, float clamp) @selector("setDepthBias:slopeScale:clamp:");

    /**
        Configures the same comparison value for front- and back-facing primitives.
    */
    void setStencilReferenceValue(uint refValue) @selector("setStencilReferenceValue:");

    /**
        Configures different comparison values for front- and back-facing primitives.
    */
    void setStencilReferenceValues(uint frontValue, uint backValue) @selector("setStencilFrontReferenceValue:backReferenceValue:");

    /**
        Configures the render pipeline with a viewport that applies a 
        transformation and a clipping rectangle.
    */
    void setViewport(MTLViewport viewport) @selector("setViewport:");

    /**
        Configures the render pipeline with multiple viewports that apply 
        transformations and clipping rectangles.
    */
    void setViewports(const(MTLViewport)* viewports, NSUInteger count) @selector("setViewports:count:");

    /**
        Configures a rectangle for the fragment scissor test.
    */
    void setScissorRect(MTLScissorRect rect) @selector("setViewport:");

    /**
        Configures multiple rectangles for the fragment scissor test.
    */
    void setScissorRects(const(MTLScissorRect)* rects, NSUInteger count) @selector("setScissorRects:count:");

    /**
        Configures which visibility test the GPU runs and the destination 
        for any results it generates.
    */
    void setVisibilityResultMode(MTLVisibilityResultMode mode, NSUInteger offset) @selector("setVisibilityResultMode:offset:");

    /**
        Configures the number of output vertices the render pipeline produces 
        for each input vertex, optionally with render target and viewport offsets.
    */
    void setVertexAmplification(NSUInteger count, const(MTLVertexAmplificationViewMapping)* mappings) @selector("setVertexAmplificationCount:viewMappings:");

    /**
        Configures the scale factor for per-patch tessellation factors.
    */
    void setTessellationFactorScale(float scale) @selector("setTessellationFactorScale:");

    /**
        Configures the per-patch tessellation factors for any subsequent 
        patch-drawing commands.
    */
    void setTessellationFactorBuffer(MTLBuffer buffer, NSUInteger offset, NSUInteger stride) @selector("setTessellationFactorBuffer:offset:instanceStride:");

    /**
        Configures the size of a threadgroup memory buffer for an entry 
        in the object argument table.
    */
    void setObjectThreadgroupMemoryLength(NSUInteger length, NSUInteger atIndex) @selector("setObjectThreadgroupMemoryLength:atIndex:");

    /**
        Configures the size of a threadgroup memory buffer for an entry 
        in the fragment or tile shader argument table.
    */
    void setThreadgroupMemoryLength(NSUInteger length, NSUInteger offset, NSUInteger atIndex) @selector("setThreadgroupMemoryLength:offset:atIndex:");

    //
    //          OBJECT SHADERS
    //

    /**
        Assigns a buffer to an entry in the object shader argument table.
    */
    void setObjectBuffer(MTLBuffer buffer, NSUInteger offset, NSUInteger atIndex) @selector("setObjectBuffer:offset:atIndex:");

    /**
        Encodes a command that assigns multiple buffers to a range of 
        entries in the object shader argument table.
    */
    void setObjectBuffers(const(idref!MTLBuffer)* buffers, const(NSUInteger)* offsets, NSRange range) @selector("setObjectBuffers:offsets:withRange:");

    /**
        Assigns a texture to an entry in the object shader argument table.
    */
    void setObjectTexture(MTLTexture buffer, NSUInteger atIndex) @selector("setObjectTexture:atIndex:");

    /**
        Encodes a command that assigns multiple buffers to a range of 
        entries in the object shader argument table.
    */
    void setObjectTextures(const(idref!MTLTexture)* textures, NSRange range) @selector("setObjectTextures:withRange:");

    /**
        Assigns a sampler state to an entry in the object shader argument table.
    */
    void setObjectSamplerState(MTLSamplerState, NSUInteger atIndex) @selector("setObjectSamplerState:atIndex:");

    /**
        Assigns a sampler state and clamp values to an entry in the object shader argument table.
    */
    void setObjectSamplerState(MTLSamplerState, float lodMinClamp, float lodMaxClamp, NSUInteger atIndex) @selector("setObjectSamplerState:lodMinClamp:lodMaxClamp:atIndex:");

    /**
        Assigns multiple sampler states to a range of entries in the object shader argument table.
    */
    void setObjectSamplerStates(const(idref!MTLSamplerState)* samplers, NSRange range) @selector("setObjectSamplerStates:withRange:");

    /**
        Assigns multiple sampler states to a range of entries in the object shader argument table.
    */
    void setObjectSamplerStates(const(idref!MTLSamplerState)* samplers, const(float)* lodMinClamps, const(float)* lodMaxClamps, NSRange range) @selector("setObjectSamplerStates:lodMinClamps:lodMaxClamps:withRange:");

    //
    //          MESH SHADERS
    //

    /**
        Assigns a buffer to an entry in the object shader argument table.
    */
    void setMeshBuffer(MTLBuffer buffer, NSUInteger offset, NSUInteger atIndex) @selector("setMeshBuffer:offset:atIndex:");

    /**
        Encodes a command that assigns multiple buffers to a range of 
        entries in the object shader argument table.
    */
    void setMeshBuffers(const(idref!MTLBuffer)* buffers, const(NSUInteger)* offsets, NSRange range) @selector("setMeshBuffers:offsets:withRange:");

    /**
        Assigns a texture to an entry in the object shader argument table.
    */
    void setMeshTexture(MTLTexture buffer, NSUInteger atIndex) @selector("setMeshTexture:atIndex:");

    /**
        Encodes a command that assigns multiple buffers to a range of 
        entries in the object shader argument table.
    */
    void setMeshTextures(const(idref!MTLTexture)* textures, NSRange range) @selector("setMeshTextures:withRange:");

    /**
        Assigns a sampler state to an entry in the object shader argument table.
    */
    void setMeshSamplerState(MTLSamplerState, NSUInteger atIndex) @selector("setMeshSamplerState:atIndex:");

    /**
        Assigns a sampler state and clamp values to an entry in the object shader argument table.
    */
    void setMeshSamplerState(MTLSamplerState, float lodMinClamp, float lodMaxClamp, NSUInteger atIndex) @selector("setMeshSamplerState:lodMinClamp:lodMaxClamp:atIndex:");

    /**
        Assigns multiple sampler states to a range of entries in the object shader argument table.
    */
    void setMeshSamplerStates(const(idref!MTLSamplerState)* samplers, NSRange range) @selector("setMeshSamplerStates:withRange:");

    /**
        Assigns multiple sampler states to a range of entries in the object shader argument table.
    */
    void setMeshSamplerStates(const(idref!MTLSamplerState)* samplers, const(float)* lodMinClamps, const(float)* lodMaxClamps, NSRange range) @selector("setMeshSamplerStates:lodMinClamps:lodMaxClamps:withRange:");

    //
    //          VERTEX SHADERS
    //

    /**
        Assigns a buffer to an entry in the object shader argument table.
    */
    void setVertexBuffer(MTLBuffer buffer, NSUInteger offset, NSUInteger atIndex) @selector("setVertexBuffer:offset:atIndex:");

    /**
        Encodes a command that assigns multiple buffers to a range of 
        entries in the object shader argument table.
    */
    void setVertexBuffers(const(idref!MTLBuffer)* buffers, const(NSUInteger)* offsets, NSRange range) @selector("setVertexBuffers:offsets:withRange:");

    /**
        Assigns a texture to an entry in the object shader argument table.
    */
    void setVertexTexture(MTLTexture buffer, NSUInteger atIndex) @selector("setVertexTexture:atIndex:");

    /**
        Encodes a command that assigns multiple buffers to a range of 
        entries in the object shader argument table.
    */
    void setVertexTextures(const(idref!MTLTexture)* textures, NSRange range) @selector("setVertexTextures:withRange:");

    /**
        Assigns a sampler state to an entry in the object shader argument table.
    */
    void setVertexSamplerState(MTLSamplerState, NSUInteger atIndex) @selector("setVertexSamplerState:atIndex:");

    /**
        Assigns a sampler state and clamp values to an entry in the object shader argument table.
    */
    void setVertexSamplerState(MTLSamplerState, float lodMinClamp, float lodMaxClamp, NSUInteger atIndex) @selector("setVertexSamplerState:lodMinClamp:lodMaxClamp:atIndex:");

    /**
        Assigns multiple sampler states to a range of entries in the object shader argument table.
    */
    void setVertexSamplerStates(const(idref!MTLSamplerState)* samplers, NSRange range) @selector("setVertexSamplerStates:withRange:");

    /**
        Assigns multiple sampler states to a range of entries in the object shader argument table.
    */
    void setVertexSamplerStates(const(idref!MTLSamplerState)* samplers, const(float)* lodMinClamps, const(float)* lodMaxClamps, NSRange range) @selector("setVertexSamplerStates:lodMinClamps:lodMaxClamps:withRange:");

    //
    //          FRAGMENT SHADERS
    //

    /**
        Assigns a buffer to an entry in the object shader argument table.
    */
    void setFragmentBuffer(MTLBuffer buffer, NSUInteger offset, NSUInteger atIndex) @selector("setFragmentBuffer:offset:atIndex:");

    /**
        Encodes a command that assigns multiple buffers to a range of 
        entries in the object shader argument table.
    */
    void setFragmentBuffers(const(idref!MTLBuffer)* buffers, const(NSUInteger)* offsets, NSRange range) @selector("setFragmentBuffers:offsets:withRange:");

    /**
        Assigns a texture to an entry in the object shader argument table.
    */
    void setFragmentTexture(MTLTexture buffer, NSUInteger atIndex) @selector("setFragmentTexture:atIndex:");

    /**
        Encodes a command that assigns multiple buffers to a range of 
        entries in the object shader argument table.
    */
    void setFragmentTextures(const(idref!MTLTexture)* textures, NSRange range) @selector("setFragmentTextures:withRange:");

    /**
        Assigns a sampler state to an entry in the object shader argument table.
    */
    void setFragmentSamplerState(MTLSamplerState, NSUInteger atIndex) @selector("setFragmentSamplerState:atIndex:");

    /**
        Assigns a sampler state and clamp values to an entry in the object shader argument table.
    */
    void setFragmentSamplerState(MTLSamplerState, float lodMinClamp, float lodMaxClamp, NSUInteger atIndex) @selector("setFragmentSamplerState:lodMinClamp:lodMaxClamp:atIndex:");

    /**
        Assigns multiple sampler states to a range of entries in the object shader argument table.
    */
    void setFragmentSamplerStates(const(idref!MTLSamplerState)* samplers, NSRange range) @selector("setFragmentSamplerStates:withRange:");

    /**
        Assigns multiple sampler states to a range of entries in the object shader argument table.
    */
    void setFragmentSamplerStates(const(idref!MTLSamplerState)* samplers, const(float)* lodMinClamps, const(float)* lodMaxClamps, NSRange range) @selector("setFragmentSamplerStates:lodMinClamps:lodMaxClamps:withRange:");

    //
    //          TILE SHADERS
    //

    /**
        Assigns a buffer to an entry in the object shader argument table.
    */
    void setTileBuffer(MTLBuffer buffer, NSUInteger offset, NSUInteger atIndex) @selector("setTileBuffer:offset:atIndex:");

    /**
        Encodes a command that assigns multiple buffers to a range of 
        entries in the object shader argument table.
    */
    void setTileBuffers(const(idref!MTLBuffer)* buffers, const(NSUInteger)* offsets, NSRange range) @selector("setTileBuffers:offsets:withRange:");

    /**
        Assigns a texture to an entry in the object shader argument table.
    */
    void setTileTexture(MTLTexture buffer, NSUInteger atIndex) @selector("setTileTexture:atIndex:");

    /**
        Encodes a command that assigns multiple buffers to a range of 
        entries in the object shader argument table.
    */
    void setTileTextures(const(idref!MTLTexture)* textures, NSRange range) @selector("setTileTextures:withRange:");

    /**
        Assigns a sampler state to an entry in the object shader argument table.
    */
    void setTileSamplerState(MTLSamplerState, NSUInteger atIndex) @selector("setTileSamplerState:atIndex:");

    /**
        Assigns a sampler state and clamp values to an entry in the object shader argument table.
    */
    void setTileSamplerState(MTLSamplerState, float lodMinClamp, float lodMaxClamp, NSUInteger atIndex) @selector("setTileSamplerState:lodMinClamp:lodMaxClamp:atIndex:");

    /**
        Assigns multiple sampler states to a range of entries in the object shader argument table.
    */
    void setTileSamplerStates(const(idref!MTLSamplerState)* samplers, NSRange range) @selector("setTileSamplerStates:withRange:");

    /**
        Assigns multiple sampler states to a range of entries in the object shader argument table.
    */
    void setTileSamplerStates(const(idref!MTLSamplerState)* samplers, const(float)* lodMinClamps, const(float)* lodMaxClamps, NSRange range) @selector("setTileSamplerStates:lodMinClamps:lodMaxClamps:withRange:");

    //
    //      DRAWING COMMANDS
    //

    /**
        Encodes a draw command that renders an instance of a geometric primitive.
    */
    void draw(MTLPrimitiveType primitiveType, NSUInteger start, NSUInteger count) @selector("drawPrimitives:vertexStart:vertexCount:");

    /**
        Encodes a draw command that renders multiple instances of a geometric primitive.
    */
    void draw(MTLPrimitiveType primitiveType, NSUInteger start, NSUInteger count, NSUInteger instances) @selector("drawPrimitives:vertexStart:vertexCount:instanceCount:");

    /**
        Encodes a draw command that renders multiple instances of a geometric primitive that 
        starts with a custom instance identification number.
    */
    void draw(MTLPrimitiveType primitiveType, NSUInteger start, NSUInteger count, NSUInteger instances, NSUInteger baseInstance) @selector("drawPrimitives:vertexStart:vertexCount:instanceCount:baseInstance:");

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
