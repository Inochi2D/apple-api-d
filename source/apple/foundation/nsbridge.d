/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    Core Foundation Toll-free bridging
*/
module apple.foundation.nsbridge;
import apple.corefoundation;
import apple.foundation;
import apple.objc.rt.drt;
import apple.objc;
import apple.os;
import std.traits;

/**
    UDA to specify how a type is toll-free-bridged
*/
struct TollFreeBridged(T) { alias type = T; }

mixin RequireAPIs!(Foundation, CoreFoundation, ObjC);

extern(C) nothrow @nogc:

/**
    Transfers a pointer between Objective-C and Core Foundation 
    with no transfer of ownership.
*/
auto __bridge(From)(From from) {
    static if (is(From : DRTBindable) && hasUDA!(From, TollFreeBridged)) {

        alias bridgeTo = getUDAs!(From, TollFreeBridged)[0].type;
        return cast(bridgeTo)CFTypeRef(from.self());
    } else static if (is(From : CFTypeRef) && hasUDA!(From.isa, TollFreeBridged)) {

        alias bridgeTo = getUDAs!(From.isa, TollFreeBridged)[0].type;
        return drt_wrap!bridgeTo(cast(id)from);
    } else 
        static assert(0, From.stringof~" is not a toll-free bridged type!");
}

/**
    Transfers a pointer between Objective-C and Core Foundation 
    with a transfer of ownership between CF and Objective-C ARC.
*/
auto __bridge_arc(From)(From from) {
    static if (is(From : DRTBindable) && hasUDA!(From, TollFreeBridged)) {

        alias bridgeTo = getUDAs!(From, TollFreeBridged)[0].type;
        return cast(bridgeTo)CFTypeRef(CFBridgingRetain(from.self()));
    } else static if (is(From : CFTypeRef) && hasUDA!(From.isa, TollFreeBridged)) {
        
        alias bridgeTo = getUDAs!(From.isa, TollFreeBridged)[0].type;
        return drt_wrap!bridgeTo(cast(id)CFBridgingRelease(from));
    } else 
        static assert(0, From.stringof~" is not a toll-free bridged type!");
}

/**
    Casts an Objective-C pointer to a Core Foundation pointer 
    and also transfers ownership to the caller.
*/
extern CFTypeRef CFBridgingRetain(id x);

/**
    Moves a non-Objective-C pointer to Objective-C 
    and also transfers ownership to ARC.
*/
extern id CFBridgingRelease(CFTypeRef x);