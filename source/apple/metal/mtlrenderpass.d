/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    MTLRenderPass
*/
module apple.metal.mtlrenderpass;
import apple.metal;
import apple.foundation;
import apple.coredata;
import apple.coregraphics;
import apple.uikit;
import apple.os;

import apple.objc;
import apple.objc : selector;

mixin RequireAPIs!(Metal, Foundation);

/**
    An RGBA value used for a color pixel.
*/
struct MTLClearColor {
    
    /**
        The red color channel.
    */
    double red;
    
    /**
        The green color channel.
    */
    double green;
    
    /**
        The blue color channel.
    */
    double blue;
    
    /**
        The alpha channel.
    */
    double alpha;
}

/**
    Types of actions performed for an attachment at the start of a rendering pass.
*/
enum MTLLoadAction : NSUInteger {
    
    /**
        The GPU has permission to discard the existing contents of the attachment 
        at the start of the render pass, replacing them with arbitrary data.
    */
    DontCare = 0,
    
    /**
        The GPU preserves the existing contents of the attachment at the start 
        of the render pass.
    */
    Load = 1,
    
    /**
        The GPU writes a value to every pixel in the attachment at the start 
        of the render pass.
    */
    Clear = 2,
}

/**
    Types of actions performed for an attachment at the end of a rendering pass. 
*/
enum MTLStoreAction : NSUInteger {
    
    /**
        The GPU has permission to discard the rendered contents of the attachment 
        at the end of the render pass, replacing them with arbitrary data.
    */
    DontCare = 0,
    
    /**
        The GPU stores the rendered contents to the texture.
    */
    Store = 1,
    
    /**
        The GPU resolves the multisampled data to one sample per pixel and stores 
        the data to the resolve texture, discarding the multisample data afterwards.
    */
    MultisampleResolve = 2,
    
    /**
        The GPU stores the multisample data to the multisample texture, 
        resolves the data to a sample per pixel, 
        and stores the data to the resolve texture.
    */
    StoreAndMultisampleResolve = 3,
    
    /**
        The app will specify the store action when it encodes the render pass. 
    */
    Unknown = 4,
    
    /**
        The GPU stores depth data in a sample-position–agnostic representation.
    */
    CustomSampleDepthStore = 5,
}

/**
    Options that modify a store action.
*/
enum MTLStoreActionOptions : NSUInteger {

    /**
        An option that doesn't modify the intended behavior of a store action.
    */
    None                  = 0,
    
    /**
        An option that stores data in a sample-position–agnostic representation.
    */
    CustomSamplePositions = 1 << 0,
}

/**
    A render target that serves as the output destination for pixels generated by a render pass.
*/
@ObjectiveC
class MTLRenderPassAttachmentDescriptor : NSObject {
@nogc nothrow:
public:

    /**
        The MTLTexture object for this attachment.
    */
    @property @__strong MTLTexture texture();
    @property void texture(@__strong MTLTexture);

    /**
        The mipmap level of the texture to be used for rendering.
        
        Default is zero.
    */
    @property NSUInteger level();
    @property void level(NSUInteger);

    /**
        The slice of the texture to be used for rendering.
        
        Default is zero.
    */
    @property NSUInteger slice();
    @property void slice(NSUInteger);

    /**
        The depth plane of the texture to be used for rendering.
        
        Default is zero.
    */
    @property NSUInteger depthPlane();
    @property void depthPlane(NSUInteger);

    /**
        The texture used for multisample resolve operations.
        Only used (and required) if the store action is set to 
        MultisampleResolve.
    */
    @property MTLTexture resolveTexture();
    @property void resolveTexture(MTLTexture);

    /**
        The mipmap level of the resolve texture to be used for 
        multisample resolve.
        
        Default is zero.
    */
    @property NSUInteger resolveLevel();
    @property void resolveLevel(NSUInteger);

    /**
        The texture slice of the resolve texture to be used for 
        multisample resolve.
        
        Default is zero.
    */
    @property NSUInteger resolveSlice();
    @property void resolveSlice(NSUInteger);

    /**
        The texture depth plane of the resolve texture to be used 
        for multisample resolve.
        
        Default is zero.
    */
    @property NSUInteger resolveDepthPlane();
    @property void resolveDepthPlane(NSUInteger);

    /**
        The action to be performed with this attachment at the beginning of a render pass.
        Default is DontCare unless specified by a creation or init method.
    */
    @property MTLLoadAction loadAction();
    @property void loadAction(MTLLoadAction);

    /**
        The action to be performed with this attachment at the end of a render pass.
        Default is DontCare unless specified by a creation or init method.
    */
    @property MTLStoreAction storeAction();
    @property void storeAction(MTLStoreAction);

