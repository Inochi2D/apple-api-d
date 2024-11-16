/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    Bindings to NSArray
*/
module apple.foundation.collections.nsarray;
import apple.corefoundation;
import apple.foundation;
import apple.objc.rt;
import apple.objc.rt : selector;
import apple.os;

mixin RequireAPIs!(Foundation);

private alias iter_func(T) = int delegate(T);
private alias iter_i_func(T) = int delegate(size_t, T);

/**
    A static ordered collection of objects.
*/
@ObjectiveC @TollFreeBridged!CFArrayRef
class NSArray(T) : NSObject, NSCopying, NSMutableCopying, NSSecureCoding, NSFastEnumeration
if(is(T : DRTBindable) || is(T : id)) {
private:
@nogc nothrow:
public:

    /**
        The number of objects in the array.
    */
    @property NSUInteger count() const;

    /**
        Gets the first element
    */
    @property T front() const @selector("firstObject");

    /**
        Gets the last element
    */
    @property T back() const @selector("lastObject");

    /**
        Creates an empty NSArray
    */
    this() { super(wrap(this.alloc().send!id("init"))); }

    /**
        Base constructor
    */
    this(id self) { super(self); }

    /**
        Returns a Boolean value that indicates whether a given object is present in the array.
    */
    bool contains(T obj) @selector("containsObject:");

    /**
        Returns the object located at the specified index.
    */
    @objc_ignore
    T opIndex(NSUInteger index) {
        return this.message!T("objectAtIndex:", index);
    }

    /**
        Returns the lowest index whose corresponding array 
        value is equal to a given object.
    
        Returns -1 if not found.
    */
    @objc_ignore
    ptrdiff_t find(T obj_) {
        auto idx = this.message!NSUInteger("indexOfObject:", obj_);
        return idx != NSNotFound ? idx : -1;
    }

    /**
        Allows iterating over the array.
    */
    @objc_ignore
    int opApply(scope iter_func!T dg) {
        import numem.core.memory.alloc : assumeNothrowNoGC;

        auto ngc_dg = assumeNothrowNoGC!(iter_func!T)(dg);
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
    @objc_ignore
    int opApplyReverse(scope iter_func!T dg) {
        import numem.core.memory.alloc : assumeNothrowNoGC;

        auto ngc_dg = assumeNothrowNoGC!(iter_func!T)(dg);
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
    @objc_ignore
    int opApply(scope iter_i_func!T dg) {
        import numem.core.memory.alloc : assumeNothrowNoGC;

        auto ngc_dg = assumeNothrowNoGC!(iter_i_func!T)(dg);
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
    @objc_ignore
    int opApplyReverse(scope iter_i_func!T dg) {
        import numem.core.memory.alloc : assumeNothrowNoGC;

        auto ngc_dg = assumeNothrowNoGC!(iter_i_func!T)(dg);
        foreach (i; 0..length) {
            int result = ngc_dg(i, this[i]);
            if (result)
                return result;
        }
        return 0;
    }

    /// For D compat.
    alias length = count;
    alias opDollar = length;

    // Link NSArray.
    mixin ObjcLink!("NSArray");
}

/**
    A Mutable NSArray
*/
@ObjectiveC @TollFreeBridged!CFMutableArrayRef
class NSMutableArray(T) : NSArray!T {
@nogc nothrow:
public:

    /**
        Base constructor
    */
    this(id self) { super(self); }

    /**
        Allocates an empty array
    */
    this() { super(); }

    /**
        Empties the array of all its elements.
    */
    void clear() {
        this.message!void("removeAllObjects");
    }

    /**
        Removes the first object in the array 
    */
    @objc_ignore
    void popFront() {
        if (length > 0) this.remove(0);
    }

    /**
        Removes the object with the highest-valued index in the array 
    */
    void popBack() @selector("removeLastObject");

    /**
        Removes all occurrences in the array of a given object.
    */
    void remove(DRTBindable value) @selector("removeObject:");

    /**
        Removes the object at index
    */
    void remove(NSUInteger index) @selector("removeObjectAtIndex:");

    /**
        Sorts the array using the sorting function provided.
    */
    void sort(NSInteger function(DRTBindable, DRTBindable, void*) compareFunc, void* context=null) @selector("sortUsingFunction:context:");

    /**
        Sets the receiving array’s elements to those in another given array.
    */
    @objc_ignore
    void opAssign(NSArray other) {
        this.message!void("setArray:", other);
    }

    /**
        Inserts a given object at the end of the array.
    */
    @objc_ignore
    void opOpAssign(string op = "~")(DRTBindable value) {
        this.message!void("addObject:", value);
    }
    
    /**
        Inserts a given object into the array’s contents at a given index.
    */
    @objc_ignore
    void opIndexAssign(DRTBindable value, size_t index) {
        this.message!void("insertObject:atIndex:", value, index);
    }

    // Link NSMutableArray.
    mixin ObjcLink!("NSMutableArray");
}