/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    Bindings to Apple's Foundation API.
*/
module apple.foundation.nsvalue;
import apple.corefoundation;
import apple.foundation;
import apple.objc;
import apple.objc : selector;
import apple.os;

mixin RequireAPIs!(Foundation, CoreFoundation, ObjC);

/**
    NSValue
*/
@ObjectiveC
class NSValue : NSObject {
@nogc nothrow:
public:

    /**
        Returns the value as an untyped pointer.
    */
    @property void* pointerValue();
    alias ptr = pointerValue;

    /**
        Default constructor without any init.
    */
    this() { super(this.alloc()); }

    /**
        Creates a value object containing the specified pointer.
    */
    this(T)(T* ptr) {
        super(this.message!id(this.getClass(), "valueWithPointer:", cast(void*)ptr));
    }

    // Link NSValue.
    mixin ObjcLink;
}