/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    Helpers for Objective-C ABI details.
*/
module apple.objc.rt.abi;

// Declares the Objective-C ABI in use on the platform being compiled for.
version(X86)            version = OBJC_ABI_1;
else version(X86_64)    version = OBJC_ABI_1;
else version(ARM)       version = OBJC_ABI_2;
else version(AArch64)   version = OBJC_ABI_2;
else                    version = OBJC_ABI_NONE;

version(OBJC_ABI_1) enum OBJC_ABI = 1;
else version(OBJC_ABI_2) enum OBJC_ABI = 2;
else enum OBJC_ABI = -1;

enum objc_classVarName(string ClassName) = "OBJC_CLASS_$_"~ClassName;
enum objc_protoVarName(string ProtoName) = "OBJC_PROTOCOL_$_"~ProtoName;