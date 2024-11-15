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
import apple.corefoundation;

import apple.os;
import apple.objc;
import apple.objc : selector;

mixin RequireAPIs!(Metal, Foundation);

@ObjectiveC @ObjcProtocol
class MTLBuffer : MTLResource {
@nogc nothrow:
public:

    /**
        Gets the system address of the buffer’s storage allocation.
    */
    @property void* contents();

    /**
        The logical size of the buffer, in bytes.
    */
    @property NSUInteger length() const;

    /**
        The logical size of the buffer, in bytes.
    */
    @property ulong gpuAddress() const;

    /**
        The logical size of the buffer, in bytes.
    */
    @property MTLBuffer remoteStorageBuffer() const;
    
    /**
        Base constructor
    */
    this(id self) { super(self); }

    /**
        Informs the GPU that the CPU has modified a section of the buffer.
    */
    void didModifyRange(NSRange range) @selector("didModifyRange:");

    /**
        Creates a texture that shares its storage with the buffer.
    */
    MTLTexture newTexture(MTLTextureDescriptor descriptor, NSUInteger offset, NSUInteger bytesPerRow) @selector("newTextureWithDescriptor:offset:bytesPerRow:");

    // Link
    mixin ObjcLink!("MTLBuffer");
}