/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    Bindings to NSObject and NSObjectProtocol
*/
module apple.foundation.nscoder;
import apple.foundation;
import apple.os;

import apple.objc : ObjC;
mixin RequireAPIs!(ObjC);

import apple.objc;
import apple.objc : selector;

/**
    An abstract class that serves as the basis for objects that enable 
    archiving and distribution of other objects.
*/
@ObjectiveC @ObjcProtocol
class NSCoder : NSObject {
@nogc nothrow:
public:

    /**
        Base constructor
    */
    this(id self) { super(self); }

    mixin ObjcLink;
}