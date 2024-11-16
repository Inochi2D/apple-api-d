/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    D Runtime Integration for Objective-C
*/
module apple.objc.rt.drt;
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

public import apple.objc.rt.drt.scoped;
public import apple.objc.rt.drt.wrap;

mixin RequireAPIs!(ObjC);

@nogc nothrow:

/**
    Wraps a foreign objective-c handle.

    In debug mode will verify that the class matches the provided
    D wrapper class type.
*/
T __from_foreign(T)(void* foreignHandle) if (is(T : DRTBindable)) {
    any handle = cast(any)foreignHandle;

    assert(id(handle).class_() == T.SELF_TYPE, "Foreign handle was not a "~T.stringof~"!");
    return drt_wrap!T(id(handle));
}

/**
    An ID which is wrapped to a D type.

    This allows passing the ID around in blocks and the like.
*/
struct idref(T) {
nothrow @nogc:
public:
    id ptr;
    alias ptr this;

    /**
        Allows creating from D object
    */
    this(T obj_) { this.ptr = obj_.self; }

    /**
        Constructor
    */
    this(id self_) { this.ptr = self_; }

    /**
        Gets the wrapped class instance.
    */
    T get() => drt_wrap!T(this.ptr);
}

/**
    Base class implemented by all DRT bindable types.
*/
abstract
class DRTBindable {
nothrow @nogc:
private:
    id self_;

protected:

    /**
        Allows updating self value.
    */
    final
    @objc_ignore
    @property id self(id newValue) { this.self_ = newValue; return self_; }

    /**
        Tells the DRT subsystem to wrap this class instance to the
        Objective-C class.
    */
    final
    @objc_ignore
    id wrap(id self_) {
        this.drt_wrap_self(self_);
        return self_;
    }

public:

    /**
        A numem event called when the bindable has been released
        from the Objective-C side.
    */
    Event!DRTBindable onReleased;

    /**
        Gets the handle of the association for this objective-c class.
    */
    final
    @objc_ignore
    @property id drt_handle() => drt_get_handle(this);

    /**
        Gets the underlying Objective-C reference.
    */
    final
    @objc_ignore
    @property id self() inout => cast(id)this.self_;

    /**
        Gets the underlying Objective-C type
        Either a Class or Protocol.
    */
    @objc_ignore
    @property any objc_type() inout => null;

    /**
        Base constructor
    */
    this(id self) { this.self_ = self; }

    /**
        Called when the DRT type is being wrapped.
    */
    @objc_ignore
    void notifyWrap(id byWhom) { }

    /**
        Called when the DRT type is being unwrapped.
    */
    @objc_ignore
    void notifyUnwrap(id byWhom) { }

    /**
        Called when the DRT type is being destroyed.
    */
    @objc_ignore
    void notifyDealloc(id byWhom) {

        // onReleased can only throw NuException
        // so we can safely assume that `ex` is NuException.
        try { this.onReleased(this); } catch(Exception ex) { nogc_delete(ex); } 
        
        this.self_ = null;
    }

    /**
        Retain
    */
    @objc_ignore
    final void retain() { self_.retain(); }

    /**
        Release
    */
    @objc_ignore
    final void release() { self_.release(); }

    /**
        Auto-release
    */
    @objc_ignore
    final void autorelease() { self_.autorelease(); }

    /**
        Sends a message (calls a function) based on the given selector.
    */
    @objc_ignore
    T message(T, Args...)(const(char)* selector, Args args) inout {
        static if (is(T : DRTBindable))
            return cast(T)drt_wrap!T(self.send!id(SEL.get(selector), args));
        else 
            return cast(T)self.send!T(SEL.get(selector), args);
    }

    /**
        Sends a message (calls a function) based on the given selector.
        A class instance will need to be specified.
    */
    @objc_ignore
    static T message(T, Args...)(any target, const(char)* selector, Args args) {
        static if (is(T : DRTBindable))
            return cast(T)drt_wrap!T(Class(target).send!id(SEL.get(selector), args));
        else 
            return cast(T)Class(target).send!T(SEL.get(selector), args);
    }

    /**
        Helper function that calls in to drt_wrap
    */
    @objc_ignore
    static T wrap(T)(id self) {
        return drt_wrap!T(self);
    }
}
