/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    Bindings to Apple's Foundation API.
*/
module apple.foundation.nsarray;
import apple.corefoundation;
import apple.foundation;
import apple.objc.nsobject;
import apple.objc.rt;
import apple.objc.rt : selector;
import apple.os;

mixin RequireAPIs!(Foundation);

/**
    NSArray
*/
@ObjectiveC
class NSArray : NSObject {
@nogc nothrow:
public:

    /**
        The number of objects in the array.
    */
    @property NSUInteger count();

    /**
        Creates an empty NSArray
    */
    this() {
        super(this.message!id(this.getClass(), "array"));
    }

    /**
        Binds an NSArray from its low level implementation
    */
    this(id ref_) {
        super(ref_);
    }

    /**
        Creates an array which is a copy of another array.
    */
    this(NSArray toCopy) {
        super(this.message!id(this.getClass(), "arrayWithArray:", toCopy));
    }
    
    /**
        Create from CoreFoundation array.
    */
    version(CoreFoundation) 
    this(CFArrayRef arr) {
        super(cast(id)arr);
    }

    /**
        Returns a Boolean value that indicates whether a given object is present in the array.
    */
    bool contains(NSObject obj) @selector("containsObject:");

    /**
        Returns the object located at the specified index.
    */
    id objectAtIndex(NSUInteger index) @selector("objectAtIndex:");

    /**
        Casts NSArray to CFArrayRef
    */
    version(CoreFoundation)
    CFArrayRef toCFArray() => cast(CFArrayRef)this.self();

    // Link NSArray.
    mixin ObjcLink;
}

/**
    Typed wrapper over NSArray
*/
class NSArrayT(T = NSObject) : NSArray {
@nogc nothrow:
public:

    /// Creates new empty array
    this() { super(); }

    /// Creates array from ref
    this(id ref_) { super(ref_); }

    /**
        Gets object at specified index
    */
    T opIndex(NSUInteger index) {
        return wrap(cast(idref!T)this.objectAtIndex(index));
    }

    /// For D compat.
    alias length = count;
}