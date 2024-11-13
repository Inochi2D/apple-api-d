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
import apple.objc.nsobject;
import apple.objc.rt;
import apple.objc.rt : selector;
import apple.os;

mixin RequireAPIs!(Foundation);

/**
    NSString
*/
@ObjectiveC
class NSString : NSObject {
@nogc nothrow:
protected:

    /// Initialize NSString with characters.
    id initWithUTF8String(const(char)* str) @selector("initWithUTF8String:");

public:

    /**
        A null-terminated UTF8 representation of the string.
    */
    @property const(char)* UTF8String() const;

    /**
        The number of UTF-16 code units in the receiver.
    */
    @property NSUInteger length() const;

    /**
        Create from CoreFoundation string.
    */
    version(CoreFoundation) 
    this(CFStringRef str) {
        super(cast(id)str);
    }

    /**
        Base constructor
    */
    this(id self) { super(self); }

    /**
        Construct with UTF8 string.
    */
    this(const(char)* str) {
        super(this.alloc());
        this.self = this.initWithUTF8String(str);
    }

    /**
        Implements toString for NSString.
    */
    override
    string toString() => cast(string)this.UTF8String()[0..this.length()];

    /**
        Casts NSString to CFStringRef
    */
    version(CoreFoundation) 
    CFStringRef toCFString() => cast(CFStringRef)this.self();

    // Link NSString.
    mixin ObjcLink;
}