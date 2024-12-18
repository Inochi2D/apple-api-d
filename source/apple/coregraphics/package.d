/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    Bindings to Apple's CoreGraphics API.
*/
module apple.coregraphics;
import apple.corefoundation;
import apple.coredata;
import apple.objc;
import apple.os;

/// Enum used as a version tag.
enum CoreGraphics;

mixin RequireAPIs!(CoreGraphics, CoreFoundation);

/// Link to CoreData (on apple platforms)
mixin LinkFramework!("CoreGraphics");

public import apple.coregraphics.cggeometry;