/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    Bindings to NSValue
*/
module apple.foundation.nsvalue;
import apple.corefoundation;
import apple.foundation;
import apple.objc;
import apple.objc : selector;
import apple.os;

mixin RequireAPIs!(Foundation, CoreFoundation, ObjC);

/**
    A simple container for a single C or Objective-C data item.
*/
@ObjectiveC
class NSValue : NSObject, NSCopying, NSSecureCoding {
@nogc nothrow:
public:

    /**
        Returns the value as an untyped pointer.
    */
    @property void* pointerValue();
    alias ptr = pointerValue;

    /**
        Base constructor
    */
    this(id self) { super(self); }

    /**
        Creates a value object containing the specified pointer.
    */
    this(T)(T* ptr) { super(wrap(SELF_TYPE.send!id("valueWithPointer:", cast(void*)ptr))); }

    // Link NSValue.
    mixin ObjcLink;
}

/**
    An object wrapper for primitive scalar numeric values.
*/
@ObjectiveC
class NSNumber : NSValue {
@nogc nothrow:
public:

    /**
        The number object's value expressed as a Boolean value.
    */
    @property bool boolValue() const;

    /**
        The number object's value expressed as a char.
    */
    @property byte charValue() const;

    /**
        The number object's value expressed as a Boolean value.
    */
    @property double doubleValue() const;

    /**
        The number object's value expressed as a Boolean value.
    */
    @property float floatValue() const;

    /**
        The number object's value expressed as a Boolean value.
    */
    @property int intValue() const;

    /**
        The number object's value expressed as a Boolean value.
    */
    @property short shortValue() const;

    /**
        The number object's value expressed as a Boolean value.
    */
    @property NSInteger integerValue() const;

    /**
        The number object's value expressed as a Boolean value.
    */
    @property long longLongValue() const;

    /**
        The number object's value expressed as a Boolean value.
    */
    @property ubyte unsignedCharValue() const;

    /**
        The number object's value expressed as a Boolean value.
    */
    @property ushort unsignedShortValue() const;

    /**
        The number object's value expressed as a Boolean value.
    */
    @property uint unsignedIntValue() const;

    /**
        The number object's value expressed as a Boolean value.
    */
    @property NSUInteger unsignedIntegerValue() const;

    /**
        The number object's value expressed as a Boolean value.
    */
    @property ulong unsignedLongLongValue() const;

    /**
        The number object's value expressed as a human-readable string.
    */
    @property NSString stringValue() const;

    /**
        Base constructor
    */
    this(id self) { super(self); }

    /**
        Creates and returns an NSNumber object containing a given value.
    */
    this(bool value) { super(wrap(Class(SELF_TYPE).send!id("numberWithBool:", value))); }

    /**
        Creates and returns an NSNumber object containing a given value.
    */
    this(char value) { super(wrap(Class(SELF_TYPE).send!id("numberWithChar:", value))); }

    /**
        Creates and returns an NSNumber object containing a given value.
    */
    this(byte value) { super(wrap(Class(SELF_TYPE).send!id("numberWithChar:", value))); }

    /**
        Creates and returns an NSNumber object containing a given value.
    */
    this(double value) { super(wrap(Class(SELF_TYPE).send!id("numberWithDouble:", value))); }

    /**
        Creates and returns an NSNumber object containing a given value.
    */
    this(float value) { super(wrap(Class(SELF_TYPE).send!id("numberWithFloat:", value))); }

    /**
        Creates and returns an NSNumber object containing a given value.
    */
    this(int value) { super(wrap(Class(SELF_TYPE).send!id("numberWithInt:", value))); }

    /**
        Creates and returns an NSNumber object containing a given value.
    */
    this(short value) { super(wrap(Class(SELF_TYPE).send!id("numberWithShort:", value))); }

    /**
        Creates and returns an NSNumber object containing a given value.
    */
    this(NSInteger value) { super(wrap(Class(SELF_TYPE).send!id("numberWithInteger:", value))); }

    /**
        Creates and returns an NSNumber object containing a given value.
    */
    this(ubyte value) { super(wrap(Class(SELF_TYPE).send!id("numberWithUnsignedChar:", value))); }

    /**
        Creates and returns an NSNumber object containing a given value.
    */
    this(ushort value) { super(wrap(Class(SELF_TYPE).send!id("numberWithUnsignedShort:", value))); }

    /**
        Creates and returns an NSNumber object containing a given value.
    */
    this(uint value) { super(wrap(Class(SELF_TYPE).send!id("numberWithUnsignedInt:", value))); }

    /**
        Creates and returns an NSNumber object containing a given value.
    */
    this(NSUInteger value) { super(wrap(Class(SELF_TYPE).send!id("numberWithUnsignedInteger:", value))); }

    /**
        Gets whether this number is equal to another.
    */
    bool isEqual(NSNumber other) @selector("isEqualToNumber:");

    /**
        Implements equality comparison
    */
    @objc_ignore
    bool opEquals(T)(T other) @nobind if (is(T : NSNumber)) {
        return this.isEqual(other.self_);
    }

    // Link NSNumber.
    mixin ObjcLink;
}