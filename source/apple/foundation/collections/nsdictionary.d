/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    Bindings to NSDictionary
*/
module apple.foundation.collections.nsdictionary;
import apple.corefoundation;
import apple.foundation;
import apple.objc;
import apple.objc : selector;
import apple.os;

mixin RequireAPIs!(Foundation, CoreFoundation, ObjC);

/**
    NSDictionary
*/
@ObjectiveC @TollFreeBridged!CFDictionaryRef
class NSDictionary(Key, Value) : NSObject, NSCopying, NSFastEnumeration, NSMutableCopying, NSSecureCoding
if(is(Key : DRTBindable) && (is(Value : DRTBindable) || is(Value == id))) {
@nogc nothrow:
public:

    /**
        The number of entries in the dictionary.
    */
    @property NSUInteger count() const;

    /**
        A string that represents the contents of the dictionary, formatted as a property list.
    */
    @property NSString description() const;

    /**
        A new array containing the dictionary’s keys, or an empty 
        array if the dictionary has no entries.
    */
    @property NSArray!Key keys() const;

    /**
        A new array containing the dictionary’s values, or an 
        empty array if the dictionary has no entries.
    */
    @property NSArray!Value values() const;

    /**
        Base constructor
    */
    this(id self) { super(self); }

    /**
        Creates an empty dictionary.
    */
    this() { super(wrap(this.alloc().send!id("init"))); }

    /**
        Returns the value associated with a given key.
    */
    Value opIndex(Key index) {
        static if (is(Key : NSString))
            return this.message!Value("valueForKey:", index);
        else
            return this.message!Value("objectForKey:", index);
    }

    // Link NSDictionary.
    mixin ObjcLink!("NSDictionary");
}

/**
    NSDictionary
*/
@ObjectiveC @TollFreeBridged!CFMutableDictionaryRef
class NSMutableDictionary(Key, Value) : NSDictionary!(Key, Value) if (is(Key : NSCopying)) {
@nogc nothrow:
public:

    /**
        Base constructor
    */
    this(id self) { super(self); }

    /**
        Creates an empty dictionary.
    */
    this() { super(); }

    /**
        Adds a given key-value pair to the dictionary.
    */
    void opIndexAssign(Value value, Key key) {
        static if (is(Key : NSString))
            this.message!void("setValue:forKey:", value, key);
        else
            this.message!void("setObject:forKey:", value, key);
    }

    // Link NSMutableDictionary.
    mixin ObjcLink!("NSMutableDictionary");
}