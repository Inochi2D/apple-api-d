/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    Bindings to NSError
*/
module apple.foundation.nserror;
import apple.corefoundation;
import apple.foundation;

import apple.objc;
import apple.objc : selector;
import apple.os;

mixin RequireAPIs!(Foundation, CoreFoundation, ObjC);

/**
    An error domain
*/
alias NSErrorDomain = NSString;

/**
    These keys may exist in the user info dictionary.
*/
alias NSErrorUserInfoKey = NSString;

/**
    Information about an error condition including a domain, a domain-specific 
    error code, and application-specific information.
*/
@ObjectiveC
class NSError : NSObject {
@nogc nothrow:
public:

    /**
        The error code.
    */
    @property NSInteger code() const;

    /**
        A string containing the error domain.
    */
    @property NSErrorDomain code() const;

    /**
        The user info dictionary. 
    */
    @property NSDictionary!(NSErrorUserInfoKey, id) userInfo() const;

    /**
        Base constructor
    */
    this(id self) { super(self); }

    /**
        Constructs an NSError object initialized for a given domain 
        and code with a given userInfo dictionary. 
    */
    this(NSErrorDomain domain, NSInteger code, NSDictionary!(NSErrorUserInfoKey, id) dict) { 
        super(wrap(this.alloc().send!id("initWithDomain:code:userInfo:", domain, code, dict)));
    }

    // Link NSError.
    mixin ObjcLink;
}