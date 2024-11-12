/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    Helpers to handle binding D type delcarations to Objective-C's Runtime.
*/
module apple.objc.rt.bind;
import apple.objc.rt.base;
import apple.objc.rt.abi;

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
    Converts the specified function signature to a Objective-C function signature.
*/
template toObjectiveCSig(alias fn, ClassT) {
    alias toObjectiveCSig = extern(C) ReturnType!fn function(ClassT, SEL, Parameters!fn);
}

/**
    Gets whether the specified member is an alias.
*/
template isAlias(T, string member) {
    alias isAlias = 
        __traits(identifier, __traits(getMember, T, member)) != member ||
        !(__traits(isSame, T, __traits(parent, __traits(getMember, T, member))));
}

/**
    Gets whether the specified member is an alias.
*/
template isAliasModule(T, string member) {
    alias isAliasModule = 
        __traits(identifier, __traits(getMember, T, member)) != member;
}

/**
    Sends a message to an id instance
*/
T sendMessage(T = void)(id instance, SEL selector, ...) {
    version(ISA_X86) {
        static if(is(T == struct)) {
            T toReturn = T.init;
            objc_msgSend_stret(&sReturn, instance, selector, ...);
            return toReturn;
        } else static if (isFloating!T) {
            return cast(toObjectiveCSig!(objc_msgSend_fpret, T)&objc_msgSend_fpret)(instance, selector, ...);
        } else {
            return cast(toObjectiveCSig!(objc_msgSend, T)&objc_msgSend)(instance, selector, ...);
        }
    } else {
        return cast(toObjectiveCSig!(objc_msgSend, T)&objc_msgSend)(instance, selector, ...);
    }
}

/**
    Sends a message to an object's super class
*/
T sendMessageSuper(T = void)(Class superclass, id instance, SEL selector, ...) {
    objc_super spInstance = objc_super(
        reciever: instance,
        superClass: superclass
    );

    debug assert(instance.inherits(superclass), "Tried to send message to super-class that wasn't actually a super class.");

    version(ISA_X86) {
        static if(is(T == struct)) {
            return cast(toObjectiveCSig!(objc_msgSendSuper_stret, T)&objc_msgSendSuper_stret)(spInstance, selector, ...);
        } else {
            return cast(toObjectiveCSig!(objc_msgSendSuper, T)&objc_msgSendSuper)(spInstance, selector, ...);
        }
    } else {
        return cast(toObjectiveCSig!(objc_msgSendSuper, T)&objc_msgSendSuper)(spInstance, selector, ...);
    }
}

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
string toObjcSetterSEL(string name) {
    return "set"~name[0].toUpper()~name[1..$]~":";
}

/**
    Gets whether T is an Objective-C class.
*/
enum isObjectiveCClass(T) = is(T == class) && hasUDA!(T, ObjectiveC);

/**
    Gets whether T is an Objective-C protocol.
*/
enum isObjectiveCProtocol(T) = is(T == interface) && hasUDA(T, ObjectiveC);

/**
    Template mixin which registers the D type within the Objective-C runtime.

    Needs to be mixed-in from within the class or protocol you wish to bind.
*/
mixin template ObjcLink {

    import std.traits;
    import apple.objc.base;
    import apple.objc.bind;

    alias Self = typeof(this);

    static if (isObjectiveCClass!Self) {
        
        /// Catch users trying to create non-NSObject derived 
        static assert(is(DObject == NSObject) || is(DObject : NSObject), "Objective-C type did not derive from NSObject!");

        // Create C const object.
        pragma(mangle, objc_classVarName!(Self.stringof))
        extern(C) extern const __gshared objc_class mixin("Objc_Class_", Self.stringof);

        // Create reference to said object
        static const Class selfRef = &mixin("Objc_Class_", Self.stringof);

        /// Reference to "self"

        mixin ObjcLinkClass!Self;
    } else static if (isObjectiveCProtocol!Self) {

        /// Declare protocol type
        extern(C) extern const pragma(mangle, objc_protoVarName!(Self.stringof)) __gshared Protocol selfRef;

        // Create C const object.
        pragma(mangle, objc_protoVarName!(Self.stringof))
        extern(C) extern const __gshared objc_protocol mixin("Objc_Proto_", Self.stringof);

        // Create reference to said object
        static const Protocol selfRef = &mixin("Objc_Proto_", Self.stringof);

        mixin ObjcLinkProtocol!Self;
    } else static assert(0, "Type can not be bound!");
}

// Following mixin templates are just internal.
private:

mixin template ObjcLinkClass(DClassObject) {
    static foreach(classMember; __traits(allMembers, DClassObject)) {
        static if (!isAlias!(DClassObject, classMember)) {
            static foreach(mRef; __traits(getOverloads, Class, classMember)) {
                static if (!hasUDA!(mRef, nobind) && (hasUDA!(mRef, selector) || hasFunctionAttributes!(mRef, "@property"))) {
                    mixin ObjcLinkMember!(mRef, DClassObject);
                }
            }
        }
    }
}

mixin template ObjcLinkMember(DObjectMember, ParentObject, bool isSuperCall=false) {
    static if (hasUDA!(DObjectMember, selector)) {
        static if (__traits(isStaticFunction, DObjectMember)) {
            ReturnType!DObjectMember DObjectMember(Parameters!DObjectMember) {
                const(char)* _fSelector = getUDAs!(DObjectMember, selector)[0].sel;

                static if (isSuperCall) 
                    return sendMessageSuper!(ReturnType!DObjectMember)(selfRef, sel_registerName(_fSelector), __traits(parameters));
                else 
                    return sendMessage!(ReturnType!DObjectMember)(selfRef, sel_registerName(_fSelector), __traits(parameters));
            }
        } else {
            ReturnType!DObjectMember DObjectMember(Parameters!DObjectMember) {
                const(char)* _fSelector = getUDAs!(DObjectMember, selector)[0].sel;

                static if (isSuperCall) 
                    return sendMessageSuper!(ReturnType!DObjectMember)(selfRef, sel_registerName(_fSelector), __traits(parameters));
                else 
                    return sendMessage!(ReturnType!DObjectMember)(selfRef, sel_registerName(_fSelector), __traits(parameters));
            }
        }
    } else static if (hasFunctionAttributes!(DObjectMember, "@property")) {
        @property ReturnType!DObjectMember DObjectMember(Parameters!DObjectMember) {
            static if (Parameters!DObjectMember.length > 0)
                const(char)* _fSelector = static toObjcSetterSEL(__traits(identifier, DObjectMember));
            else 
                const(char)* _fSelector = __traits(identifier, DObjectMember);

            static if (isSuperCall) 
                return sendMessageSuper!(ReturnType!DObjectMember)(selfRef, sel_registerName()), __traits(parameters));
            else 
                return sendMessage!(ReturnType!DObjectMember)(selfRef, sel_registerName(_fSelector), __traits(parameters));
        }
    }
}
