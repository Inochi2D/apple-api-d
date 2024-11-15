/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    Bindings to NSBundle
*/
module apple.foundation.nsbundle;
import apple.foundation;
import apple.os;

import apple.objc : ObjC;
mixin RequireAPIs!(ObjC);

import apple.objc;
import apple.objc : selector;

nothrow @nogc:

/**
    Constants that describe the CPU types that a bundle’s executable code supports.
*/
enum NSBundleExecutableArchitecture {
    
    /**
        The 32-bit Intel architecture.
    */
    I386      = 0x00000007,
    
    /**
        The 32-bit PowerPC architecture.
    */
    PPC       = 0x00000012,
    
    /**
        The 64-bit Intel architecture.
    */
    X86_64    = 0x01000007,
    
    /**
        The 64-bit PowerPC architecture.
    */
    PPC64     = 0x01000012,
    
    /**
        The 64-bit ARM architecture.
    */
    ARM64     = 0x0100000c
}

/**
    A representation of the code and resources stored in a bundle directory on disk. 
*/
@ObjectiveC
class NSBundle : NSObject {
private:
@nogc nothrow:
public:

    /**
        Returns the bundle object that contains the current executable.
    */
    @property static NSBundle mainBundle();

    /**
        Returns an array of all of the application’s bundles that represent frameworks.
    */
    @property static NSArray!NSBundle allFrameworks();

    /**
        Returns an array of all the application’s non-framework bundles.
    */
    @property static NSArray!NSBundle allBundles();

    /**
        Returns an NSBundle object that corresponds to the specified file URL.
    */
    @property static NSBundle fromURL(NSURL url) @selector("bundleWithURL:");

    /**
        Returns an NSBundle object that corresponds to the specified file URL.
    */
    @property static NSBundle fromPath(NSString url) @selector("bundleWithPath:");

    /**
        The load status of a bundle.
    */
    @property bool loaded() const;

    /**
        A dictionary, constructed from the bundle’s Info.plist file, that contains information about the receiver.
    */
    @property NSDictionary!(NSString, id) info() const @selector("infoDictionary");

    /**
        The full URL of the receiver’s bundle directory.
    */
    @property NSURL bundleURL() const;

    /**
        The file URL of the bundle’s subdirectory containing resource files.
    */
    @property NSURL resourceURL() const;

    /**
        The file URL of the receiver's executable file.
    */
    @property NSURL executableURL() const;

    /**
        The file URL of the bundle’s subdirectory containing private frameworks.
    */
    @property NSURL privateFrameworksURL() const;

    /**
        The file URL of the receiver's subdirectory containing shared frameworks.
    */
    @property NSURL sharedFrameworksURL() const;

    /**
        The file URL of the receiver's subdirectory containing plug-ins.
    */
    @property NSURL builtInPlugInsURL() const;

    /**
        The file URL of the bundle’s subdirectory containing shared support files.
    */
    @property NSURL sharedSupportURL() const;

    /**
        The file URL for the bundle’s App Store receipt.
    */
    @property NSURL appStoreReceiptURL() const;

    /**
        The full pathname of the receiver’s bundle directory.
    */
    @property NSString bundlePath() const;

    /**
        The full pathname of the bundle’s subdirectory containing resources.
    */
    @property NSString resourcePath() const;

    /**
        The full pathname of the receiver's executable file.
    */
    @property NSString executablePath() const;

    /**
        The full pathname of the bundle’s subdirectory containing private frameworks.
    */
    @property NSString privateFrameworksPath() const;

    /**
        The full pathname of the bundle’s subdirectory containing shared frameworks.
    */
    @property NSString sharedFrameworksPath() const;

    /**
        The full pathname of the bundle’s subdirectory containing shared support files.
    */
    @property NSString sharedSupportPath() const;

    /**
        The full pathname of the receiver's subdirectory containing plug-ins.
    */
    @property NSString builtInPlugInsPath() const;

    /**
        The receiver’s bundle identifier.
    */
    @property NSString bundleIdentifier() const;

    /**
        An array of numbers indicating the architecture types supported by the bundle’s executable.
    */
    @property NSArray!NSNumber executableArchitectures() const;

    /**
        Base constructor
    */
    this(id self) { super(self); }

    /**
        Dynamically loads the bundle’s executable code into a running program, 
        if the code has not already been loaded.
    */
    bool load() @selector("load");

    /**
        Unloads the code associated with the receiver. 
    */
    bool unload() @selector("unload");


    // Link NSBundle.
    mixin ObjcLink;
}