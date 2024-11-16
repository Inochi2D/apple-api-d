/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    Bindings to Objective-C
*/
module apple.objc;
import apple.os;

/// ObjectiveC support
enum ObjC;

mixin RequireAPIs!(ObjC);

/// Link to Objective-C runtime
pragma(lib, "objc");

public import apple.objc.block;
public import apple.objc.rt.bind : ObjcLink;
public import apple.objc.rt.meta;
public import apple.objc.rt.base;
public import apple.objc.rt.autorelease;
public import apple.objc.rt.drt;

alias selector = apple.objc.rt.selector;