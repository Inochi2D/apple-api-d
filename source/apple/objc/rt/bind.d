/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    Helpers to handle binding D type delcarations to Objective-C's Runtime.
*/
module apple.objc.rt.bind;
import apple.os;

import apple.objc : ObjC;
mixin RequireAPIs!(ObjC);

import apple.objc.rt.base;
import apple.objc.rt.abi;
import apple.objc.rt.meta;
import std.traits;
import std.meta;
import std.array : join;
import std.format : format;

alias selector = apple.objc.rt.meta.selector;

/**
    Template mixin which registers the D type within the Objective-C runtime.

    Needs to be mixed-in from within the class or protocol you wish to bind.
*/
mixin template ObjcLink(string name=null) {
    import std.traits;
    import apple.objc.rt.base;
    import apple.objc.rt.bind;
    import apple.objc.rt.abi;
    import apple.objc.rt.drt;

    alias Self = typeof(this);
    enum SelfLinkName = name is null ? Self.stringof : name;

    static if (is(Self == class)) {
        static assert(is(Self : DRTBindable), "Objective-C type did not implement DRTBindable!");

        static if (hasUDA!(Self, ObjcProtocol)) {

            // Create C const object.
            pragma(mangle, objc_classVarName!(SelfLinkName))
            mixin(q{extern(C) extern __gshared objc_protocol }, "Objc_Proto_", SelfLinkName, ";");

            mixin(q{static Protocol SELF_TYPE = &}, "Objc_Proto_", SelfLinkName, ";");

        } else {

            // Create C const object.
            pragma(mangle, objc_classVarName!(SelfLinkName))
            mixin(q{extern(C) extern __gshared objc_class }, "Objc_Class_", SelfLinkName, ";");

            mixin(q{static Class SELF_TYPE = &}, "Objc_Class_", SelfLinkName, ";");
        }

        mixin ObjcLinkObject!Self;

        // Interfaces
        static foreach(iface; InterfacesTuple!Self)
            mixin ObjcLinkObject!iface;
        
    } else static assert(0, "Type can not be bound!");
}

template SuperClass(T) {
    static if (is(T == class))
        alias SuperClass = BaseTypeTuple!T[0];
    else 
        alias SuperClass = T;
}

mixin template ObjcLinkObject(DClassObject) {
    static foreach(classMember; __traits(derivedMembers, DClassObject)) {
        static if (!isAlias!(DClassObject, classMember)) {
            static foreach(mRef; __traits(getOverloads, DClassObject, classMember)) {
                static if (ObjcMethodCanGenerate!mRef) {
                    mixin ObjcLinkMember!(DClassObject, mRef);
                }
            }
        }
    }
}

/**
    Creates a string parameter list
*/
string ObjcParamList(alias funcPtr)() {
    alias fParameters = Parameters!funcPtr;
    alias fParameterNames = ParameterIdentifierTuple!funcPtr;
    import std.array : join;
    import std.format : format;

    string[] paramPairs;
    static foreach(param; 0..fParameters.length) {
        paramPairs ~= "%s %s".format(fParameters[param].stringof, fParameterNames[param]);
    }

    return "(%s)".format(paramPairs.join(", "));
}

/// Gets selector base name for method
template ObjcSelectorBaseName(alias DObjectMember) {
    static if (hasUDA!(DObjectMember, selector))
        enum ObjcSelectorBaseName = getUDAs!(DObjectMember, selector)[0].sel;
    else 
        enum ObjcSelectorBaseName = __traits(identifier, DObjectMember);
}

/// Gets selector name for method
template ObjcSelectorName(alias DObjectMember) {
    static if (hasFunctionAttributes!(DObjectMember, "@property") && (Parameters!DObjectMember).length == 1)
        enum ObjcSelectorName = toObjcSetterSEL!(ObjcSelectorBaseName!DObjectMember);
    else
        enum ObjcSelectorName = ObjcSelectorBaseName!DObjectMember;
}

/// Gets whether a method can be generated.
enum ObjcMethodCanGenerate(alias DObjectMember) =
    !hasUDA!(DObjectMember, objc_ignore) && 
    __traits(identifier, DObjectMember) != "__ctor" &&
    __traits(identifier, DObjectMember) != "__dtor" && (
        hasUDA!(DObjectMember, selector) ||
        __traits(isStaticFunction, DObjectMember) ||
        hasFunctionAttributes!(DObjectMember, "@property")
    );

enum ObjcMethodQualifiers(alias DObjectMember) = 
    "%s ".format([__traits(getFunctionAttributes, DObjectMember)].join(" "));

enum ObjcMethodShouldOverride(DObject, alias DObjectMember) =
    __traits(isVirtualMethod, DObjectMember) && 
    hasMember!(SuperClass!DObject, __traits(identifier, DObjectMember));

enum ObjcReturnType(alias DObjectMember) = 
    (ReturnType!DObjectMember).stringof~" ";

/// Link a single member
template ObjcLinkMember(DObject, alias DObjectMember) {

    // Basic information about the member.
    enum fName = __traits(identifier, DObjectMember);
    enum fParamList = ObjcParamList!(DObjectMember);
    enum fSelector = ObjcSelectorName!DObjectMember;
    enum fQualifiers = ObjcMethodQualifiers!DObjectMember;
    alias fReturnType = ReturnType!DObjectMember;
    enum fReturnTypeName = ObjcReturnType!DObjectMember;

    static if (ObjcMethodShouldOverride!(DObject, DObjectMember)) {

        // For when we can override
        override
        mixin(fQualifiers, fReturnTypeName, fName, fParamList, q{{
            const(char)* sel = fSelector;

            return this.message!fReturnType(sel, __traits(parameters));
        }});
    } else static if (__traits(isStaticFunction, DObjectMember)) {
        
        // Static functions
        pragma(mangle, DObjectMember.mangleof)
        mixin(fQualifiers, fReturnTypeName, fName, fParamList, q{{
            const(char)* sel = fSelector;

            return DObject.message!fReturnType(cast(id)DObject.SELF_TYPE, sel, __traits(parameters));
        }});
    } else {

        // And finally, the option where we just forcefully put in 
        // a mangled replacement.
        pragma(mangle, DObjectMember.mangleof)
        mixin(fQualifiers, fReturnTypeName, fName, fParamList, q{{
            const(char)* sel = fSelector;

            return this.message!fReturnType(sel, __traits(parameters));
        }});
    }
}

/**
    Returns a setter selector from a name
*/
template toObjcSetterSEL(string name) {
    import std.ascii;
    import std.string : toStringz;
    enum const(char)* toObjcSetterSEL = ("set"~name[0].toUpper()~name[1..$]~":\0").ptr;
}