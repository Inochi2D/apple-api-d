/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    CFArray
*/
module apple.corefoundation.cfnull;
import apple.corefoundation;
import apple.foundation;
import apple;
import apple.os;

mixin RequireAPIs!(CoreFoundation);
extern(C) @nogc nothrow:

/**
    CoreFoundation "null" type.
*/
struct CFNullRef {
    CFTypeRef isa;
    
    alias isa this;
}

/**
    A CFNullRef singleton instance.
*/
extern const __gshared CFNullRef kCFNull;