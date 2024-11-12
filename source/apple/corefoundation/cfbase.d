/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    Core Foundation Base APIs
*/
module apple.corefoundation.cfbase;
import apple.corefoundation.cfallocator;
import apple.os;

/// Enum used as a version tag.
enum CoreFoundation;

// Link to CoreFoundation (on apple platforms) otherwise 
// Otherwise the developer is responsible for linking to
// the correct library.
mixin RequireAPIs!(CoreFoundation);
mixin LinkFramework!("CoreFoundation");
extern(C) @nogc nothrow:

/**
    Underlying opaque type for CFString
*/
struct __CFString;

/**
    The current version of the Core Foundation framework
*/
extern(C) extern __gshared double kCFCoreFoundationVersionNumber;

enum kCFCoreFoundationVersionNumber10_0     = 196.4;
enum kCFCoreFoundationVersionNumber10_0_3   = 196.5;
enum kCFCoreFoundationVersionNumber10_1     = 226.0;
enum kCFCoreFoundationVersionNumber10_1_2   = 227.2;
enum kCFCoreFoundationVersionNumber10_1_4   = 227.3;
enum kCFCoreFoundationVersionNumber10_2     = 263.0;

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
    Result of a comparison.
*/
enum CFComparisonResult : CFIndex {
    lessThan = -1,
    equalTo = 0,
    greaterThan = 1
}

/**
    Callback function that compares two values. 
    You provide a pointer to this callback in certain Core Foundation sorting functions.
*/
alias CFComparatorFunction = extern(C) CFComparisonResult function(const(void)* val1, const(void)* val2, void* context);

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

/**
    Underlying opaque type handle for the CoreFoundation "null" type.
*/
struct __CFNull;

/**
    CoreFoundation "null" type.
*/
alias CFNullRef = const(__CFNull)*;

/**
    A CFNullRef singleton instance.
*/
extern(C) extern const __gshared CFNullRef kCFNull;

/**
    Gets the Type ID of the CoreFundation Null type.
*/
extern CFTypeID CFNullGetTypeID();

/**
    Releases a Core Foundation object.
*/
extern void CFRelease(CFTypeRef);

/**
    Retains a Core Foundation object.
*/
extern void CFRetain(CFTypeRef);

/**
    Makes a newly-allocated Core Foundation object eligible for garbage collection.
*/
extern CFTypeRef CFMakeCollectable(CFTypeRef);

/**
    Returns the reference count of a Core Foundation object.
*/
extern CFIndex CFGetRetainCount(CFTypeRef);

/**
    Returns the allocator used to allocate a Core Foundation object.
*/
extern CFAllocatorRef CFGetAllocator(CFTypeRef);

/**
    Determines whether two Core Foundation objects are considered equal.
*/
extern bool CFEqual(CFTypeRef, CFTypeRef);

/**
    Determines whether two Core Foundation objects are considered equal.
*/
extern CFHashCode CFHash(CFTypeRef, CFTypeRef);

/**
    Returns a textual description of a Core Foundation object.
*/
extern CFStringRef CFCopyDescription(CFTypeRef);

/**
    Returns a textual description of a Core Foundation object.
*/
extern CFStringRef CFCopyTypeIDDescription(CFTypeID);

/**
    Returns the unique identifier of an opaque type to which a Core Foundation object belongs.
*/
extern CFTypeID CFGetTypeID(CFTypeRef);

/**
    Prints a description of a Core Foundation object to stderr.
*/
extern void CFShow(CFTypeRef);