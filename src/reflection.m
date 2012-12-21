
#import "reflection.h"

#import <objc/runtime.h>

NSArray*
reflectClassGetSubclasses(Class klass) {
    int numClasses = objc_getClassList(NULL, 0);
    Class *classes = (__unsafe_unretained Class * )malloc(sizeof(Class) * numClasses);
    objc_getClassList(classes, numClasses);

    NSMutableArray *result = [NSMutableArray array];
    for (int i = 0; i < numClasses; i++) {
        Class k = classes[i];
        do {
            k = class_getSuperclass(k);
        } while(k && k != klass);

        if (k == nil) {
            continue;
        }

        [result addObject:classes[i]];
    }

    free(classes);

    return result;
}

void
reflectClassDump(Class klass) {
    uint count;

    Ivar* ivars = class_copyIvarList(klass, &count);
    NSMutableArray* ivarArray = [NSMutableArray arrayWithCapacity:count];
    for (uint i = 0; i < count ; i++)
    {
        const char* ivarName = ivar_getName(ivars[i]);
        [ivarArray addObject:[NSString  stringWithCString:ivarName encoding:NSUTF8StringEncoding]];
    }
    free(ivars);

    objc_property_t* properties = class_copyPropertyList(klass, &count);
    NSMutableArray* propertyArray = [NSMutableArray arrayWithCapacity:count];
    for (uint i = 0; i < count ; i++)
    {
        const char* propertyName = property_getName(properties[i]);
        [propertyArray addObject:[NSString  stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
    }
    free(properties);

    Method* methods = class_copyMethodList(klass, &count);
    NSMutableArray* methodArray = [NSMutableArray arrayWithCapacity:count];
    for (uint i = 0; i < count ; i++)
    {
        SEL selector = method_getName(methods[i]);
        const char* methodName = sel_getName(selector);
        [methodArray addObject:[NSString  stringWithCString:methodName encoding:NSUTF8StringEncoding]];
    }
    free(methods);

    NSDictionary* classDump = [NSDictionary dictionaryWithObjectsAndKeys:
                               ivarArray, @"ivars",
                               propertyArray, @"properties",
                               methodArray, @"methods",
                               nil];

    NSLog(@"%@", classDump);
}


