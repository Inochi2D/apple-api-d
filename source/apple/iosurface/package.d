/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    Bindings to Apple's IOSurface API
*/
module apple.iosurface;
import apple.corefoundation;
import apple.mach;
import apple.os;
import apple;

/// Enum used as a version tag.
enum IOSurface;

mixin RequireAPIs!(IOSurface, CoreFoundation);

/// Link to CoreFoundation (on apple platforms)
mixin LinkFramework!("IOSurface");

/// Only available on apple OSes.
version(AppleOS):

/**
    
*/
extern(C) extern __gshared const CFStringRef kIOSurfaceAllocSize;

/**

*/
extern(C) extern __gshared const CFStringRef kIOSurfaceBytesPerElement;

/// Opaque handle to an IOSurface
struct IOSurface_T;

/// IOSurface handle
alias IOSurfaceRef = IOSurface_T*;

/**
    Returns the smallest aligned value greater than or equal to the specified value.
*/
int IOSurfaceAlignProperty(CFStringRef, int);

/**
    Gets whether the surface allows casting the size of pixels.
*/
bool IOSurfaceAllowsPixelSizeCasting(IOSurfaceRef);

/**
    Creates a new IOSurface object
*/
IOSurfaceRef IOSurfaceCreate(CFDictionaryRef);

/**
    Creates a mach port
*/
mach_port_t IOSurfaceCreateMachPort(IOSurfaceRef);