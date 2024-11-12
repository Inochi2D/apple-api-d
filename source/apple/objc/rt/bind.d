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
struct nobind;

/**
    UDA for instance types.
*/
struct instancetype;

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
template toObjCArg(alias arg) {
    import apple.objc.nsobject;

    static if (is(typeof(arg) : NSObject))
        alias toObjCArg = arg.self();
    else
        alias toObjCArg = arg;
}

template toObjCArgs(Args...) {
    alias toObjCArgs = staticMap!(toObjCArg, AliasSeq!Args);
}

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
            objc_msgSend_stret(&sReturn, instance, selector, toObjCArgs!args);
            return toReturn;
        } else static if (isFloating!T) {
            return (cast(fn)&objc_msgSend_fpret)(instance, selector, toObjCArgs!args);
        } else {
            return (cast(fn)&objc_msgSend)(instance, selector, toObjCArgs!args);
        }
    } else static if (OBJC_ABI == 2) {
        return (cast(fn)&objc_msgSend)(instance, selector, toObjCArgs!args);
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
    enum toObjcSetterSEL = "set"~name[0].toUpper()~name[1..$]~":";
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
        static if(classMember != "__dtor" && classMember != "__ctor") {
            static if (!isAlias!(DClassObject, classMember)) {
                static foreach(mRef; __traits(getOverloads, DClassObject, classMember)) {
                    static if (is(DClassObject == class)) {
                        static if (!hasMember!(SuperClass!DClassObject, classMember) && (hasUDA!(mRef, selector) || hasFunctionAttributes!(mRef, "@property"))) {
                            mixin ObjcLinkMember!(mRef, DClassObject);
                        }
                    } else static if (is(DClassObject == interface)) {
                        static if ((hasUDA!(mRef, selector) || hasFunctionAttributes!(mRef, "@property"))) {
                            mixin ObjcLinkMember!(mRef, DClassObject);
                        }
                    }
                }
            }
        }
    }
}

/**
    Creates a string parameter list
*/
string paramList(alias funcPtr)() {
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

template ObjcLinkMember(alias DObjectMember, ParentObject, bool isSuperCall=false) {

    // Basic information about the member.
    enum fName = __traits(identifier, DObjectMember);
    enum fParamList = paramList!(DObjectMember);

    // Figure out the return type
    static if (hasUDA!(DObjectMember, instancetype))
        enum fReturnType = ParentObject.stringof~" ";
    else
        enum fReturnType = (ReturnType!DObjectMember).stringof~" ";

    // Figure out which selector to use.
    static if (hasUDA!(DObjectMember, selector))
        enum fSelector = getUDAs!(DObjectMember, selector)[0].sel;
    else 
        enum fSelector = __traits(identifier, DObjectMember);

    static if (__traits(isVirtualMethod, DObjectMember) && hasMember!(SuperClass!ParentObject, fName)) {
        enum fQualifiers = "@nogc nothrow ";

        override
        mixin(fQualifiers, fReturnType, fName, fParamList, q{{
            static if (isSuperCall) 
                return sendMessageSuper!(ReturnType!DObjectMember)(this.self, sel_registerName(fSelector), __traits(parameters));
            else 
                return sendMessage!(ReturnType!DObjectMember)(this.self, sel_registerName(fSelector), __traits(parameters));
        }});
    } else static if (hasFunctionAttributes!(DObjectMember, "@property")) {
        enum fQualifiers = "@nogc nothrow @property ";

        pragma(mangle, DObjectMember.mangleof)
        mixin(fQualifiers, fReturnType, fName, fParamList, q{{
            static if (Parameters!DObjectMember.length > 0)
                const(char)* _fSelector = !toObjcSetterSEL(fSelector);
            else 
                const(char)* _fSelector = fSelector;

            static if (isSuperCall) 
                return sendMessageSuper!(ReturnType!DObjectMember)(this.self, sel_registerName(_fSelector), __traits(parameters));
            else 
                return sendMessage!(ReturnType!DObjectMember)(this.self, sel_registerName(_fSelector), __traits(parameters));
        }});

    } else static if (hasUDA!(DObjectMember, selector)) {
        static if (__traits(isStaticFunction, DObjectMember)) {
            enum fQualifiers = "@nogc nothrow static ";

            pragma(mangle, DObjectMember.mangleof)
            mixin(fQualifiers, fReturnType, fName, fParamList, q{{
                static if (isSuperCall) 
                    return sendMessageSuper!(ReturnType!DObjectMember)(cast(id)SELF_TYPE, sel_registerName(fSelector), __traits(parameters));
                else 
                    return sendMessage!(ReturnType!DObjectMember)(cast(id)SELF_TYPE, sel_registerName(fSelector), __traits(parameters));
            }});
        } else {
            enum fQualifiers = "@nogc nothrow ";

            pragma(mangle, DObjectMember.mangleof)
            mixin(fQualifiers, fReturnType, fName, fParamList, q{{
                static if (isSuperCall) 
                    return sendMessageSuper!(ReturnType!DObjectMember)(this.self, sel_registerName(fSelector), __traits(parameters));
                else 
                    return sendMessage!(ReturnType!DObjectMember)(this.self, sel_registerName(fSelector), __traits(parameters));
            }});
        }
    }
}
