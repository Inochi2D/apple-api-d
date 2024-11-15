/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    MTLLibrary
*/
module apple.metal.mtllibrary;
import apple.metal;
import apple.foundation;

import apple.os;
import apple.objc;
import apple.objc : selector;

mixin RequireAPIs!(Metal, Foundation);


/**
    Types of tessellation patches that can be inputs of 
    a post-tessellation vertex function.
*/
enum MTLPatchType : NSUInteger {
    
    /**
        An option that indicates that this isn’t a post-tessellation vertex function.
    */
    None = 0,
    
    /**
        A triangle patch.
    */
    Triangle = 1,
    
    /**
        A quad patch.
    */
    Quad = 2,
}

/**
    The type of a top-level Metal Shading Language (MSL) function.
*/
enum MTLFunctionType : NSUInteger {
    
    /**
        A vertex function you can use in a render pipeline state object.
    */
    Vertex = 1,
    
    /**
        A fragment function you can use in a render pipeline state object.
    */
    Fragment = 2,
    
    /**
        A kernel you can use in a compute pipeline state object.
    */
    Kernel = 3,
    
    /**
        A function you can use in a visible function table.
    */
    Visible = 5,
    
    /**
        A function you can use in an intersection function table.
    */
    Intersection = 6,
    
    /**
        A mesh function you can use in a render pipeline state object.
    */
    Mesh = 7,
    
    /**
        An object function you can use in a render pipeline state object.
    */
    Object = 8,
}

enum MTLLanguageVersion : NSUInteger {
    Version1_0 = 65_536,
    Version1_1 = 65_537,
    Version1_2 = 65_538,
    Version2_0 = 13_1072,
    Version2_1 = 13_1073,
    Version2_2 = 13_1074,
    Version2_3 = 13_1075,
    Version2_4 = 13_1076,
    Version3_0 = 19_6608,
    Version3_1 = 19_6609,
    Version3_2 = 19_6610,
}

enum MTLLibraryType : NSInteger {
    Executable = 0,
    Dynamic = 1,
}

enum MTLLibraryOptimizationLevel : NSInteger {
    Default = 0,
    LevelSize = 1,
}

enum MTLCompileSymbolVisibility : NSInteger {
    Default = 0,
    Hidden = 1,
}

enum MTLMathMode : NSInteger {
    Safe = 0,
    Relaxed = 1,
    Fast = 2,
}

enum MTLMathFloatingPointFunctions : NSInteger {
    Fast = 0,
    Precise = 1,
}

enum MTLLibraryError : NSUInteger {
    Unsupported = 1,
    Internal = 2,
    CompileFailure = 3,
    CompileWarning = 4,
    FunctionNotFound = 5,
    FileNotFound = 6,
}

/**
    An object that represents an attribute of a vertex function.
*/
@ObjectiveC
class MTLVertexAttribute : NSObject {
nothrow @nogc:
public:
    
    /**
        The name of the attribute.
    */
    @property NSString name() const;

    /**
        The index of the attribute, as declared in Metal shader source code.
    */
    @property NSUInteger index() const @selector("attributeIndex");

    /**
        The data type for the attribute, as declared in Metal shader source code.
    */
    @property MTLDataType type() const @selector("attributeType");

    /**
        A Boolean value that indicates whether this vertex attribute is active.
    */
    @property bool active() const @selector("isActive");

    /**
        A Boolean value that indicates whether this vertex 
        attribute represents control point data.
    */
    @property bool isPatchControlPointData() const;

    /**
        A Boolean value that indicates whether this vertex 
        attribute represents patch data.
    */
    @property bool isPatchData() const;

    /**
        Base constructor
    */
    this(id self) { super(self); }

    // Link MTLVertexAttribute.
    mixin ObjcLink;
}

/**
    An object that describes an attribute defined in 
    the stage-in argument for a shader.
*/
@ObjectiveC
class MTLAttribute : NSObject {
nothrow @nogc:
public:
    
    /**
        The name of the attribute.
    */
    @property NSString name() const;

    /**
        The index of the attribute, as declared in Metal shader source code.
    */
    @property NSUInteger index() const @selector("attributeIndex");

    /**
        The data type for the attribute, as declared in Metal shader source code.
    */
    @property MTLDataType type() const @selector("attributeType");

    /**
        A Boolean value that indicates whether this vertex attribute is active.
    */
    @property bool active() const @selector("isActive");

    /**
        A Boolean value that indicates whether this vertex 
        attribute represents control point data.
    */
    @property bool isPatchControlPointData() const;

    /**
        A Boolean value that indicates whether this vertex 
        attribute represents patch data.
    */
    @property bool isPatchData() const;

    /**
        Base constructor
    */
    this(id self) { super(self); }

    // Link MTLAttribute.
    mixin ObjcLink;
}

/**
    A constant that specializes the behavior of a shader.
*/
@ObjectiveC
class MTLFunctionConstant : NSObject {
nothrow @nogc:
public:
    
    /**
        The name of the function constant.
    */
    @property NSString name() const;

    /**
        The data type of the function constant.
    */
    @property MTLDataType type() const;

    /**
        The index of the function constant.
    */
    @property NSUInteger index() const;

    /**
        A Boolean value indicating whether the function constant 
        must be provided to specialize the function.
    */
    @property bool required() const;

    /**
        Base constructor
    */
    this(id self) { super(self); }