    /**
        Optional configuration for the store action performed with this attachment at the end of a render pass.
        
        Default is None.
    */
    @property MTLStoreActionOptions storeActionOptions();
    @property void storeActionOptions(MTLStoreActionOptions);

    /**
        Base constructor
    */
    this(id self) { super(self); }

    /**
        Constructs a new MTLRenderPassAttachmentDescriptor
    */
    this() { super(); }


    // Link
    mixin ObjcLink!("MTLRenderPassAttachmentDescriptor");
}

/**
    A color render target that serves as the output destination 
    for color pixels generated by a render pass.
*/
@ObjectiveC
class MTLRenderPassColorAttachmentDescriptor : MTLRenderPassAttachmentDescriptor {
@nogc nothrow:
public:

    /**
        The clear color to be used if the loadAction property is Clear
    */
    @property MTLClearColor clearColor();
    @property void clearColor(MTLClearColor);

    /**
        Base constructor
    */
    this(id self) { super(self); }

    /**
        Constructs a new MTLRenderPassColorAttachmentDescriptor
    */
    this() { super(); }


    // Link
    mixin ObjcLink!("MTLRenderPassColorAttachmentDescriptor");
}

/**
    An array of render pass color attachment descriptor objects.
*/
@ObjectiveC
class MTLRenderPassColorAttachmentDescriptorArray : NSObject {
@nogc nothrow:
public:

    /**
        Base constructor
    */
    this(id self) { super(self); }

    /**
        Gets the MTLRenderPassColorAttachmentDescriptor at the specified index.
    */
    MTLRenderPassColorAttachmentDescriptor get(NSUInteger attachmentIndex) @selector("objectAtIndexedSubscript:");

    /*
        Sets the MTLRenderPassColorAttachmentDescriptor at the specified index.

        ### Note
        > This always uses 'copy' semantics.
        > It is safe to set the attachment state at any legal index to nil, 
        > which resets that attachment descriptor state to default values.
    */
    void set(MTLRenderPassColorAttachmentDescriptor attachment, NSUInteger attachmentIndex) @selector("setObject:atIndexedSubscript:");

    /**
        Gets the MTLRenderPassColorAttachmentDescriptor at the specified index.
    */
    @objc_ignore
    MTLRenderPassColorAttachmentDescriptor opIndex(size_t index) {
        return this.get(cast(NSUInteger)index);
    }

    /**
        Sets the MTLRenderPassColorAttachmentDescriptor at the specified index.
    */
    @objc_ignore
    void opIndexAssign(MTLRenderPassColorAttachmentDescriptor desc, size_t index) {
        this.set(desc, cast(NSUInteger)index);
    }

    // Link
    mixin ObjcLink!("MTLRenderPassColorAttachmentDescriptorArray");
}

/**
    Filtering options for controlling an MSAA depth resolve operation.
    
    Supported on iOS GPU Family 3 and later.
*/
enum MTLMultisampleDepthResolveFilter : NSUInteger {
    
    /**
        No filter is applied.
    */
    Sample0 = 0,
    
    /**
        The GPU compares all depth samples in the pixel and 
        selects the sample with the smallest value.
    */
    Min = 1,
    
    /**
        The GPU compares all depth samples in the pixel and 
        selects the sample with the largest value. 
    */
    Max = 2,
}

/**
    A depth render target that serves as the output destination 
    for depth pixels generated by a render pass.
*/
@ObjectiveC
class MTLRenderPassDepthAttachmentDescriptor : MTLRenderPassAttachmentDescriptor {
@nogc nothrow:
public:

    /**
        The clear depth value to be used if the loadAction property is Clear
    */
    @property double clearDepth();
    @property void clearDepth(double);

    /**
        The filter to be used for depth multisample resolve.
        
        Defaults to Sample0.
    */
    @property MTLMultisampleDepthResolveFilter depthResolveFilter();
    @property void depthResolveFilter(MTLMultisampleDepthResolveFilter);


    /**
        Base constructor
    */
    this(id self) { super(self); }

    /**
        Constructs a new MTLRenderPassDepthAttachmentDescriptor
    */
    this() { super(); }


    // Link
    mixin ObjcLink!("MTLRenderPassDepthAttachmentDescriptor");
}

/**
    Constants used to control the multisample stencil resolve operation.
*/
enum MTLMultisampleStencilResolveFilter : NSUInteger {

    /**
        The stencil sample corresponding to sample 0. 
        
        This is the default behavior.
    */
    Sample0               = 0,

