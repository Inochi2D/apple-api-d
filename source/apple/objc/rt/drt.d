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

mixin RequireAPIs!(ObjC);

@nogc nothrow:

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
    void selfwrap() {
        _drt_wrap_existing(this.self_, this);
    }

public:

    /**
        Gets the handle of the association for this objective-c class.
    */
    final
    @objc_ignore
    @property id drt_handle() => drt_get_handle(self_);

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
    @property id objc_type() inout => null;

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
        this.self_ = null;

        // This won't free other instances!
        DRTBindable self = this;
        nogc_delete(self);
    }

    /**
        Retain
    */
    @objc_ignore
    abstract void retain();

    /**
        Release
    */
    @objc_ignore
    abstract void release();

    /**
        Sends a message (calls a function) based on the given selector.
    */
    @objc_ignore
    T message(T, Args...)(const(char)* selector, Args args) inout {
        static if (is(T : DRTBindable))
            return cast(T)drt_wrap!T(drt_message!(id, Args)(cast(id)this.self(), sel_getUid(selector), args));
        else 
            return cast(T)drt_message!(T, Args)(cast(id)this.self(), sel_getUid(selector), args);
    }

    /**
        Sends a message (calls a function) based on the given selector.
        A class instance will need to be specified.
    */
    @objc_ignore
    static T message(T, Args...)(id target, const(char)* selector, Args args) {
        static if (is(T : DRTBindable))
            return cast(T)drt_wrap!T(drt_message!(id, Args)(cast(id)target, sel_getUid(selector), args));
        else 
            return cast(T)drt_message!(T, Args)(cast(id)target, sel_getUid(selector), args);
    }

    /**
        Helper function that calls in to drt_wrap
    */
    @objc_ignore
    static T wrap(T)(id self) {
        return drt_wrap!T(self);
    }
}

/**
    A struct which wraps an DRTBindable type and calls the
    retain and release functions automatically.
*/
struct DRTAutoRelease {
nothrow @nogc:
private:
    size_t depth;
public:
    import core.stdc.stdio : printf;

    DRTBindable bindable;
    alias bindable this;

    ~this() {
        bindable.release();
    }

    this(this) {
        bindable.retain();
        this.depth++;
    }

    this(DRTBindable bindable) {
        this.bindable = bindable;
        this.depth = 0;
    }
}

/**
    Gets whether class type of `instance` inherits from the `toCheck` class.
*/
bool drt_inherits(id instance, Class toCheck) {
    return drt_inherits(object_getClass(instance), toCheck);
} 

