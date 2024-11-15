/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    Bindings to NSZone
*/
module apple.foundation.nszone;
import apple.foundation.nstypes;
import apple.os;

import apple.objc : ObjC;
mixin RequireAPIs!(ObjC);

extern(C) nothrow @nogc:

/**
    A type used to identify and manage memory zones.

    These are not used in modern development.
*/
struct NSZone;