    /**
        The stencil sample corresponding to whichever depth sample is selected by the depth resolve filter. 
        If depth resolve is not enabled, the stencil sample is chosen based on what a depth resolve filter 
        would have selected.
    */
    DepthResolvedSample   = 1,
}

/**
    A stencil render target that serves as the output destination 
    for stencil pixels generated by a render pass.
*/
@ObjectiveC
class MTLRenderPassStencilAttachmentDescriptor : MTLRenderPassAttachmentDescriptor {
@nogc nothrow:
public:

    /**
        The clear stencil value to be used if the loadAction property is Clear
    */
    @property uint clearDepth();
    @property void clearDepth(uint);

    /**
        The filter to be used for stencil multisample resolve. 
        
        Defaults to Sample0.
    */
    @property MTLMultisampleStencilResolveFilter stencilResolveFilter();
    @property void stencilResolveFilter(MTLMultisampleStencilResolveFilter);

    /**
        Base constructor
    */
    this(id self) { super(self); }

    /**
        Constructs a new MTLRenderPassStencilAttachmentDescriptor
    */
    this() { super(); }


    // Link
    mixin ObjcLink!("MTLRenderPassStencilAttachmentDescriptor");
}


/**
    A group of render targets that hold the results of a render pass.
*/
@ObjectiveC
class MTLRenderPassDescriptor : NSObject {
@nogc nothrow:
public:

    /**
        Create an autoreleased default frame buffer descriptor
    */
    static MTLRenderPassDescriptor create() @selector("renderPassDescriptor");

    /**
        Color attachments.
    */
    @property MTLRenderPassColorAttachmentDescriptorArray colorAttachments() const;

    /**
        Depth attachment.
    */
    @property MTLRenderPassDepthAttachmentDescriptor depthAttachment();
    @property void depthAttachment(MTLRenderPassDepthAttachmentDescriptor);

    /**
        Stencil attachment.
    */
    @property MTLRenderPassStencilAttachmentDescriptor stencilAttachment();
    @property void stencilAttachment(MTLRenderPassStencilAttachmentDescriptor);

    /**
        Buffer into which samples passing the depth and stencil tests are counted.
    */
    @property MTLBuffer visibilityResultBuffer();
    @property void visibilityResultBuffer(MTLBuffer);

    /**
        The number of active layers.
    */
    @property NSUInteger renderTargetArrayLength();
    @property void renderTargetArrayLength(NSUInteger);

    /**
        The per sample size in bytes of the largest explicit imageblock layout in the renderPass.
    */
    @property NSUInteger imageblockSampleLength();
    @property void imageblockSampleLength(NSUInteger);

    /**
        The per tile size in bytes of the persistent threadgroup memory allocation.
    */
    @property NSUInteger threadgroupMemoryLength();
    @property void threadgroupMemoryLength(NSUInteger);

    /**
        The width in pixels of the tile.

        Defaults to 0.
        Zero means Metal chooses a width that fits within the local memory.
    */
    @property NSUInteger tileWidth();
    @property void tileWidth(NSUInteger);

    /**
        The height in pixels of the tile.

        Defaults to 0.
        Zero means Metal chooses a height that fits within the local memory.
    */
    @property NSUInteger tileHeight();
    @property void tileHeight(NSUInteger);

    /**
        The raster sample count for the render pass when no attachments are given.
    */
    @property NSUInteger defaultRasterSampleCount();
    @property void defaultRasterSampleCount(NSUInteger);

    /**
        The width in pixels to constrain the render target to.

        Defaults to 0.
        
        If non-zero the value must be smaller than or equal to the minimum 
        width of all attachments.
    */
    @property NSUInteger renderTargetWidth();
    @property void renderTargetWidth(NSUInteger);

    /**
        The height in pixels to constrain the render target to.

        Defaults to 0. 
        
        If non-zero the value must be smaller than or equal to the minimum 
        height of all attachments.
    */
    @property NSUInteger renderTargetHeight();
    @property void renderTargetHeight(NSUInteger);

    /**
        Base constructor
    */
    this(id self) { super(self); }

    /**
        Base constructor
    */
    this() { super(); }

    /**
        Configure the custom sample positions, to be used in MSAA rendering 
        (i.e. when sample count > 1).
    */
    void setSamplePositions(const(MTLSamplePosition)* position, NSUInteger count) @selector("setSamplePositions:count:");

    /**
        Retrieve the previously configured custom sample positions. 

        The positions input array will only be modified when count specifies a length 
        sufficient for the number of previously configured positions.
    */
    NSUInteger getSamplePositions(MTLSamplePosition* position, NSUInteger count) @selector("getSamplePositions:count:");

    // Link
    mixin ObjcLink!("MTLRenderPassDescriptor");
}
