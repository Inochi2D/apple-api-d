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

    // Link NSDictionary.
    mixin ObjcLink;
}