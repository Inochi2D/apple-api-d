/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    Bindings to Apple's CoreGraphics API.
*/
module apple.coredata;
import apple.foundation;
import apple.coredata;

/// Enum used as a version tag.
enum CoreGraphics;

mixin RequireAPIs!(CoreGraphics, CoreData, Foundation);

/// Link to CoreData (on apple platforms)
mixin LinkFramework!("CoreGraphics");