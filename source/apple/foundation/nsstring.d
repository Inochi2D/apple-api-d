/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    Bindings to Apple's Foundation API.
*/
module apple.foundation.nsstring;
import apple.corefoundation;
import apple.foundation;
import apple.objc;
import apple.objc : selector;
import apple.os;

mixin RequireAPIs!(Foundation, CoreFoundation, ObjC);

/**
    NSString
*/
@ObjectiveC @TollFreeBridged!CFStringRef
class NSString : NSObject {
@nogc nothrow:
protected:

    /// Initialize NSString with characters.
    id initWithUTF8String(const(char)* str) @selector("initWithUTF8String:");

public:

    /**
        A null-terminated UTF8 representation of the string.
    */
    @property const(char)* utf8String() const @selector("UTF8String");

    /**
        The number of UTF-16 code units in the receiver.
    */
    @property NSUInteger length() const;

    /**
        Base constructor
    */
    this(id self) { super(self); }

    /**
        Construct with UTF8 string.
    */
    this(const(char)* str) {
        super(this.message!id(this.objc_type(), "string"));
        this.self = this.initWithUTF8String(str);
        this.selfwrap();
    }

    /**
        Implements toString for NSString.
    */
    override
    string toString() => cast(string)this.utf8String()[0..this.length()];

    // Link NSString.
    mixin ObjcLink;
}

@ObjectiveC @TollFreeBridged!CFMutableStringRef
class NSMutableString : NSString {
@nogc nothrow:
public:

    /**
        Base constructor
    */
    this(id self) { super(self); }

    // Link NSMutableString.
    mixin ObjcLink;
}