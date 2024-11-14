/**
    Bindings to Apple's Mach API
*/
module apple.mach;
import apple.os;

static if (AppleOS):

public import apple.mach.ports;