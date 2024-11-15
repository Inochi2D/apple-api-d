/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    Bindings to Apple's CoreGraphics API.
*/
module apple.coregraphics.cggeometry;
import apple.coregraphics;
import apple.corefoundation;
import apple.coredata;
import apple.objc;
import apple.os;

mixin RequireAPIs!(CoreGraphics, CoreFoundation);

/**
    The basic type for all floating-point values.
*/
alias CGFloat = double;

/**
    A structure that contains a point in a two-dimensional coordinate system.
*/
struct CGPoint {
    
    /**
        The x-coordinate of the point.
    */
    CGFloat x;
    
    /**
        The y-coordinate of the point.
    */
    CGFloat y;

    /**
        Returns whether two points are equal.
    */
    bool opEquals(CGPoint other) const {
        return 
            this.x == other.x && 
            this.y == other.y;
    }
}

/**
    A structure that contains a two-dimensional vector.
*/
struct CGVector {
    
    /**
        The x-coordinate of the point.
    */
    CGFloat dx;
    
    /**
        The y-coordinate of the point.
    */
    CGFloat dy;

    /**
        Returns whether two vectors are equal.
    */
    bool opEquals(CGVector other) const {
        return 
            this.dx == other.dx && 
            this.dy == other.dy;
    }
}

/**
    A structure that contains a point in a two-dimensional coordinate system.
*/
struct CGSize {
    
    /**
        A width value.
    */
    CGFloat width;
    
    /**
        A height value.
    */
    CGFloat height;

    /**
        Returns whether two sizes are equal.
    */
    bool opEquals(CGSize other) const {
        return 
            this.width == other.width && 
            this.height == other.height;
    }
}

/**
    A structure that contains the location and dimensions of a rectangle.
*/
struct CGRect {
    
    /**
        A point that specifies the coordinates of the rectangle’s origin.
    */
    CGPoint origin;
    
    /**
        A size that specifies the height and width of the rectangle.
    */
    CGSize size;
}