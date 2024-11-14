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
import apple.objc.rt;
import apple.objc.rt : selector;
import apple.os;

mixin RequireAPIs!(Foundation);

/**
    NSArray
*/
@ObjectiveC @TollFreeBridged!CFArrayRef
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
        super(this.message!id(this.objc_type(), "array"));
    }

    /**
        Binds an NSArray from its low level implementation
    */
    this(id ref_) { super(ref_); }

    /**
        Creates an array which is a copy of another array.
    */
    this(NSArray toCopy) {
        super(this.message!id(this.objc_type(), "arrayWithArray:", toCopy));
    }

    /**
        Returns a Boolean value that indicates whether a given object is present in the array.
    */
    bool contains(NSObject obj) @selector("containsObject:");

    /**
        Returns the object located at the specified index.
    */
    id objectAtIndex(NSUInteger index) @selector("objectAtIndex:");

    // Link NSArray.
    mixin ObjcLink;
}

/**
    A Mutable NSArray
*/
@ObjectiveC @TollFreeBridged!CFMutableArrayRef
class NSMutableArray : NSArray {
@nogc nothrow:
public:

    /**
        Base constructor
    */
    this(id self) { super(self); }

    // Link NSMutableString.
    mixin ObjcLink;
}

/**
    Typed wrapper over NSArray
*/
class NSArrayT(T = NSObject) : NSArray {
private:
    alias dg_type = int delegate(T);
    alias dgi_type = int delegate(size_t, T);

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
        return wrap!T(this.objectAtIndex(index));
    }

    /**
        Allows iterating over the array.
    */
    int opApply(scope dg_type dg) {
        import numem.core.memory.alloc : assumeNothrowNoGC;

        auto ngc_dg = assumeNothrowNoGC!(dg_type)(dg);
        foreach (i; 0..length) {
            int result = ngc_dg(this[i]);
            if (result)
                return result;
        }
        return 0;
    }

    /**
        Allows iterating over the array in reverse.
    */
    int opApplyReverse(scope dg_type dg) {
        import numem.core.memory.alloc : assumeNothrowNoGC;

        auto ngc_dg = assumeNothrowNoGC!(dg_type)(dg);
        foreach (i; 0..length) {
            int result = ngc_dg(this[i]);
            if (result)
                return result;
        }
        return 0;
    }

    /**
        Allows iterating over the array, with index.
    */
    int opApply(scope dgi_type dg) {
        import numem.core.memory.alloc : assumeNothrowNoGC;

        auto ngc_dg = assumeNothrowNoGC!(dgi_type)(dg);
        foreach (i; 0..length) {
            int result = ngc_dg(i, this[i]);
            if (result)
                return result;
        }
        return 0;
    }

    /**
        Allows iterating over the array in reverse, with index.
    */
    int opApplyReverse(scope dgi_type dg) {
        import numem.core.memory.alloc : assumeNothrowNoGC;

        auto ngc_dg = assumeNothrowNoGC!(dgi_type)(dg);
        foreach (i; 0..length) {
            int result = ngc_dg(i, this[i]);
            if (result)
                return result;
        }
        return 0;
    }

    /**
        Gets the first element
    */
    T front() => length > 0 ? this[0] : null;

    /**
        Gets the last element
    */
    T back() => length > 0 ? this[$-1] : null;

    /// For D compat.
    alias length = count;
    alias opDollar = length;
}