module apple.foundation.nsstring;
import apple.objc.nsobject;
import apple.objc.rt;
import apple.objc.rt : selector;

/**
    NSString
*/
@ObjectiveC
class NSString : NSObject {
@nogc nothrow:
protected:

    /// Initialize NSString with characters.
    id initWithUTF8String(const(char)* str) @selector("initWithUTF8String:");

public:

    /**
        A null-terminated UTF8 representation of the string.
    */
    @property const(char)* UTF8String() const;

    /**
        The number of UTF-16 code units in the receiver.
    */
    @property NSUInteger length() const;

    /**
        Construct with UTF8 string.
    */
    this(const(char)* str) {
        super();
        this.self = this.initWithUTF8String(str);
    }

    /**
        Implements toString for NSString.
    */
    override
    string toString() => cast(string)this.UTF8String()[0..this.length()];

    // Link NSString.
    mixin ObjcLink;
}