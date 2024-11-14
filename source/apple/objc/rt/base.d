/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    Interface to the Objective-C Runtime.
*/
module apple.objc.rt.base;
import apple.objc.rt.abi;
import apple.os;

import apple.objc : ObjC;
mixin RequireAPIs!(ObjC);

/**
    Specifies the superclass of an instance.

    It specifies the class definition of the particular superclass that should be messaged.
*/
struct objc_super {
    
    /**
        Specifies an instance of a class.
    */
    id reciever;
    
    /**
        Specifies the particular superclass of the instance to message.
    */
    Class superClass;
}

struct objc_method_description {

    /**
        The name of the method at runtime. 
    */
    SEL name;

    /**
        The types of the method arguments.
    */
    char* types;
}

struct objc_property_attribute_t {
    
    /**
        The name of the attribute.
    */
    const(char)* name;
    
    /**
        The value of the attribute (usually empty).
    */
    const(char)* value;
}

/**
    Type to specify the behavior of an association.
*/
enum objc_AssociationPolicy : size_t {
    OBJC_ASSOCIATION_ASSIGN             = 0,
    OBJC_ASSOCIATION_COPY               = 1403,
    OBJC_ASSOCIATION_COPY_NONATOMIC     = 3,
    OBJC_ASSOCIATION_RETAIN             = 1401,
    OBJC_ASSOCIATION_RETAIN_NONATOMIC   = 1
}

//
//      Opaque Types
//

/// Base type of opaque Class handle.
struct objc_class;
struct objc_method;
struct objc_category;
struct objc_ivar;
struct objc_selector;
struct objc_object;
struct objc_property;
struct objc_protocol;

/**
    Objective-C Class type.
*/
alias Class = objc_class*;

/**
    Objective-C Method type.
*/
alias Method = objc_method*;

/**
    Objective-C Instance variable type.
*/
alias Ivar = objc_category*;

/**
    Objective-C Category type.
*/
alias Category = objc_category*;

/**
    A pointer to an instance of a class.
*/
alias id = objc_object*;

/**
    An opaque type that represents an Objective-C declared property.
*/
alias objc_property_t = objc_property*;

/**
    Objective-C Selector type.
*/
alias SEL = objc_selector*;

/**
    A pointer to the start of a method implementation.
*/
alias IMP = extern(C) id function(id, SEL, ...) @nogc nothrow;

/**
    Objective-C Protocol type.
*/
alias Protocol = objc_protocol*;


static if (OBJC_ABI >= 0):
extern(C) @nogc nothrow:


//
//      Classes
//

/**
    Returns the name of a class.
*/
extern const(char)* class_getName(Class cls);

/**
    Returns the superclass of a class.
*/
extern Class class_getSuperclass(Class cls);

/**
    Returns a Boolean value that indicates whether a class object is a metaclass.
*/
extern bool class_isMetaClass(Class cls);

/**
    Returns the size of instances of a class.
*/
extern size_t class_getInstanceSize(Class cls);

/**
    Returns the Ivar for a specified instance variable of a given class.
*/
extern Ivar class_getInstanceVariable(Class cls, const(char)* name);

/**
    Returns the Ivar for a specified class variable of a given class.
*/
extern Ivar class_getClassVariable(Class cls, const(char)* name);

/**
    Describes the instance variables declared by a class.
*/
extern Ivar* class_addIvar(Class cls, const(char)* name, int size, ubyte alignment, const(char)* types);

/**
    Describes the instance variables declared by a class.
*/
extern Ivar* class_copyIvarList(Class cls, uint* outCount);

/**
    Returns a description of the Ivar layout for a given class. 
*/
extern const(ubyte)* class_getIvarLayout(Class cls);

/**
    Sets the Ivar layout for a given class..
*/
extern void class_setIvarLayout(Class cls, const(ubyte)* layout);

