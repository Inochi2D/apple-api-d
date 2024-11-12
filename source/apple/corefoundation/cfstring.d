/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    CFString
*/
module apple.corefoundation.cfstring;
import apple.corefoundation.cfbase;
import apple.corefoundation.cfallocator;
import apple.corefoundation;
import apple;
import apple.os;

mixin RequireAPIs!(CoreFoundation);
extern(C) @nogc nothrow:

/// Only available on apple OSes.
version(AppleOS):

/**
    An integer type for constants used to specify supported string encodings in various CFString functions.
*/
alias CFStringEncoding = uint;

/**
    Encodings that are built-in on all platforms on which macOS and its derivatives run.
*/
enum CFStringBuiltInEncodings : CFStringEncoding {
    macRoman        = 0,
    windowsLatin1   = 1280,
    isoLatin1       = 513,
    nextStepLatin   = 2817,
    ASCII           = 1536,
    unicode         = 256,
    utf8            = 134217984,
    nonLossyASCII   = 3071,
}

/**
    Creates a string from a buffer containing characters in a specified encoding.
*/
CFStringRef CFStringCreateWithBytes(CFAllocatorRef, ubyte*, CFIndex, CFStringEncoding, bool);

/**
    Creates a string from a buffer, containing characters in a specified encoding, 
    that might serve as the backing store for the new string.
*/
CFStringRef CFStringCreateWithBytesNoCopy(CFAllocatorRef, ubyte*, CFIndex, CFStringEncoding, bool, CFAllocatorRef);

/**
    Creates a string from a buffer of UTF-16 Unicode characters.
*/
CFStringRef CFStringCreateWithCharacters(CFAllocatorRef, wchar*, CFIndex);

/**
    Creates a string from a buffer of UTF-16 Unicode characters that might 
    serve as the backing store for the object. 
*/
CFStringRef CFStringCreateWithCharactersNoCopy(CFAllocatorRef, wchar*, CFIndex, CFAllocatorRef);

/**
    Creates an immutable string from a C string.
*/
CFStringRef CFStringCreateWithCString(CFAllocatorRef, const(char)*, CFStringEncoding);

/**
    Creates a CFString object from an external C string buffer that might 
    serve as the backing store for the object. 
*/
CFStringRef CFStringCreateWithCStringNoCopy(CFAllocatorRef, const(char)*, CFStringEncoding, CFAllocatorRef);

/**
    Creates a CFString object from an external C string buffer that might 
    serve as the backing store for the object. 
*/
CFStringRef CFStringCreateWithFormatAndArguments(CFAllocatorRef, CFDictionaryRef, CFString, ...);