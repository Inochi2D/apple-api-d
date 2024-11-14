/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    Core Foundation Type Definitions
*/
module apple.corefoundation.cftypes;
import apple.os;

extern(C) @nogc nothrow:

/**
    Underlying opaque type for CFString
*/
struct __CFString;

/**
    Underlying opaque type for CFNull
*/
struct __CFNull;

/**
    A type for unique, constant integer values that identify particular Core Foundation opaque types.
*/
alias CFTypeID = UInt;

/**
    CFOptionFlags
*/
alias CFOptionFlags = UInt;

/**
    A type for hash codes returned by the CFHash function.
*/
alias CFHashCode = UInt;

/**
    Priority values used for kAXPriorityKey
*/
alias CFIndex = Int;

/**
    Type used to represent elapsed time in seconds.
*/
alias CFTimeInterval = double;

/**
    An untyped "generic" reference to any Core Foundation object.
*/
alias CFTypeRef = void*;

/**
    An Immutable CoreFoundation String
*/
alias CFStringRef = const(__CFString)*;

/**
    A Mutable CoreFoundation String
*/
alias CFMutableStringRef = __CFString*;

/**
    Type to mean any instance of a property list type;
    currently, CFString, CFData, CFNumber, CFBoolean, CFDate,
    CFArray, and CFDictionary.
*/
alias CFPropertyListRef = CFTypeRef;

/**
    CoreFoundation "null" type.
*/
alias CFNullRef = const(__CFNull)*;

/**
    Result of a comparison.
*/
enum CFComparisonResult : CFIndex {
    lessThan = -1,
    equalTo = 0,
    greaterThan = 1
}

/**
    Constant used by some functions to indicate failed searches.
*/
enum CFIndex kCFNotFound = -1;

/**
    A structure representing a range of sequential items in a container, 
    such as characters in a buffer or elements in a collection.
*/
struct CFRange {
    /**
        An integer representing the number of items in the range.
    
        For type compatibility with the rest of the system, [CFIndex.max] is the maximum value you should use for length.
    */
    CFIndex length;

    /**
        An integer representing the starting location of the range.
    
        For type compatibility with the rest of the system, [CFIndex.max] is the maximum value you should use for location.
    */
    CFIndex location;
}