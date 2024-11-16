/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    Bindings to NSObject and NSObjectProtocol
*/
module apple.foundation.nsobject;
import apple.foundation.nstypes;
import apple.foundation.nscoder;
import apple.foundation.nszone;
import apple.os;

import apple.objc : ObjC;
mixin RequireAPIs!(ObjC);

import apple.objc.rt.drt;

import apple.objc;
import apple.objc : selector;
import numem.core.memory;

/**
    A protocol that enables encoding and decoding in a manner 
    that is robust against object substitution attacks.
*/
@ObjectiveC @ObjcProtocol
interface NSSecureCoding {
@nogc nothrow:
public:

    /**
        A Boolean value that indicates whether or not the class 
        supports secure coding.
    */
    @property bool supportsSecureCoding();
}

/**
    A protocol that enables an object to be encoded and 
    decoded for archiving and distribution.
*/
@ObjectiveC @ObjcProtocol
interface NSCoding {
@nogc nothrow:
public:
    
    /**
        Encodes the receiver using a given archiver.
    */
    void encodeWithCoder(NSCoder coder) @selector("encodeWithCoder:");
}

@ObjectiveC @ObjcProtocol
interface NSObjectProtocol {
@nogc nothrow:

    /**
        Returns the superclass for this object
    */
    @property Class superclass();

    /**
        Returns a Boolean value that indicates whether the receiver and a given object are equal.
    */
    bool isEqual(inout(id) obj) @selector("isEqual:");

    /**
        Returns an integer that can be used as a table address in a hash table structure.
    */
    @property NSUInteger hash();
}

/**
    A protocol that objects adopt to provide functional copies of themselves.
*/
@ObjectiveC @ObjcProtocol
interface NSMutableCopying {
@nogc nothrow:
public:

    /**
        Returns a new instance that’s a copy of the receiver.
    */
    id mutableCopyWithZone(NSZone* zone) @selector("mutableCopyWithZone:");
}

/**
    A protocol that objects adopt to provide functional copies of themselves.
*/
@ObjectiveC @ObjcProtocol
interface NSCopying {
@nogc nothrow:
public:

    /**
        Returns a new instance that’s a copy of the receiver.
    */
    id copyWithZone(NSZone* zone) @selector("copyWithZone:");
}

/**
    Base class of all Objective-C classes.
*/
@ObjectiveC
class NSObject : DRTBindable, NSObjectProtocol {
@nogc nothrow:
public:

    /**
        Base constructor
    */
    this(id self) { super(self); }

    /**
        Constructs an object with initial parameters.
    */
    this() { super(wrap(this.alloc().initialize())); }
    
    /**
        Implements equality comparison
    */
    @objc_ignore
    bool opEquals(T)(T other) if (is(T : NSObject)) {
        return this.isEqual(other.self_);
    }

    // Link NSObject.
    mixin ObjcLink;
}

/**
    Calls the `alloc` function for the object.
*/
id alloc(NSObject obj_) nothrow @nogc {
    return Class(obj_.objc_type()).alloc();
}