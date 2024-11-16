/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    MTLDrawable
*/
module apple.metal.mtldrawable;
import apple.corefoundation;
import apple.coregraphics;
import apple.foundation;
import apple.metal;

import apple.os;
import apple.objc;
import apple.objc : selector;

mixin RequireAPIs!(Metal, Foundation, CoreFoundation, CoreGraphics);

alias MTLDrawablePresentedHandler = Block!(void, idref!MTLDrawable);

/**
    A displayable resource that can be rendered or written to. 

    Objects that implement this protocol are connected both to the Metal framework and an underlying 
    display system (such as Core Animation) that’s capable of showing content onscreen. 
    
    You use drawable objects when you want to render images using Metal and present them onscreen.

    Don’t implement this protocol yourself; instead, see CAMetalLayer, 
    for a class that can create and manage drawable objects for you.
*/
@ObjectiveC @ObjcProtocol
class MTLDrawable : NSObject {
nothrow @nogc:
public:

    /**
        A positive integer that identifies the drawable.
    */
    @property NSUInteger drawableID() const;

    /**
        The host time, in seconds, when the drawable was displayed onscreen.

        Typically, you query this property in a callback method. See addPresentedHandler.

        The property value is 0.0 if the drawable hasn’t been presented 
        or if its associated frame was dropped.
    */
    @property CFTimeInterval presentedTime() const;

    /**
        Base constructor
    */
    this(id self) { super(self); }

    /**
        Presents the drawable onscreen as soon as possible.
    */
    void present() @selector("present");

    /**
        Presents the drawable onscreen as soon as possible after a previous 
        drawable is visible for the specified duration.
    */
    void present(CFTimeInterval waitDuration) @selector("presentAfterMinimumDuration:");

    /**
        Presents the drawable onscreen at a specific host time.
    */
    void presentAt(CFTimeInterval time) @selector("presentAtTime:");

    /**
        Registers a block of code to be called immediately after the drawable is presented.

        You can register multiple handlers for a single drawable object.

        The following example code schedules a presentation handler 
        that reads the presentedTime property and uses it to derive the 
        interval between the last and current presentation times. From that information, 
        it determines the app’s frame rate.

        ```d
        // Class property
        CFTimeInterval previousPresentedTime;

        /+ ... +/
        // Render loop
        view.currentDrawable.addPresentedHandler(block((Id!MTLDrawable drawId) {
            
            // Ensure drawable is valid.
            if (auto drawable = drawId.get()) {
                auto presentationDuration = drawable.presentedTime - previousPresentedTime;
                auto framerate = 1.0/presentationDuration;

                /+ ... +/
                previousPresentedTime = drawable.presentedTime;
            }
        }));
        ```
    */
    void addPresentedHandler(MTLDrawablePresentedHandler block) @selector("addPresentedHandler:");

    // Link
    mixin ObjcLink;
}

version(CoreAnimation):

import apple.coreanimation;

/**
    A Metal drawable associated with a Core Animation layer.
*/
@ObjectiveC @ObjcProtocol
class CAMetalDrawable : MTLDrawable {
nothrow @nogc:
public:

    /**
        A Metal texture object that contains the drawable’s contents.
    */
    @property MTLTexture texture() const;

    /**
        A Metal texture object that contains the drawable’s contents.
    */
    @property CAMetalLayer layer() const;
    
    /**
        Base constructor
    */
    this(id self) { super(self); }

    // Link
    mixin ObjcLink;
}

/**
    A Core Animation layer that Metal can render into, typically displayed onscreen.
*/
@ObjectiveC
class CAMetalLayer : CALayer {
nothrow @nogc:
public:

    /**
        The Metal device responsible for the layer’s drawable resources.
    */
    @property MTLDevice device();
    @property void device(MTLDevice);

    /**
        The device object that the system recommends using for this layer.
    */
    @property MTLDevice preferredDevice() const;

    /**
        The pixel format of the layer’s textures.
    */
    @property MTLPixelFormat pixelFormat();
    @property void pixelFormat(MTLPixelFormat);

    /**
        A Boolean value that determines whether the layer’s 
        textures are used only for rendering.
    */
    @property bool framebufferOnly();
    @property void framebufferOnly(bool);

    /**
        The size, in pixels, of textures for rendering layer content.
    */
    @property CGSize drawableSize();
    @property void drawableSize(CGSize);

    /**
        A Boolean value that determines whether the layer synchronizes 
        its updates to the display’s refresh rate.
    */
    @property bool displaySyncEnabled();
    @property void displaySyncEnabled(bool);

    /**
        Enables extended dynamic range values onscreen.
    */
    @property bool wantsExtendedDynamicRangeContent();
    @property void wantsExtendedDynamicRangeContent(bool);

    /**
        The number of Metal drawables in the resource pool 
        managed by Core Animation.
    */
    @property NSUInteger maximumDrawableCount();
    @property void wantsExtendedDynamicRangeContent(NSUInteger);

    /**
        A Boolean value that determines whether requests for a new 
        buffer expire if the system can’t satisfy them.
    */
    @property bool allowsNextDrawableTimeout();
    @property void allowsNextDrawableTimeout(bool);
    
    /**
        Base constructor
    */
    this(id self) { super(self); }

    /**
        Waits until a Metal drawable is available, and then returns it.
    */
    CAMetalDrawable next() @selector("nextDrawable");

    // Link
    mixin ObjcLink;
}