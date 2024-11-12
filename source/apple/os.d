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
version(OSX) version = AppleOS;
else version(iOS) version = AppleOS;
else version(TVOS) version = AppleOS;
else version(WatchOS) version = AppleOS;
else version(VisionOS) version = AppleOS;

/// Add macOS tag since apple renamed OSX to macOS.
version(OSX) version = macOS;

/// Whether the OS is made by Apple for mobile platforms.
version(iOS) version = AppleMobileOS;
else version(TVOS) version = AppleMobileOS;
else version(WatchOS) version = AppleMobileOS;
else version(VisionOS) version = AppleMobileOS;

/// Define versions for the different architectures Apple supports.
version(AppleOS) {
    version(PPC) version = AppleOSPPC;
    else version(X86) version = AppleOSIntel32;
    else version(X86_64) version = AppleOSIntel64;
    else version(ARM) version = AppleOSARM32;
    else version(AArch64) version = AppleOSARM64;
}

// Sets version tag for Intel devices.
version(X86)            version = ISA_X86;
else version(X86_64)    version = ISA_X86;

// Sets version tag for ARM devices.
version(ARM)            version = ISA_ARM;
else version(AArch64)   version = ISA_ARM;


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

/**
    Mixin template which instructs LDC and other compatible D compilers
    to link against the specified frameworks.
*/
mixin template LinkFramework(string... frameworks) {
    
    import apple.os;
    version(AppleOS) {
        static foreach(framework; frameworks) 
            pragma(linkerDirective, "-framework", framework);
    }
}

/**
    Ensure that if VersionSpec is declared as a version, that
    all the dependencies are also declared.
*/
mixin template RequireAPIs(VersionSpec, Required...) {
    version(VersionSpec) {
        static foreach(v; Required) {
            version = v;
        }
    }

    version(VersionSpec):
}