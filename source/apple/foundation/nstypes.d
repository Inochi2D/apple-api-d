/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    Bindings to Apple's Foundation API.
*/
module apple.foundation.nstypes;
import apple.corefoundation;
import apple.foundation;
import apple.objc.nsobject;
import apple.objc.rt;
import apple.objc.rt : selector;
import apple.os;
import comp = std.algorithm.comparison;

mixin RequireAPIs!(Foundation);

/**
    A structure used to describe a portion of a series, such as characters in a string or objects in an array.
*/
struct NSRange {
nothrow @nogc:

    /**
        The index of the first member of the range.
    */
    NSUInteger location;

    /**
        The number of items in the range.
    */
    NSUInteger length;

    /**
        Returns the sum of the location and length of the range.
    */
    @property max() => location+length;

    /**
        Returns a Boolean value that indicates whether two given ranges are equal.
    */
    bool opEquals(const(NSRange) other) const {
        return this.location == other.location && this.length == other.length;
    }

    /**
        Returns a Boolean value that indicates whether a specified position is in a given range.
    */
    bool inRange(NSUInteger location) => this.location >= location && location < this.max();

    /**
        Returns the intersection of the specified ranges.

        Returns:  
            A range describing the intersection of range1 and range2—that is, 
            a range containing the indices that exist in both ranges.

        If the returned range’s length field is 0, then the two ranges don’t intersect, 
        and the value of the location field is undefined.
    */
    NSRange intersect(NSRange other) {
        NSUInteger loc = comp.max(this.location, other.location);
        return NSRange(
            location: loc,
            length: comp.min(this.max, other.max)-loc,
        );
    }

    /**
        Returns the union of the specified ranges.
    */
    NSRange unionize(NSRange other) {
        NSUInteger loc = comp.min(location, other.location);
        return NSRange(
            location: loc,
            length: comp.min(this.max, other.max)-loc
        );
    }
}

/**
    Type indicating a parameter is a pointer to an NSRange structure.
*/
alias NSRangePointer = NSRange*;

/**
    A value indicating that a requested item couldn’t be found or doesn’t exist.
*/
extern(C) extern const NSInteger NSNotFound; // @suppress(dscanner.style.phobos_naming_convention)