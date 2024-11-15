/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    Bindings to NSString
*/
module apple.foundation.nsstring;
import apple.corefoundation;
import apple.foundation;
import apple.objc;
import apple.objc : selector;
import apple.os;

mixin RequireAPIs!(Foundation, CoreFoundation, ObjC);

// NSString init funcs
private nothrow @nogc {
    id initWithUTF8String(id self_, const(char)* str) {
        return NSObject.message!id(self_, "initWithUTF8String:", str);
    }
}

/**
    NSString
*/
@ObjectiveC @TollFreeBridged!CFStringRef
class NSString : NSObject {
@nogc nothrow:
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
        super(this.alloc().initWithUTF8String(str));
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

    /**
        Construct with UTF8 string.
    */
    this(const(char)* str) {
        super(this.alloc().initWithUTF8String(str));
        this.selfwrap();
    }

    // Link NSMutableString.
    mixin ObjcLink;
}