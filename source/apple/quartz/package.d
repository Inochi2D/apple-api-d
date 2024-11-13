/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    Binding to Apple's Quartz Frameworks.
*/
module apple.quartz;
import apple.os;

// Enum definition for version tags.
enum Quartz;

// Quarts has some basic implementation details as a whole.
mixin RequireAPIs!Quartz;


extern(C) extern __gshared const bool globalUpdateOK;