/**
    Returns a description of the layout of weak Ivars for a given class. 
*/
extern const(ubyte)* class_getWeakIvarLayout(Class cls);

/**
    Sets the layout for weak Ivars for a given class.
*/
extern void class_setWeakIvarLayout(Class cls, const(ubyte)* layout);

/**
    Returns a property with a given name of a given class.
*/
extern objc_property_t class_getProperty(Class cls, const(char)* name);

/**
    Describes the properties declared by a class.
*/
extern objc_property_t* class_copyPropertyList(Class cls, uint* outCount);

/**
    Adds a new method to a class with a given name and implementation.
*/
extern bool class_addMethod(Class cls, SEL name, IMP imp, const(char)* types);

/**
    Returns a specified instance method for a given class.
*/
extern Method class_getInstanceMethod(Class cls, SEL name);

/**
    Returns a pointer to the data structure describing a given class method for a given class.
*/
extern Method class_getClassMethod(Class cls, SEL name);

/**
    Describes the instance methods implemented by a class.
*/
extern Method* class_copyMethodList(Class cls, uint* outCount);

/**
    Replaces the implementation of a method for a given class.
*/
extern IMP class_replaceMethod(Class cls, SEL name, IMP imp, const(char)* types);

/**
    Returns the function pointer that would be called if a particular message were sent to an instance of a class.
*/
extern IMP class_getMethodImplementation(Class cls, SEL name);

/**
    Returns a Boolean value that indicates whether instances of a class respond to a particular selector.
*/
extern bool class_respondsToSelector(Class cls, SEL sel);

/**
    Adds a protocol to a class.
*/
extern bool class_addProtocol(Class cls, Protocol* protocol);

/**
    Adds a property to a class.
*/
extern bool class_addProperty(Class cls, const(char)* name, const(objc_property_attribute_t)* attributes, uint attributeCount);

/**
    Replace a property of a class.
*/
extern void class_replaceProperty(Class cls, const(char)* name, const(objc_property_attribute_t)* attributes, uint attributeCount);

/**
    Returns a Boolean value that indicates whether a class conforms to a given protocol.
*/
extern bool class_conformsToProtocol(Class cls, Protocol* protocol);

/**
    Describes the protocols adopted by a class.
*/
extern Protocol* class_copyProtocolList(Class cls, uint *outCount);

/**
    Returns the version number of a class definition.
*/
extern int class_getVersion(Class cls);

/**

*/
extern void class_setVersion(Class cls, int version_);

/**
    Used by CoreFoundation's toll-free bridging.
*/
extern Class objc_getFutureClass(const(char)* name);

/**
    Used by CoreFoundation's toll-free bridging.
*/
extern void objc_setFutureClass(Class cls, const(char)* name);

/**
    Creates a new class and metaclass.
*/
extern Class objc_allocateClassPair(Class superclass, const(char)*name, size_t extraBytes);

/**
    Destroys a class and its associated metaclass.
*/
extern void objc_disposeClassPair(Class cls);

/**
    Registers a class that was allocated using objc_allocateClassPair.
*/
extern void objc_registerClassPair(Class cls);

/**
    Used by Foundation's Key-Value Observing.
*/
extern Class objc_duplicateClass(Class original, const(char)*name, size_t extraBytes);



//
//      Instances
//

/**
    Creates an instance of a class, allocating memory for the class in the default malloc memory zone.
*/
extern id class_createInstance(Class cls, size_t extraBytes);

/**
    Creates an instance of a class at the specified location.
*/
extern id objc_constructInstance(Class cls, void* bytes);

/**
    Destroys an instance of a class without freeing memory and removes any of its associated references.
*/
extern void* objc_destructInstance(id obj);

/**
    Returns a copy of a given object. 
*/
extern id object_copy(id obj, size_t size);

/**
    Frees the memory occupied by a given object. 
*/
extern id object_dispose(id obj);