    // Link MTLFunctionConstant.
    mixin ObjcLink;
}

/**
    An object that represents a public shader function in a Metal library.
*/
@ObjectiveC
class MTLFunction : NSObject {
nothrow @nogc:
public:
    
    /**
        A string that identifies the shader function.
    */
    @property NSString label();
    @property void label(NSString);

    /**
        The device object that created the shader function.
    */
    @property MTLDevice device() const;
    
    /**
        The function’s name.
    */
    @property NSString name() const;

    /**
        The shader function’s type.
    */
    @property MTLFunctionType functionType() const;

    /**
        The tessellation patch type of a post-tessellation vertex function.
    */
    @property MTLPatchType patchType() const;

    /**
        The number of patch control points in the post-tessellation vertex function.
    */
    @property NSInteger patchControlPointCount() const;

    /**
        An array that describes the vertex input attributes to a vertex function.
    */
    @property NSArrayT!MTLVertexAttribute vertexAttributes() const;

    /**
        An array that describes the input attributes to the function. 
    */
    @property NSArrayT!MTLAttribute stageInputAttributes() const;

    /**
        A dictionary of function constants for a specialized function. 
    */
    @property NSDictionary functionConstantsDictionary() const;

    /**
        The options that Metal used to compile this function.
    */
    // @property MTLFunctionOptions options() const;

    /**
        Base constructor
    */
    this(id self) { super(self); }

    // Link MTLFunction.
    mixin ObjcLink;
}

/**
    Compilation settings for a Metal shader library.
*/
@ObjectiveC
class MTLCompileOptions : NSObject {
nothrow @nogc:
public:

    /**
        A list of preprocessor macros to apply when compiling the library source.
    */
    @property NSDictionary preprocessorMacros() const;
    @property void preprocessorMacros(NSDictionary preprocessorMacros);

    /**
        An indication of whether the compiler can perform optimizations for 
        floating-point arithmetic that may violate the IEEE 754 standard.
    */
    @property MTLMathMode mathMode() const;
    @property void mathMode(MTLMathMode mathMode);

    /**
        The FP32 math functions Metal uses.
    */
    @property MTLMathFloatingPointFunctions mathFloatingPointFunctions() const;
    @property void mathFloatingPointFunctions(MTLMathFloatingPointFunctions mathFloatingPointFunctions);

    /**
        The language version for interpreting the library source code.
    */
    @property MTLLanguageVersion languageVersion() const;
    @property void languageVersion(MTLLanguageVersion languageVersion);

    /**
        The kind of library to create.
    */
    @property MTLLibraryType libraryType() const;
    @property void libraryType(MTLLibraryType libraryType);

    /**
        For a dynamic library, the name to use when installing the library.
    */
    @property NSString installName() const;
    @property void installName(NSString installName);

    /**
        An array of dynamic libraries the Metal compiler links against.
    */
    @property NSArray libraries() const;
    @property void libraries(NSArray libraries);

    /**
        A Boolean value that indicates whether the compiler compiles vertex shaders 
        conservatively to generate consistent position calculations.
    */
    @property bool preserveInvariance() const;
    @property void preserveInvariance(bool preserveInvariance);

    /**
        An option that tells the compiler what to prioritize when it compiles 
        Metal shader code.
    */
    @property MTLLibraryOptimizationLevel optimizationLevel() const;
    @property void optimizationLevel(MTLLibraryOptimizationLevel optimizationLevel);

    /**
        Symbol visibility.
    */
    @property MTLCompileSymbolVisibility compileSymbolVisibility() const;
    @property void compileSymbolVisibility(MTLCompileSymbolVisibility compileSymbolVisibility);

    /**
        A Boolean that indeicates whether shaders are allowed to reference 
        undefined symbols.
    */
    @property bool allowReferencingUndefinedSymbols() const;
    @property void allowReferencingUndefinedSymbols(bool allowReferencingUndefinedSymbols);

    /**
        An option that tells the compiler the maximum amount of threads
        that may be assigned to a thread group.
    */
    @property NSUInteger maxTotalThreadsPerThreadgroup() const;
    @property void maxTotalThreadsPerThreadgroup(NSUInteger maxTotalThreadsPerThreadgroup);

    /**
        A Boolean value that enables shader logging.
    */
    @property bool enableLogging() const;
    @property void enableLogging(bool enableLogging);

    /**
        Base constructor
    */
    this(id self) { super(self); }

    // Link MTLCompileOptions.
    mixin ObjcLink;
}

/**
    A collection of Metal shader functions.
*/
@ObjectiveC @ObjcProtocol
class MTLLibrary : NSObject {
nothrow @nogc:
public:
    
    /**
        A string that identifies the library.
    */
    @property NSString label();
    @property void label(NSString);

    /**
        The Metal device object that created the library.
    */
    @property MTLDevice device() const;
    
    /**
        The installation name for a dynamic library.
    */
    @property NSString installName() const;
    
    /**
        The library’s basic type.
    */
    @property MTLLibraryType type() const;

    /**
        The names of all public functions in the library.
    */
    @property NSArrayT!NSString functionNames() const;

    /**
        Base constructor
    */
    this(id self) { super(self); }

    /**
        Creates an object that represents a shader function in the library.
    */
    MTLFunction newFunction(NSString name) @selector("newFunctionWithName:");

    // Link MTLLibrary.
    mixin ObjcLink;
}