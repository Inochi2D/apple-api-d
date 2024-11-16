/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    Bindings to Apple's Core Animation API.
*/
module apple.coreanimation;
import apple.corefoundation;
import apple.foundation;
import apple.objc;
import apple.os;

/// Enum used as a version tag.
enum CoreAnimation;

mixin RequireAPIs!(CoreAnimation, CoreFoundation, Foundation);

/// Link to CoreAnimation (on apple platforms)
mixin LinkFramework!("CoreAnimation");
mixin LinkFramework!("QuartzCore");

public import apple.coreanimation.calayer;