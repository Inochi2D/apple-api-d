/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    Helpers for Objective-C ABI details.
*/
module apple.objc.rt.abi;
import apple.objc.rt.base;

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

// pragma(msg, encode!(Class.alloc));

// /**
//     Encodes a function to an objective-c type encoding
// */
// template encode(alias func) {
//     import std.traits;
//     import std.meta;

//     enum encode = objc_tag!(ReturnType!func)~ApplyRight!(concat, staticMap!(objc_tag, Parameters!func)).stringof;
// }

// template concat(lhs, rhs) {
//     enum concat = lhs.stringof ~ rhs.stringof;
// }

// /**
//     Gets an objective-c tag from a type.
// */
// template objc_tag(T) {
//     import std.range.primitives;
//     import std.traits;
//     import std.format;
//     import std.meta;

//     static if (is(Unqual!T == char*))
//         enum objc_tag = _C_CHARPTR;
//     else static if (isPointer!T)
//         enum objc_tag = "^"~objc_tag!(PointerTarget!T);
//     else static if (isStaticArray!T)
//         enum objc_tag = "[%s%s]".format(T.length, objc_tag!(ElementType!T));
//     else static if (is(T == id))
//         enum objc_tag = _C_ID;
//     else static if (is(T == Class))
//         enum objc_tag = _C_CLASS;
//     else static if (is(T == SEL))
//         enum objc_tag = _C_SEL;
//     else static if (is(T == struct)) {
//         enum objc_tag = "{"~T.stringof~"="~staticMap!(objc_tag, Fields!T)~"}";
//     } else static if (is(T == union)) {
//         enum objc_tag = "("~T.stringof~"="~staticMap!(objc_tag, Fields!T)~")";
//     } else static if (is(T == char) || is(T == byte))
//         enum objc_tag = _C_CHR;
//     else static if (is(T == ubyte))
//         enum objc_tag = _C_UCHR;
//     else static if (is(T == short))
//         enum objc_tag = _C_SHT;
//     else static if (is(T == ushort))
//         enum objc_tag = _C_USHT;
//     else static if (is(T == int))
//         enum objc_tag = _C_INT;
//     else static if (is(T == uint))
//         enum objc_tag = _C_UINT;
//     else static if (is(T == long))
//         enum objc_tag = _C_LNG_LNG;
//     else static if (is(T == ulong))
//         enum objc_tag = _C_ULNG_LNG;
//     else static if (is(T == float))
//         enum objc_tag = _C_FLT;
//     else static if (is(T == double))
//         enum objc_tag = _C_DBL;
//     else static if (is(T == bool))
//         enum objc_tag = _C_BOOL;
//     else static if (is(T == void))
//         enum objc_tag = _C_VOID;
//     else 
//         enum objc_tag = _C_UNDEF;
// }

enum _C_ID = '@';
enum _C_CLASS = '#';
enum _C_SEL = ':';
enum _C_CHR = 'c';
enum _C_UCHR = 'C';
enum _C_SHT = 's';
enum _C_USHT = 'S';
enum _C_INT = 'i';
enum _C_UINT = 'I';
enum _C_LNG_LNG = 'q';
enum _C_ULNG_LNG = 'Q';
enum _C_FLT = 'f';
enum _C_DBL = 'd';
enum _C_BFLD = 'b';
enum _C_BOOL = 'B';
enum _C_VOID = 'v';
enum _C_UNDEF = '?';
enum _C_PTR = '^';
enum _C_CHARPTR = '*';
enum _C_ATOM = '%';
enum _C_ARY_B = '[';
enum _C_ARY_E = ']';
enum _C_UNION_B = '(';
enum _C_UNION_E = ')';
enum _C_STRUCT_B = '{';
enum _C_STRUCT_E = '}';
enum _C_CONST = 'r';