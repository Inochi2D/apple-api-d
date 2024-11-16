/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    MTLRenderPass
*/
module apple.metal.mtlblitpass;
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
    A configuration that instructs the GPU where to store counter data 
    from the beginning and end of a blit pass.
*/
@ObjectiveC
class MTLBlitPassSampleBufferAttachmentDescriptor : NSObject, NSCopying {
@nogc nothrow:
public:

    /**
        An index within a counter sample buffer that tells the GPU where to 
        store counter data from the start of a blit pass.
    */
    @property NSUInteger startOfEncoderSampleIndex();
    @property void startOfEncoderSampleIndex(NSUInteger);

    /**
        An index within a counter sample buffer that tells the GPU where to 
        store counter data from the end of a blit pass.
    */
    @property NSUInteger endOfEncoderSampleIndex();
    @property void endOfEncoderSampleIndex(NSUInteger);


    // TODO: sampleBuffer

    /**
        Base constructor
    */
    this(id self) { super(self); }

    /**
        Constructs a new MTLRenderPassColorAttachmentDescriptor
    */
    this() { super(); }


    // Link MTLBlitPassSampleBufferAttachmentDescriptor.
    mixin ObjcLink;
}

/**
    A container that stores an array of sample buffer attachments for a blit pass.
*/
@ObjectiveC
class MTLBlitPassSampleBufferAttachmentDescriptorArray : NSObject {
@nogc nothrow:
public:

    /**
        Base constructor
    */
    this(id self) { super(self); }

    /**
        Gets the MTLBlitPassSampleBufferAttachmentDescriptor at the specified index.
    */
    MTLBlitPassSampleBufferAttachmentDescriptor get(NSUInteger attachmentIndex) @selector("objectAtIndexedSubscript:");

    /*
        Sets the MTLBlitPassSampleBufferAttachmentDescriptor at the specified index.

        ### Note
        > This always uses 'copy' semantics.
        > It is safe to set the attachment state at any legal index to nil, 
        > which resets that attachment descriptor state to default values.
    */
    void set(MTLBlitPassSampleBufferAttachmentDescriptor attachment, NSUInteger attachmentIndex) @selector("setObject:atIndexedSubscript:");

    /**
        Gets the MTLBlitPassSampleBufferAttachmentDescriptor at the specified index.
    */
    @objc_ignore
    MTLBlitPassSampleBufferAttachmentDescriptor opIndex(size_t index) {
        return this.get(cast(NSUInteger)index);
    }

    /**
        Sets the MTLBlitPassSampleBufferAttachmentDescriptor at the specified index.
    */
    @objc_ignore
    void opIndexAssign(MTLBlitPassSampleBufferAttachmentDescriptor desc, size_t index) {
        this.set(desc, cast(NSUInteger)index);
    }

    // Link MTLBlitPassSampleBufferAttachmentDescriptorArray.
    mixin ObjcLink;
}

/**
    A configuration you create to customize a blit command encoder, which affects the 
    runtime behavior of the blit pass you encode with it.
*/
@ObjectiveC
class MTLBlitPassDescriptor : NSObject, NSCopying {
@nogc nothrow:
public:

    /**
        An array of counter sample buffer attachments that you configure for a blit pass.
    */
    @property MTLBlitPassSampleBufferAttachmentDescriptor sampleBufferAttachments() const;

    /**
        Base constructor
    */
    this(id self) { super(self); }

    /**
        Base constructor
    */
    this() { super(); }


    // Link MTLBlitPassDescriptor.
    mixin ObjcLink;
}