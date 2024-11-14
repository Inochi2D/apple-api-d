/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    Bindings to Apple's Metal API.
*/
module apple.metal;
import apple.foundation;
import apple.coredata;
import apple.coregraphics;
import apple.corefoundation;
import apple.uikit;
import apple.objc;
import apple.os;

/// Enum used as a version tag.
enum Metal;

mixin RequireAPIs!(Metal, Foundation, CoreFoundation, CoreData, CoreGraphics, ObjC);

/// Link to Metal (on apple platforms)
mixin LinkFramework!("Metal");

public import apple.metal.mtltypes;
public import apple.metal.mtldevice;
public import apple.metal.mtltexture;
public import apple.metal.mtlbuffer;
public import apple.metal.mtlresource;