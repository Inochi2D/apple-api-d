module apple.objc.nsobject;
import apple.objc.rt;
import apple.objc.rt : selector;

@ObjectiveC
interface NSObjectProtocol {
@nogc nothrow:

    /**
        Returns the class object for the receiver’s class.
    */
    Class getClass(); // Implemented via ObjcLink

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
        Increments the receiver’s reference count.
    */
    void retain() @selector("retain");

    /**
        Decrements the receiver’s reference count.
    */
    void release() @selector("release");
}

/**
    Base class of all Objective-C classes.
*/
@ObjectiveC
abstract
class NSObject : NSObjectProtocol {
@nogc nothrow:
private:
    id self_;

protected:

    /**
        Sends a message (calls a function) based on the given selector.
    */
    T message(T, Args...)(const(char)* selector, Args args) {
        return sendMessage!(T, T function(Args...), Args)(this.self(), sel_registerName(selector), args);
    }

    /**
        Sends a message to super class (calls a function) based on the given selector.
    */
    T messageSuper(T, Args...)(const(char)* selector, Args args) {
        return sendMessageSuper!(T, T function(Args...), Args)(this.superclass(), sel_registerName(selector), args);
    }

    /**
        Sends a message (calls a function) based on the given selector.
        A class instance will need to be specified.
    */
    static T message(T, Args...)(Class target, const(char)* selector, Args args) {
        return sendMessage!(T, T function(Args...), Args)(cast(id)target, sel_registerName(selector), args);
    }

    /**
        Allows updating self value.
    */
    id self(id newValue) {
        this.self_ = newValue;
        return this.self_;
    }


    /**
        Base constructor of all NSObject-derived instances
    */
    this() {
        this.self_ = this.message!id(this.getClass(), "alloc");
    }

    /**
        Instantiates NSObject with a pre-existing object instance id.
    */
    this(id selfId) {
        this.self_ = selfId;
    }

public:

    /**
        Denstructor of all NSObject-derived instances
    */
    ~this() {
        objc_destructInstance(self_);
        object_dispose(self_);
    }

    /**
        Gets the underlying Objective-C reference.
    */
    final id self() => self_;
    
    // Link NSObject.
    mixin ObjcLink;
}

/**
    Gets a selector by its name.

    Returns null if the selector wasn't found.
*/
SEL getSelector(const(char)* selector) {
    return sel_getUid(selector);
}