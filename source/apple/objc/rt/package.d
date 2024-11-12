/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    Interface to the Objective-C Runtime.
*/
module apple.objc.rt;

public import apple.objc.rt.abi;
public import apple.objc.rt.base;
public import apple.objc.rt.bind;

public import apple.objc.rt.bind : selector;
alias sel = selector;