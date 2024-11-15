/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    Bindings to NSDictionary
*/
module apple.foundation.nsdictionary;
import apple.corefoundation;
import apple.foundation;
import apple.objc;
import apple.objc : selector;
import apple.os;

mixin RequireAPIs!(Foundation, CoreFoundation, ObjC);

/**
    NSDictionary
*/
@ObjectiveC @TollFreeBridged!CFDictionaryRef
class NSDictionary : NSObject {
@nogc nothrow:
public:

    /**
        Base constructor
    */
    this(id self) { super(self); }

    // Link NSDictionary.
    mixin ObjcLink;
}

/**
    NSDictionary
*/
@ObjectiveC @TollFreeBridged!CFMutableDictionaryRef
class NSMutableDictionary : NSDictionary {
@nogc nothrow:
public:

    /**
        Base constructor
    */
    this(id self) { super(self); }

    // Link NSDictionary.
    mixin ObjcLink;
}