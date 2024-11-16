/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    MTLTexture
*/
module apple.metal.mtltexture;
import apple.metal;
import apple.foundation;
import apple.corefoundation;

import apple.os;
import apple.objc;
import apple.objc : selector;

mixin RequireAPIs!(Metal, Foundation);


enum MTLTextureType : NSUInteger {
    Type1D = 0,
    Type1DArray = 1,
    Type2D = 2,
    Type2DArray = 3,
    Type2DMultisample = 4,
    TypeCube = 5,
    TypeCubeArray = 6,
    Type3D = 7,
    Type2DMultisampleArray = 8,
    TypeTextureBuffer = 9,
}

enum MTLTextureSwizzle : ubyte {
    Zero = 0,
    One = 1,
    Red = 2,
    Green = 3,
    Blue = 4,
    Alpha = 5,
}

struct MTLTextureSwizzleChannels {
@nogc nothrow:
    MTLTextureSwizzle red;
    MTLTextureSwizzle green;
    MTLTextureSwizzle blue;
    MTLTextureSwizzle alpha;
}

// TODO:
// @ObjectiveC
// class MTLSharedTextureHandle : NSSecureCoding {

// }

enum MTLTextureUsage : NSUInteger {
    Unknown = 0,
    ShaderRead = 1,
    ShaderWrite = 2,
    RenderTarget = 4,
    PixelFormatView = 16,
    ShaderAtomic = 32,
}

enum MTLTextureCompressionType : NSInteger {
    Lossless = 0,
    Lossy = 1,
}

/**
    An object that you use to configure new Metal texture objects.

    To create a new texture, first create a MTLTextureDescriptor object and set its property values. 
    Then, call either the [newTextureWithDescriptor] method of a [MTLDevice] object, 
    or the [newTextureWithDescriptor] method of a [MTLBuffer] object.

    When you create a texture, Metal copies property values from the descriptor into the new texture. 
    You can reuse a MTLTextureDescriptor object, modifying its property values as needed, 
    to create more MTLTexture objects, without affecting any textures you already created.
*/
@ObjectiveC
class MTLTextureDescriptor : NSObject {
@nogc nothrow:
public:

    /**
        The dimension and arrangement of texture image data.
    */
    @property MTLTextureType textureType();
    @property void textureType(MTLTextureType);

    /**
        The size and bit layout of all pixels in the texture.
    */
    @property MTLPixelFormat pixelFormat();
    @property void pixelFormat(MTLPixelFormat);

    /**
        The width of the texture image for the base level mipmap, in pixels.
    */
    @property NSUInteger width();
    @property void width(NSUInteger);

    /**
        The height of the texture image for the base level mipmap, in pixels.
    */
    @property NSUInteger height();
    @property void height(NSUInteger);

    /**
        The depth of the texture image for the base level mipmap, in pixels.
    */
    @property NSUInteger depth();
    @property void depth(NSUInteger);

    /**
        The number of mipmap levels for this texture.
    */
    @property NSUInteger mipmapLevelCount();
    @property void mipmapLevelCount(NSUInteger);

    /**
        The number of samples in each fragment. 
    */
    @property NSUInteger sampleCount();
    @property void sampleCount(NSUInteger);

    /**
        The number of array elements for this texture. 
    */
    @property NSUInteger arrayLength();
    @property void arrayLength(NSUInteger);

    /**
        Options that determine how you can use the texture.
    */
    @property MTLTextureUsage usage();
    @property void usage(MTLTextureUsage);

    /**
        The type of compression to use for the texture
    */
    @property MTLTextureCompressionType compressionType();
    @property void compressionType(MTLTextureCompressionType);

    /**
        The pattern you want the GPU to apply to pixels when you 
        read or sample pixels from the texture.
    */
    @property MTLTextureSwizzleChannels swizzle();
    @property void swizzle(MTLTextureSwizzleChannels);

    /**
        Base constructor
    */
    this(id self) { super(self); }

    /**
        Constructs a new empty Texture Descriptor
    */
    this() { super(); }

    // Link MTLTextureDescriptor.
    mixin ObjcLink;
}

