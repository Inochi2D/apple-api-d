/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    D Runtime Integration for Objective-C
*/
module apple.objc.rt.drt.wrap;
import apple.objc.rt.base;
import apple.objc.rt.abi;
import apple.objc.rt.meta;
import apple.objc.block;
import apple.objc;
import numem.core.memory;
import apple.os;
import core.stdc.math;
import numem.core.memory;
import numem.events;

import core.stdc.stdio : printf;
import apple.foundation.nstypes;

mixin RequireAPIs!(ObjC);

@nogc nothrow:


//
//      Wrapping
//

/**
    Wraps the `from` ID to a D class that is bindable.

    If `from` is not an instance or subclass of `T` returns null.
    If `from` has no wrapping, creates one and returns it.
    If wrapping fails, returns null.

    Wrapped classes are subject to the reference counting of 
    Objective-C and their destructor will be called
    when the Objective-C reference count reaches 0.
*/
T drt_wrap(T)(id from) if (is(T : DRTBindable)) {
    if (!DRTObject.isReady())
        DRTObject.initialize();

    // Can't wrap null.
    if (!from)
        return null;

    DRTObject obj = _drt_get(from);
    if (obj)
        return cast(T)obj.self();

    obj = _drt_set(from, DRTObject.create(from.class_));
    if (obj) {
        obj.self = nogc_new!T(from);
        return cast(T)obj.self;
    }

    obj.ptr.autorelease();
    return null;
    
}

/**
    Attempts to wrap existing D Object `dobj`.
    Returns whether this succeded.
*/
bool drt_wrap_self(T)(T dobj, id from) if (is(T : DRTBindable)) {
    if (!DRTObject.isReady())
        DRTObject.initialize();

    // Can't wrap null
    if (!dobj)
        return false;

    // If the object already has a wrapping,
    // make sure we're wrapped to it.
    if (auto obj = _drt_get(from)) {
        return dobj.drt_handle() && dobj.drt_handle() == obj.ptr;
    }

    // There was no DRTObject handle associated
    // with the type stored in dobj
    auto obj = _drt_set(from, DRTObject.create(from.class_));
    if (obj) {
        obj.self = dobj;
        return true;
    }

    // Failed, invalid object referenced by dobj.
    obj.ptr.autorelease();
    return false;
}

id drt_get_handle(T)(T dobj) if (is(T : DRTBindable)) {
    if (!DRTObject.isReady())
        DRTObject.initialize();

    // Can't wrap null
    if (!dobj || !dobj.self)
        return id.none;

    return _drt_get(dobj.self).ptr;
}


private extern(C):

// Gets the DRTObject associated with for_
DRTObject _drt_get(id for_) {

    // NOTE: every time we get the association retain is called on it.
    // as such we need to release that single retain.
    id wrp_ = for_.getAssociation(DRTObject._DRTObjectKey);
    wrp_.release();

    return DRTObject(wrp_);
}

// Sets the DRTObject associated with for_
DRTObject _drt_set(id for_, DRTObject toSet) {
    if (for_) {
        for_.associate(
            DRTObject._DRTObjectKey, 
            toSet.ptr, 
            objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN 
        );
        return _drt_get(for_);
    }
    return DRTObject(id.none);
}

/**
    An instance of DRTObject
*/
struct DRTObject {
nothrow @nogc:
private:
    __gshared Class _DRTObject_class;
    __gshared const(char)* _DRTObjectKey = "_DRTObjectKey";

    debug(DRT) __gshared size_t allocated;
    debug(DRT) __gshared size_t freed;

public:
    id ptr;
    alias ptr this;

    // Reference
    this(id ptr) { this.ptr = ptr; }

    // Create
    static DRTObject create(Class hType) {
        if (!DRTObject.isReady)
            DRTObject.initialize();

        auto obj = DRTObject(ptr: _DRTObject_class.alloc().send!id("initWithHost:", hType));
        return obj;
    }

    /// Gets the retain count
    NSUInteger retainCount() => ptr.send!NSUInteger("retainCount");

    // Gets the self variable.
    DRTBindable self() => ptr.getVariable!DRTBindable("_this");
    void self(DRTBindable self_) => ptr.setVariable("_this", cast(void*)self_);

    // Gets which Objective-C class the D class is bound to.
    Class boundTo() => ptr.getVariable!Class("_class");
    void boundTo(Class binding) => ptr.setVariable("_class", cast(void*)binding);

    // Gets whether the DRTObject is ready for use.
    static bool isReady() => _DRTObject_class !is null;

    // Initializes the DRTObject
    static void initialize() {
        if (this.isReady)
            return;

        debug(DRT) printf("[DRT] Initializing DRTObject...\n");

        // We create our _DRTClass class.
        _DRTObject_class = Class.allocateClassPair(Class.lookup("NSObject"), "_DRTObject", 0);

        // Then our wrapper functions
        _DRTObject_class.addMethod(SEL.get("initWithHost:"), cast(IMP)&_drt_init, "@@:#");
        _DRTObject_class.addMethod(SEL.get("dealloc"), cast(IMP)&_drt_dealloc, "v@:");
        _DRTObject_class.addIvar("_this", DRTBindable.sizeof, cast(ubyte)log2(DRTBindable.sizeof), "?");
        _DRTObject_class.addIvar("_class", Class.sizeof, cast(ubyte)log2(Class.sizeof), "#");
        _DRTObject_class.register();

        debug(DRT) {
            printf("[DRT] Initialized DRTObject class\n");

            Method[] methods = _DRTObject_class.methods();
            foreach(method; methods) {
                printf("[DRT]  - Method: %s (argcount=%i)\n", method.name, method.argCount());
            }
            free(methods.ptr);
            

            printf("[DRT] Initialization completed!\n");
        }
    }
}

id _drt_init(DRTObject self_, SEL _cmd, Class host) {
    self_.boundTo = host;

    debug(DRT) DRTObject.allocated++;
    return self_.ptr;
}

void _drt_dealloc(DRTObject self_, SEL _cmd) {
    if (auto bindable = self_.self()) {
        bindable.notifyDealloc(self_);
        nogc_delete(bindable);
    }

    debug(DRT) DRTObject.freed++;

    self_.send!void(self_.superclass(), "dealloc");
}

debug(DRT) {
    pragma(crt_destructor)
    void _drt_crt_destructor() {
        printf("[DRT] Program ended.\n");
        printf("[DRT]  - %i allocated\n", DRTObject.allocated);
        printf("[DRT]  - %i freed\n", DRTObject.freed);
    }
}