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

import apple.objc : ObjC, NSObject;
mixin RequireAPIs!(ObjC);

import apple.objc.rt.base;
import apple.objc.rt.abi;
import std.traits;
import std.meta;
import std.array : join;
import std.format : format;

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
    Higher level "id return" wrapper.
*/
struct idref(T) if (is(T : NSObject)) {
    alias RType = T;
    alias ref_ this;

    /**
        The actual reference to the ID, 
        you can pass this to object constructor
        to get a new object.
    */
    id ref_;
}

/**
    Gets whether the specified member is an alias.
*/
template isAlias(T, string member) {
    enum isAlias = 
        __traits(identifier, __traits(getMember, T, member)) != member ||
        !(__traits(isSame, T, __traits(parent, __traits(getMember, T, member))));
}

//
//      Argument Handling
//
template toObjCArgType(alias arg) {
    import apple.objc.nsobject;

    static if (is(typeof(arg) : NSObject))
        alias toObjCArgType = id;
    else
        alias toObjCArgType = arg;
}

template toObjCArgTypes(Args...) {
    alias toObjCArgTypes = staticMap!(toObjCArgType, AliasSeq!Args);
}

//
//      Messages
//

/**
    Sends a message to an id instance
*/
T sendMessage(T = void, Args...)(id instance, SEL selector, Args args) {
    alias fn = T function(id, SEL, toObjCArgTypes!(Args)) @nogc nothrow;

    static if (OBJC_ABI == 1) {
        static if(is(T == struct)) {
            T toReturn = T.init;
            objc_msgSend_stret(&sReturn, instance, selector, args);
            return toReturn;
        } else static if (isFloating!T) {
            return (cast(fn)&objc_msgSend_fpret)(instance, selector, args);
        } else {
            return (cast(fn)&objc_msgSend)(instance, selector, args);
        }
    } else static if (OBJC_ABI == 2) {
        return (cast(fn)&objc_msgSend)(instance, selector, args);
    } else static assert(0, "ABI is not supported!");
}

/**
    Sends a message to an object's super class
*/
T sendMessageSuper(T = void)(Class superclass, id instance, SEL selector, ...) {
    alias fn = T function(id, SEL, toObjCArgTypes!Args) @nogc nothrow;

    objc_super spInstance = objc_super(
        reciever: instance,
        superClass: superclass
    );

    debug assert(instance.inherits(superclass), "Tried to send message to super-class that wasn't actually a super class.");

    static if (OBJC_ABI == 1) {
        static if(is(T == struct)) {
            return (cast(fn)&objc_msgSendSuper_stret)(instance, selector, args);
        } else {
            return (cast(fn)&objc_msgSendSuper)(instance, selector, args);
        }
    } else static if (OBJC_ABI == 2) {
        return (cast(fn)&objc_msgSendSuper)(instance, selector, args);
    } else static assert(0, "ABI is not supported!");
}

//
//      Binding Logic
//

/**
    Gets whether class type of `instance` inherits from the `toCheck` class.
*/
bool inherits(id instance, Class toCheck) {
    return inherits(object_getClass(instance), toCheck);
} 

/**
    Gets whether `self` inherits from the `toCheck` class.
*/
bool inherits(Class self, Class toCheck) {
    auto p = self;

    do {
        
        // Check if the class refers to toCheck.
        // If it does then we've found a match!
        if (p is toCheck) return true;
        
        // Otherwise iterate until we go past NSObject.
        p = class_getSuperclass(p);
    } while(p !is null);
    return false;
}

/**
    Returns a setter selector from a name
*/
template toObjcSetterSEL(string name) {
    import std.ascii;
    import std.string : toStringz;
    enum const(char)* toObjcSetterSEL = ("set"~name[0].toUpper()~name[1..$]~":\0").ptr;
}

/**
    Gets whether T is an Objective-C class.
*/
enum isObjectiveCClass(T) = is(T == class) && hasUDA!(T, ObjectiveC);

/**
    Gets whether T is an Objective-C protocol.
*/
enum isObjectiveCProtocol(T) = is(T == interface) && hasUDA!(T, ObjectiveC);

/**
    Template mixin which registers the D type within the Objective-C runtime.

    Needs to be mixed-in from within the class or protocol you wish to bind.
*/
mixin template ObjcLink(string name=null) {
    import std.traits;
    import apple.objc.rt.base;
    import apple.objc.rt.bind;
    import apple.objc.rt.abi;
    import apple.objc.nsobject;

    alias Self = typeof(this);
    enum SelfLinkName = name is null ? Self.stringof : name;

    static if (isObjectiveCClass!Self) {
        
        /// Catch users trying to create non-NSObject derived 
        static assert(is(Self == NSObject) || is(Self : NSObject), "Objective-C type did not derive from NSObject!");

        // Create C const object.
        pragma(mangle, objc_classVarName!(SelfLinkName))
        mixin(q{extern(C) extern __gshared objc_class }, "Objc_Class_", SelfLinkName, ";");

        mixin(q{static Class SELF_TYPE = &}, "Objc_Class_", SelfLinkName, ";");

        /**
            Implementation of the getClass interface.
        */
        override Class getClass() => SELF_TYPE;

        mixin ObjcLinkObject!Self;

        // Interfaces
        static foreach(iface; InterfacesTuple!Self)
            mixin ObjcLinkObject!iface;
        
    } else static if (isObjectiveCProtocol!Self) {

        // Create C const object.
        pragma(mangle, objc_protoVarName!(SelfLinkName))
        mixin(q{extern(C) extern __gshared objc_protocol }, "Objc_Proto_", SelfLinkName, ";");

        mixin(q{static Protocol PROTOCOL = &}, "Objc_Proto_", SelfLinkName, ";");
    
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

            static if (is(fReturnType : NSObject))
                return wrap(this.message!(idref!fReturnType)(sel, __traits(parameters)));
            else
                return this.message!fReturnType(sel, __traits(parameters));
        }});
    } else static if (__traits(isStaticFunction, DObjectMember)) {
        
        // Static functions
        pragma(mangle, DObjectMember.mangleof)
        mixin(fQualifiers, fReturnTypeName, fName, fParamList, q{{
            const(char)* sel = fSelector;

            static if (is(fReturnType : NSObject))
                return wrap!fReturnType(DObject.message!(idref!fReturnType)(DObject.SELF_TYPE, sel, __traits(parameters)));
            else
                return DObject.message!fReturnType(DObject.SELF_TYPE, sel, __traits(parameters));
        }});
    } else {

        // And finally, the option where we just forcefully put in 
        // a mangled replacement.
        pragma(mangle, DObjectMember.mangleof)
        mixin(fQualifiers, fReturnTypeName, fName, fParamList, q{{
            const(char)* sel = fSelector;

            static if (is(fReturnType : NSObject))
                return wrap(this.message!(idref!fReturnType)(sel, __traits(parameters)));
            else
                return this.message!fReturnType(sel, __traits(parameters));
        }});
    }
}