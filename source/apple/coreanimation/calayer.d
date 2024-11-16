/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    Bindings to Apple's Core Animation API.
*/
module apple.coreanimation.calayer;
import apple.coreanimation;
import apple.corefoundation;
import apple.coregraphics;
import apple.foundation;

import apple.os;
import apple.objc;
import apple.objc : selector;

mixin RequireAPIs!(CoreAnimation, CoreFoundation, CoreGraphics, Foundation);

/**
    UDA to specify that a Core Animation attribute can be
    animated.

    Mainly there for convenience.
*/
enum CAAnimatable;

/**
    Bitflags for which corners are masked.
*/
enum CACornerMask : NSUInteger {
    MinXMinYCorner = (1U << 0),
    MaxXMinYCorner = (1U << 1),
    MinXMaxYCorner = (1U << 2),
    MaxXMaxYCorner = (1U << 3),

    topLeft = MinXMinYCorner,
    topRight = MaxXMinYCorner,
    bottomLeft = MinXMaxYCorner,
    bottomRight = MaxXMaxYCorner,
}

/**
    An object that manages image-based content and allows you to 
    perform animations on that content.
*/
@ObjectiveC
class CALayer : NSObject, NSSecureCoding {
nothrow @nogc:
public:
    
    /**
        The name of the receiver.
    */
    @property NSString name();
    @property void name(NSString);

    /**
        An object that provides the contents of the layer.
    */
    @property id contents() @CAAnimatable;
    @property void contents(id) @CAAnimatable;

    /**
        The rectangle, in the unit coordinate space, that defines the portion of 
        the layer’s contents that should be used.
    */
    @property CGRect contentsRect() @CAAnimatable;
    @property void contentsRect(CGRect) @CAAnimatable;

    /**
        The rectangle that defines how the layer contents are 
        scaled if the layer’s contents are resized.
    */
    @property CGRect contentsCenter() @CAAnimatable;
    @property void contentsCenter(CGRect) @CAAnimatable;

    /**
        The opacity of the receiver.
    */
    @property float opacity() @CAAnimatable;
    @property void opacity(float) @CAAnimatable;

    /**
        A Boolean indicating whether the layer is displayed.
    */
    @property bool hidden() @selector("isHidden") @CAAnimatable;
    @property void hidden(bool) @CAAnimatable;

    /**
        A Boolean indicating whether sublayers are clipped to the layer’s bounds.
    */
    @property bool masksToBounds() @CAAnimatable;
    @property void masksToBounds(bool) @CAAnimatable;

    /**
        An optional layer whose alpha channel is used 
        to mask the layer’s content. 
    */
    @property CALayer mask();
    @property void mask(CALayer);

    /**
        A Boolean indicating whether the layer displays 
        its content when facing away from the viewer.
    */
    @property bool doubleSided() @selector("isDoubleSided") @CAAnimatable;
    @property void doubleSided(bool) @CAAnimatable;

    /**
        The radius to use when drawing rounded corners 
        for the layer’s background.
    */
    @property CGFloat cornerRadius() @CAAnimatable;
    @property void cornerRadius(CGFloat) @CAAnimatable;

    /**
        Which corners are masked.

        Otherwise undocumented by apple.
    */
    @property CACornerMask maskedCorners();
    @property void maskedCorners(CACornerMask);

    /**
        The width of the layer’s border. 
    */
    @property CGFloat borderWidth() @CAAnimatable;
    @property void borderWidth(CGFloat) @CAAnimatable;

    /**
        The opacity of the layer’s shadow.
    */
    @property float shadowOpacity() @CAAnimatable;
    @property void shadowOpacity(float) @CAAnimatable;

    /**
        The blur radius (in points) used to render 
        the layer’s shadow.
    */
    @property CGFloat shadowRadius() @CAAnimatable;
    @property void shadowRadius(CGFloat) @CAAnimatable;

    /**
        The offset (in points) of the layer’s shadow.
    */
    @property CGSize shadowOffset() @CAAnimatable;
    @property void shadowRadius(CGSize) @CAAnimatable;

    /**
        A Boolean indicating whether the layer is allowed 
        to perform edge antialiasing.
    */
    @property bool allowsEdgeAntialiasing();
    @property void allowsEdgeAntialiasing(bool);

    /**
        A Boolean indicating whether the layer is allowed 
        to perform edge antialiasing.
    */
    @property bool allowsGroupOpacity();
    @property void allowsGroupOpacity(bool);
    
    /**
        Base constructor
    */
    this(id self) { super(self); }

    /**
        Reloads the content of this layer.
    */
    void display() @selector("display");

    // Link
    mixin ObjcLink;
}