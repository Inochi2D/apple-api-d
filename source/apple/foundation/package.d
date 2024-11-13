/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    Bindings to Apple's Foundation API.
*/
module apple.foundation;
import apple.corefoundation;
import apple.objc;
import apple.os;

/// Enum used as a version tag.
enum Foundation;

mixin RequireAPIs!(Foundation, ObjC, CoreFoundation);

/// Link to Foundation (on apple platforms)
mixin LinkFramework!("Foundation");

public import apple.objc.nsobject;
public import apple.foundation.nsstring;
public import apple.foundation.nsarray;
public import apple.foundation.nsdictionary;