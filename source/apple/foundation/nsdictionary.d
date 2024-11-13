module apple.foundation.nsdictionary;
import apple.foundation;
import apple.objc.nsobject;
import apple.objc.rt;
import apple.objc.rt : selector;
import apple.os;

mixin RequireAPIs!(Foundation);

/**
    NSDictionary
*/
@ObjectiveC
class NSDictionary : NSObject {
@nogc nothrow:
private:

public:

    /**
        Base constructor
    */
    this(id self) { super(self); }

    // Link NSDictionary.
    mixin ObjcLink;
}