/**
    Changes the value of an instance variable of a class instance.
*/
extern Ivar object_setInstanceVariable(id obj, const(char)* name, void* value);

/**

*/
extern Ivar object_getInstanceVariable(id obj, const(char)* name, void** outValue);

/**
    Returns a pointer to any extra bytes allocated with a instance given object.
*/
extern void* object_getIndexedIvars(id obj);

/**
    Reads the value of an instance variable in an object.
*/
extern id object_getIvar(id obj, Ivar ivar);

/**
    Sets the value of an instance variable in an object.
*/
extern void object_setIvar(id obj, Ivar ivar, id value);

/**
    Returns the class name of a given object.
*/
extern const(char)* object_getClassName(id obj);

/**
    Returns the class of an object. 
*/
extern Class object_getClass(id obj);

/**
    Sets the class of an object.
*/
extern Class object_setClass(id obj, Class cls);

//
//      Class Definitions
//

/**
    Obtains the list of registered class definitions.
*/
extern int objc_getClassList(Class* buffer, int bufferCount);

/**
    Creates and returns a list of pointers to all registered class definitions.
*/
extern Class* objc_copyClassList(uint* outCount);

/**
    Returns the class definition of a specified class.
*/
extern Class objc_lookUpClass(const(char)* name);

/**
    Returns the class definition of a specified class.
*/
extern id objc_getClass(const(char)* name);

/**

*/
extern Class objc_getRequiredClass(const(char)* name);

/**
    Returns the metaclass definition of a specified class.
*/
extern id objc_getMetaClass(const(char)* name);

//
//      Instance Variables
//

/**
    Returns the name of an instance variable.
*/
extern const(char)* ivar_getName(Ivar v);

/**
    Returns the type string of an instance variable.
*/
extern const(char)* ivar_getTypeEncoding(Ivar v);

/**
    Returns the offset of an instance variable.
*/
extern ptrdiff_t ivar_getOffset(Ivar v);

//
//      Associative References
//

/**
    Sets an associated value for a given object using a given key and association policy. 
*/
extern void objc_setAssociatedObject(id object, const(void)* key, id value, objc_AssociationPolicy policy);

/**
    Returns the value associated with a given object for a given key. 
*/
extern id objc_getAssociatedObject(id object, const(void)* key);

/**
    Removes all associations for a given object.
*/
extern void objc_removeAssociatedObjects(id object);

//
//      Messages
//

/**
    Sends a message with a simple return value to an instance of a class.
*/
extern void objc_msgSend(id instance, SEL, ...);

static if (OBJC_ABI == 1) {
    
    /**
        Sends a message with a struct return value to an instance of a class.
    */
    extern void objc_msgSend_stret(void* returnObject, id instance, SEL, ...);

    /**
        Sends a message with a float return value to an instance of a class.
    */
    extern void objc_msgSend_fpret(id instance, SEL, ...);
}

/**
    Sends a message with a simple return value to the superclass of an instance of a class.
*/
extern void objc_msgSendSuper(objc_super* super_, SEL, ...);

static if (OBJC_ABI == 1) {

    /**
        Sends a message with a data-structure return value to the superclass of an instance of a class.
    */
    extern void objc_msgSendSuper_stret(objc_super* super_, SEL, ...);

}

//
//      Selectors
//

/**
    Gets the name of a selector.
*/
extern const(char)* sel_getName(SEL sel);

/**
    Registers a method with the Objective-C runtime system, maps the method name to a selector, and returns the selector value.
*/
extern SEL sel_registerName(const(char)*);

/**
    Registers a method name with the Objective-C runtime system.
*/
extern SEL sel_getUid(const(char)*);

/**
    Returns a Boolean value that indicates whether two selectors are equal.
*/
extern bool sel_isEqual(SEL lhs, SEL rhs);

//
//      Implementation
//

/**
    Creates a pointer to a function that calls the specified block when the method is called.
*/
IMP imp_implementationWithBlock(id block);