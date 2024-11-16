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
import apple.objc.rt.drt;
import std.traits;
import std.meta;
import std.array : join;
import std.format : format;

alias selector = apple.objc.rt.meta.selector;

/**
    Template mixin which registers the D type within the Objective-C runtime.

    Needs to be mixed-in from within the class or protocol you wish to bind.
*/
template ObjcLink(string name=null) {
    import std.traits;
    import apple.objc.rt.base;
    import apple.objc.rt.bind;
    import apple.objc.rt.abi;
    import apple.objc.rt.drt;
    import std.file;

    alias Self = typeof(this);
    enum SelfLinkName = name is null ? Self.stringof : name;

    static if (is(Self == class)) {
        static assert(is(Self : DRTBindable), "Objective-C type did not implement DRTBindable!");

        static if (hasUDA!(Self, ObjcProtocol)) {

            @objc_ignore
            static any SELF_TYPE() => cast(id)Protocol.get(SelfLinkName);

            override
            @objc_ignore
            @property any objc_type() inout => cast(id)Protocol.get(SelfLinkName);

        } else {

            @objc_ignore
            static any SELF_TYPE() => cast(id)Class.lookup(SelfLinkName);

            override
            @objc_ignore
            @property any objc_type() inout => cast(id)Class.lookup(SelfLinkName);
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

template ObjcLinkObject(DClassObject) {
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
        hasFunctionAttributes!(DObjectMember, "@property")
    );

enum ObjcMethodQualifiers(alias DObjectMember) = 
    "%s ".format([__traits(getFunctionAttributes, DObjectMember)].join(" "));

enum ObjcMethodShouldOverride(DObject, alias DObjectMember) =
    __traits(isVirtualMethod, DObjectMember) && 
    hasMember!(SuperClass!DObject, __traits(identifier, DObjectMember)) &&
    __traits(isSame, DObjectMember, __traits(getMember, SuperClass!DObject, __traits(identifier, DObjectMember)));

enum ObjcReturnType(alias DObjectMember) = 
    (ReturnType!DObjectMember).stringof~" ";


/**
    Forwards DRTBindable types properly to arugments.
*/
template objc_forward(Args...) {
    template fwd(alias arg) {
        static if(is(typeof(arg) : DRTBindable))
            @property auto fwd() => arg.self;
        else
            alias fwd = arg;
    }

    alias objc_forward = staticMap!(fwd, Args);
}

/// Link a single member
template ObjcLinkMember(DObject, alias DObjectMember) {
    import std.string : format;

    // Basic information about the member.
    enum fName = __traits(identifier, DObjectMember);
    enum fSelector = ObjcSelectorName!DObjectMember;
    alias fParams = Parameters!DObjectMember;
    alias fReturnType = ReturnType!DObjectMember;

    static if (ObjcMethodShouldOverride!(DObject, DObjectMember)) {

        // OVERRIDE
        override
        @(__traits(getAttributes, DObjectMember))
        mixin(q{
            fReturnType %s(fParams) {
                return this.message!fReturnType("%s", objc_forward!(__traits(parameters)));
            }
        }.format(fName, fSelector));
    } else static if (__traits(isStaticFunction, DObjectMember)) {
        
        // STATIC
        @(__traits(getAttributes, DObjectMember))
        pragma(mangle, DObjectMember.mangleof)
        mixin(q{
            fReturnType %s(fParams) {
                return DObject.message!fReturnType(cast(id)DObject.SELF_TYPE, "%s", objc_forward!(__traits(parameters)));
            }
        }.format(fName, fSelector));
    } else {
        
        // OTHER
        @(__traits(getAttributes, DObjectMember))
        pragma(mangle, DObjectMember.mangleof)
        mixin(q{
            fReturnType %s(fParams) {
                return this.message!fReturnType("%s", objc_forward!(__traits(parameters)));
            }
        }.format(fName, fSelector));
    }
}

/**
    Returns a setter selector from a name
*/
template toObjcSetterSEL(string name) {
    import std.ascii;
    import std.string : toStringz;
    enum toObjcSetterSEL = ("set"~name[0].toUpper()~name[1..$]~":");
}