/**
    A resource that holds formatted image data.

    # Overview
    Don’t implement this protocol yourself; instead, use one of the following methods to create a MTLTexture instance:

        * Create a [MTLTextureDescriptor] to describe the texture’s properties and then call the  
          [MTLDevice.newTexture] method of the MTLDevice to create the texture.
        
        * To create a texture that uses an existing [IOSurface] to hold the texture data, create a [MTLTextureDescriptor]    
          to describe the image data in the surface.  
          [MTLDevice.newTexture] method of the MTLDevice to create the texture while passing the IOSurface.

        * To create a texture that reinterprets another texture’s data as if it had a different format,  
          call one of the [MTLTexture.newTextureView] methods on a [MTLTexture] instance.  
          You must choose a pixel format for the new texture compatible with the source texture’s pixel format.  
          The new texture shares the same storage allocation as the source texture.  
          If you make changes to the new texture, the source texture reflects those changes, and vice versa.

        * To create a texture that uses an MTLBuffer instance’s contents to hold pixel data,  
          create a [MTLTextureDescriptor] to describe the texture’s properties.  
          Then call the [MTLBuffer.newTexture] method on the buffer object.  
          The new texture object shares the storage allocation of the source buffer object.  
          If you make changes to the texture, the buffer reflects those changes, and vice versa.

    After you create a [MTLTexture] object, most of its characteristics, such as its size, type, and pixel format are all immutable. 
    Only the texture’s pixel data is mutable.

    To copy pixel data from system memory into the texture, call [MTLTexture.replaceRegion].
    To copy pixel data back to system memory, call one of the [MTLTexture.getBytes] methods.
*/
@ObjectiveC
class MTLTexture : MTLResource {
@nogc nothrow:
public:

    /**
        The dimension and arrangement of the texture image data.
    */
    @property MTLTextureType textureType() const;

    /**
        The format of pixels in the texture.
    */
    @property MTLPixelFormat pixelFormat() const;

    /**
        The width of the texture image for the base level mipmap, in pixels.
    */
    @property NSUInteger width() const;

    /**
        The height of the texture image for the base level mipmap, in pixels.
    */
    @property NSUInteger height() const;

    /**
        The depth of the texture image for the base level mipmap, in pixels.
    */
    @property NSUInteger depth() const;

    /**
        The number of mipmap levels in the texture.
    */
    @property NSUInteger mipmapLevelCount() const;

    /**
        The number of slices in the texture array.
    */
    @property NSUInteger arrayLength() const;

    /**
        The number of samples in each pixel.
    */
    @property NSUInteger sampleCount() const;

    /**
        A Boolean value that indicates whether the texture can 
        only be used as a render target. 
    */
    @property bool framebufferOnly() const @selector("isFramebufferOnly");

    /**
        Options that determine how you can use the texture.
    */
    @property MTLTextureUsage usage() const;

    /**
        A Boolean value indicating whether the GPU is allowed to 
        adjust the contents of the texture to improve GPU performance.
    */
    @property bool allowGPUOptimizedContents() const;

    /**
        A Boolean indicating whether this texture can be shared with 
        other processes.
    */
    @property bool shareable() const @selector("isShareable");

    /**
        The pattern that the GPU applies to pixels when you 
        read or sample pixels from the texture.
    */
    @property MTLTextureSwizzleChannels swizzle() const;

    /**
        A reference to the IOSurface the texture was created from, if any.
    */
    version(IOSurface)
    @property IOSurfaceRef iosurface() const;

    /**
        The plane of the IOSurface to reference if any.
    */
    version(IOSurface)
    @property NSUInteger iosurfacePlane() const;

    /**
        The parent texture used to create this texture, if any.
    */
    @property MTLTexture parentTexture() const;

    /**
        The base level of the parent texture used to create this texture.
    */
    @property NSUInteger parentRelativeLevel() const;

    /**
        The base slice of the parent texture used to create this texture.
    */
    @property NSUInteger parentRelativeSlice() const;

    /**
        The source buffer used to create this texture, if any.
    */
    @property MTLBuffer buffer() const;

    /**
        The type of compression to use for the texture
    */
    @property MTLTextureCompressionType compressionType() const;

    /**
        Constructor.
    */
    this(id ref_) { super(ref_); }

    // Link MTLTexture.
    mixin ObjcLink!("MTLTextureReferenceType");
}

/**
    A texture handle that can be shared across process address space boundaries.

    MTLSharedTextureHandle objects may be passed between processes using 
    XPC connections and then used to create a reference to the texture in another process. 

    The texture in the other process must be created using the same MTLDevice on which the 
    shared texture was originally created. To identify which device it was created on, you can use 
    the device property of the MTLSharedTextureHandle object.
*/
@ObjectiveC
class MTLSharedTextureHandle : NSObject {
@nogc nothrow:
public:

    /**
        The device object that created the texture.
    */
    @property MTLDevice device() const;

    /**
        A string that identifies the texture.
    */
    @property NSString label() const;

    /**
        Base constructor
    */
    this(id self) { super(self); }


    // Link MTLSharedTextureHandle.
    mixin ObjcLink;
}