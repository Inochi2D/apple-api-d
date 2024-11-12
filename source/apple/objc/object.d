module apple.objc.object;
import apple.objc.rt;

/**
    Base class of all Objective-C classes.
*/
@ObjectiveC
class NSObject {
@nogc nothrow:
    static NSObject alloc() @selector("alloc");
}