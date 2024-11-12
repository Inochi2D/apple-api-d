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

/// Enum used as a version tag.
enum Foundation;

mixin RequireAPIs!(Foundation, CoreFoundation);

/// Link to Foundation (on apple platforms)
mixin LinkFramework!("Foundation");

public import apple.objc.nsobject;
public import apple.foundation.nsstring;