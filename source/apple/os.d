/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    Helpers to determine information about the operating system.
*/
module apple.os;

/// Whether the OS is made by Apple.
version(OSX) enum AppleOS = true;
else version(iOS) enum AppleOS = true;
else version(TVOS) enum AppleOS = true;
else version(WatchOS) enum AppleOS = true;
else version(VisionOS) enum AppleOS = true;
else enum AppleOS = false;

/// Whether the OS is made by Apple for mobile platforms.
version(iOS) enum AppleMobileOS = true;
else version(TVOS) enum AppleMobileOS = true;
else version(WatchOS) enum AppleMobileOS = true;
else version(VisionOS) enum AppleMobileOS = true;
else enum AppleMobileOS = false;

/// Define versions for the different architectures Apple supports.
static if(AppleOS) {
}

// Power PC
version(PPC) enum AppleIsPowerPC = true;
else enum AppleIsPowerPC = false;

// Intel
version(X86) enum AppleIsIntel = true;
else version(X86_64) enum AppleIsIntel = true;
else enum AppleIsIntel = false;

// ARM
version(ARM) enum AppleIsARM = true;
else version(AArch64) enum AppleIsARM = true;
else enum AppleIsARM = false;

// Gets whether the current compilation target is supported by Apple.
enum AppleIsPlatformSupported = AppleOS && (AppleIsPowerPC || AppleIsIntel || AppleIsARM);

// Declaration of base types.
alias Boolean           = bool;
alias UInt8             = ubyte;
alias SInt8             = byte;
alias UInt16            = ushort;
alias SInt16            = short;
alias UInt32            = uint;
alias SInt32            = int;
alias UInt64            = ulong;
alias SInt64            = long;
alias Int               = ptrdiff_t;
alias UInt              = size_t;
alias UniChar           = wchar;
alias StringPtr         = const(char)*;
alias Str255            = const(char)[255];
alias ConstStr255Param  = const(char)*;
alias OSErr             = UInt16;
alias OSStatus          = UInt32;
alias UTF32Char         = dchar;
alias UTF16Char         = wchar;
alias UTF8Char          = char;
alias OSType            = uint;

/**
    Mixin template which instructs LDC and other compatible D compilers
    to link against the specified frameworks.
*/
mixin template LinkFramework(frameworks...) {
    
    import apple.os;
    static if(AppleOS) 
        static foreach(framework; frameworks) 
            pragma(linkerDirective, "-framework", framework);
}

/**
    Adds compile time error checking to ensure that the specified
    APIs are actually included in compilation.

    `VersionSpec` also defines the API currently being implemented.
    If that version is not declared, the rest of the module is skipped.
*/
mixin template RequireAPIs(VersionSpec, Required...) {
version(VersionSpec):
    static foreach(v; Required) {
        version(v) {} else static assert(0, VersionSpec.stringof, " requires ", v.stringof, " but it is not included!");
    }
}