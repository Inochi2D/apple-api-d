module apple.objc.object;
import apple.objc.rt;

@ObjectiveC
interface NSObjectProtocol {
@nogc nothrow:

    /**
        Returns the class object for the receiver’s class.
    */
    Class getClass() @selector("class");

    /**
        Returns the superclass for this object
    */
    @property Class superclass();

    /**
        Returns a Boolean value that indicates whether the receiver and a given object are equal.
    */
    bool isEqual(id obj) @selector("isEqual:");

    /**
        Returns an integer that can be used as a table address in a hash table structure.
    */
    @property NSUInteger hash();

    /**
        Returns the receiver.
    */
    id self() @selector("self");

    /**
        Increments the receiver’s reference count.
    */
    void retain() @selector("retain");

    /**
        Decrements the receiver’s reference count.
    */
    void release() @selector("release");

    // Link NSObjectProtocol as NSObject.
    mixin ObjcLink!("NSObject");
}

/**
    Base class of all Objective-C classes.
*/
@ObjectiveC
class NSObject : NSObjectProtocol {
@nogc nothrow:

    /**
        Returns a new instance of the receiving class.
    */
    static NSObject alloc() @selector("alloc");

    /**
        Allocates a new instance of the receiving class, sends it an init message, and returns the initialized object.
    */
    static NSObject new() @selector("new");

    /**
        Initializes the class before it receives its first message.
    */
    NSObject initialize() @selector("init");

    /**
        Initializes the class before it receives its first message.
    */
    NSObject dealloc() @selector("dealloc");
    
    // Link NSObject.
    mixin ObjcLink;
}

