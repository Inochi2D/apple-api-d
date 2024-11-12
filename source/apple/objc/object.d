module apple.objc.object;
import apple.objc.rt;

interface NSObjectProtocol {
@nogc nothrow:

    /**
        Returns
    */
    id self() @selector("self");

    /**
        Returns the class object for the receiver’s class.
    */
    Class getClass() @selector("class");

    /**
        Returns the superclass for this object
    */
    @property Class superclass();

    void retain() @selector("retain");
    void release() @selector("release");
    void autorelease() @selector("autorelease");
    

    // Link NSObject.
    mixin ObjcLink;
}

/**
    Base class of all Objective-C classes.
*/
@ObjectiveC
class NSObject {
@nogc nothrow:
    static NSObject alloc() @selector("alloc");
}