/**
    Gets whether `self` inherits from the `toCheck` class.
*/
bool drt_inherits(Class self, Class toCheck) {
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

//
//      Messages
//

/**
    Sends a message to an id instance
*/
T drt_message(T = void, Args...)(inout(id) instance, inout(SEL) selector, Args args) {
    alias fn = T function(inout(id), inout(SEL), toObjCArgTypes!(Args)) @nogc nothrow;

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
    Sends a message to an id instance
*/
T drt_message(T = void, Args...)(id instance, const(char)* selector, Args args) {
    return cast(T)drt_message!(T, Args)(instance, sel_getUid(selector), args);
}

/**
    Sends a message to an object's super class
*/
T drt_message_super(T = void, Args...)(inout(id) instance, inout(SEL) selector, Args args) {
    alias fn = T function(inout(objc_super*), inout(SEL), toObjCArgTypes!(Args)) @nogc nothrow;

    objc_super _super = objc_super(
        reciever: cast(id)instance,
        superClass: class_getSuperclass(object_getClass(cast(id)instance))
    );

    static if (OBJC_ABI == 1) {
        static if(is(T == struct)) {
            return (cast(fn)&objc_msgSendSuper_stret)(&_super, selector, args);
        } else {
            return (cast(fn)&objc_msgSendSuper)(&_super, selector, args);
        }
    } else static if (OBJC_ABI == 2) {
        return (cast(fn)&objc_msgSendSuper)(&_super, selector, args);
    } else static assert(0, "ABI is not supported!");
}

/**
    Sends a message to an object's super class
*/
T drt_message_super(T = void, Args...)(id instance, const(char)* selector, Args args) {
    return cast(T)drt_message_super!(T, Args)(instance, sel_getUid(selector), args);
}

//
//      Wrapping
//

/**
    Wraps the `to` ID to a D class that is bindable.

    If `to` is not an instance or subclass of `T` returns null.
    If `to` has no wrapping, creates one and returns it.
    If wrapping fails, returns null.

    Wrapped classes are subject to the reference counting of 
    Objective-C and their destructor will be called
    when the Objective-C reference count reaches 0.
*/
T drt_wrap(T)(id from) if (is(T : DRTBindable)) {
    if (!_drt_wrap_ready())
        _drt_wrap_init();

    // Can't wrap null.
    if (!from)
        return null;

    // Get the wrapper object
    id wrapper = _drt_get_wrap_obj(from);
    if (wrapper)
        return cast(T)_drt_get_bindable(wrapper);

    wrapper = _drt_bind_wrap_obj(from, nogc_new!T(from));
    if (wrapper)
        return cast(T)_drt_get_bindable(wrapper);
    
    // Operation failed.
    return null;
}

/**
    Removes wrapper object from `from`
*/
void drt_wrap_remove(id from) {
    id obj_ = _drt_get_wrap_obj(from);
    if (obj_) {
        __drt_unwrap(obj_, _DRT_unwrap);
        _drt_set_wrap_obj(from, null);

        // Release *after* so that we don't
        // end up destroying the other object.
        drt_message(obj_, "release");
    }
}

/**
    Gets a handle to the DRT wrapper object.
*/
id drt_get_handle(id to) {
    return _drt_get_wrap_obj(to);
}

private extern(C):

/**
    Allows specifying an existing class instance to wrap as.
*/
void _drt_wrap_existing(id from, DRTBindable self) {
    if (!_drt_wrap_ready())
        _drt_wrap_init();

    // Can't wrap null.
    if (from && !_drt_get_wrap_obj(from)) {
        _drt_bind_wrap_obj(from, self);
    }
}

/**
    Gets the wrapper object
*/
id _drt_get_wrap_obj(id ref_) {
    return objc_getAssociatedObject(ref_, _DRT_GLUEASSOC_KEY);
}

/**
    Sets the wrapper object
*/
void _drt_set_wrap_obj(id ref_, id wrap_) {
    objc_setAssociatedObject(ref_, _DRT_GLUEASSOC_KEY, wrap_, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN | objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN);
}

/**
    Sets the wrapper object for ref_

    Returns the wrapper object.
*/
id _drt_bind_wrap_obj(id ref_, DRTBindable bindable) {
    
    // Get existing wrapper and re-wrap it if neccesary.
    id obj_ = _drt_get_wrap_obj(ref_);
    if (obj_) {
        __drt_wrap(obj_, _DRT_wrap, bindable);
        return obj_; 
    }

    // No wrapper existed, we need to create a new one.
    obj_ = _drt_new();
    __drt_wrap(obj_, _DRT_wrap, bindable);
    _drt_set_wrap_obj(ref_, obj_);
    return obj_;
}

/**
    Gets whether the wrapper is ready
*/
bool _drt_wrap_ready() {
    return _DRT !is null;
}

/**
    Initializes the wrapper
*/
void _drt_wrap_init() {

    // Just in case.
    if (_drt_wrap_ready())
        return;

    // We create our _DRTClass class.
    _DRT = objc_allocateClassPair(objc_lookUpClass("NSObject"), "_DRTObject", 0);

    // Then our wrapper functions
    _DRT_wrap = sel_registerName("wrap:");
    _DRT_dealloc = sel_registerName("dealloc");
    _DRT_unwrap = sel_registerName("unwrap");
    class_addMethod(_DRT, _DRT_wrap, cast(IMP)&__drt_wrap, "v@:^v");
    class_addMethod(_DRT, _DRT_unwrap, cast(IMP)&__drt_unwrap, "v@:");
    class_replaceMethod(_DRT, _DRT_dealloc, cast(IMP)&__drt_dealloc, "v@:");
    class_addIvar(_DRT, "_this", DRTBindable.sizeof, cast(ubyte)log2(DRTBindable.sizeof), "?");

    // Finally we register ourselves. 
    // _DRTObject is now ready for use!
    objc_registerClassPair(_DRT);
}

/**
    Allocates DRT wrapper class
*/
id _drt_new() {
    
    // Alloc and init our type.
    id obj_ = drt_message!id(cast(id)_DRT, "alloc");
    obj_ = drt_message!id(obj_, "init");
    return obj_;
}

/**
    Returns the underlying DRTBindable type
*/
DRTBindable _drt_get_bindable(id self) {
    DRTBindable bindable;
    object_getInstanceVariable(self, "_this", cast(void**)&bindable);
    return bindable;
}

/**
    Sets the underlying DRTBindable type
*/
void _drt_set_bindable(id self, DRTBindable bindable) {
    object_setInstanceVariable(self, "_this", cast(void*)bindable);
}

// Implementation of wrap:
extern(C) void __drt_wrap(id self, SEL _cmd, DRTBindable bindable) {

    // Unwrap old bindable if neccesary.
    if (auto _this = _drt_get_bindable(self))
        _this.notifyUnwrap(self);
    
    // Wrap new.
    _drt_set_bindable(self, bindable);
    bindable.notifyWrap(self);
}

// Implementation of unwrap
extern(C) void __drt_unwrap(id self, SEL _cmd) {
    if (auto _this = _drt_get_bindable(self)) {
        _this.notifyUnwrap(self);
        _drt_set_bindable(self, null);
    }
}

// Implementation of dealloc
extern(C) void __drt_dealloc(id self, SEL _cmd) {
    if (auto _this = _drt_get_bindable(self)) {
        // Unwrap first
        __drt_unwrap(self, _DRT_unwrap);

        // Then dealloc
        _this.notifyDealloc(self);
    }

    // Call super-class dealloc function.
    drt_message_super(self, "dealloc");
}

pragma(mangle, "DRT_CLASS_$_DRT")
extern(C) __gshared Class _DRT; 

extern(C) __gshared id _DRT_GLUEASSOC_KEY;

extern(C) __gshared SEL _DRT_wrap;
extern(C) __gshared SEL _DRT_unwrap;
extern(C) __gshared SEL _DRT_dealloc;