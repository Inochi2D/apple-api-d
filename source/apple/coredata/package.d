/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    Bindings to Apple's CoreData API.
*/
module apple.coredata;
import apple.foundation;
import apple.objc;
import apple.os;

/// Enum used as a version tag.
enum CoreData;

mixin RequireAPIs!(CoreData, ObjC, Foundation);

/// Link to CoreData (on apple platforms)
mixin LinkFramework!("CoreData");