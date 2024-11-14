/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    D Runtime Integration for Objective-C
*/
module apple.objc.rt.meta;
import apple.objc.rt.drt;
import apple.os;
import std.traits;
import std.meta;

//
//      UDAs
//

/**
    Opaque handle for ObjectiveC linkage type.
*/
struct ObjectiveC;

/**
    Struct for @selector UDA.
*/
struct selector { string sel; }

/**
    UDA for specifying a declared type member should not be bound
    to the Objective-C runtime.
*/
struct objc_ignore;

/**
    Lets the binding system know that the following item is a protocol.
*/
struct ObjcProtocol;

//
//      Argument Handling
//
template toObjCArgType(alias arg) {
    static if (is(typeof(arg) : DRTBindable))
        alias toObjCArgType = id;
    else
        alias toObjCArgType = arg;
}

template toObjCArgTypes(Args...) {
    alias toObjCArgTypes = staticMap!(toObjCArgType, AliasSeq!Args);
}

//
//      Binding Logic
//

/**
    Gets whether the specified member is an alias.
*/
template isAlias(T, string member) {
    enum isAlias = 
        __traits(identifier, __traits(getMember, T, member)) != member ||
        !(__traits(isSame, T, __traits(parent, __traits(getMember, T, member))));
}

/**
    Gets whether T is an Objective-C class.
*/
enum isObjectiveCClass(T) = is(T == class) && hasUDA!(T, ObjectiveC);

/**
    Gets whether T is an Objective-C protocol.
*/
enum isObjectiveCProtocol(T) = is(T == interface) && hasUDA!(T, ObjectiveC);