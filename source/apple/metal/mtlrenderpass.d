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

struct MTLClearColor {
    double red;
    double green;
    double blue;
    double alpha;
}

/**

*/
enum MTLLoadAction : NSUInteger {
    DontCare = 0,
    Load = 1,
    Clear = 2,
}

/**

*/
enum MTLStoreAction : NSUInteger {
    DontCare = 0,
    Store = 1,
    MultisampleResolve = 2,
    StoreAndMultisampleResolve = 3,
    Unknown = 4,
    CustomSampleDepthStore = 5,
}

/**

*/
enum MTLStoreActionOptions : NSUInteger {
    None                  = 0,
    CustomSamplePositions = 1 << 0,
}

/**
    A memory fence to capture, track, and manage resource dependencies across command encoders.
*/
@ObjectiveC
class MTLRenderPassAttachmentDescriptor : NSObject {
@nogc nothrow:
public:

    /**
        The MTLTexture object for this attachment.
    */
    @property MTLTexture texture();
    @property void texture(MTLTexture);

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


    // Link
    mixin ObjcLink!("MTLRenderPassAttachmentDescriptor");
}

/**
    
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
        Constructs a new MTLRenderPassDepthAttachmentDescriptor
    */
    this() { super(this.alloc()); this.self = this.init(); }


    // Link
    mixin ObjcLink!("MTLRenderPassColorAttachmentDescriptor");
}

/**
    Controls the MSAA depth resolve operation.
    
    Supported on iOS GPU Family 3 and later.
*/
enum MTLMultisampleDepthResolveFilter : NSUInteger {
    Sample0 = 0,
    Min = 1,
    Max = 2,
}

/**
    
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
    this() { super(this.alloc()); this.self = this.init(); }


    // Link
    mixin ObjcLink!("MTLRenderPassDepthAttachmentDescriptor");
}

/**
    Controls the MSAA stencil resolve operation.
*/
enum MTLMultisampleStencilResolveFilter : NSUInteger {

    /**
        The stencil sample corresponding to sample 0. This is the default behavior.
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
    this() { super(this.alloc()); this.self = this.init(); }


    // Link
    mixin ObjcLink!("MTLRenderPassStencilAttachmentDescriptor");
}

/**
    
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
        Constructs a new MTLRenderPassColorAttachmentDescriptorArray
    */
    this() { super(this.alloc()); this.self = this.init(); }

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

    // Link
    mixin ObjcLink!("MTLRenderPassColorAttachmentDescriptorArray");
}
