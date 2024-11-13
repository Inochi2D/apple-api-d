# Apple API Bindings for DLang

This library contains bindings for various APIs provided by Apple.
Additionally an Objective-C wrapper is provided to allow instantiation of Objective-C types.

# Memory managment
For C APIs, general C memory management rules apply, for Objective-C wrapper types the lifetime
of objects are tied to their Objective-C parent object.

# How to access the APIs

Each API is denoted with a version tag that needs to be present for the fuctionality to be present.
Some functionality requires multiple dependencies to be present, errors will be presented if version
tags are missing.