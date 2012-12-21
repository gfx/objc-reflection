#import <Foundation/Foundation.h>

#import "reflection.h"

@interface A : NSObject
@end

@implementation A
+(void)load
{
    reflectClassDump(self);

    NSArray *classes = reflectClassGetSubclasses(self);
    for (Class klass in classes) {
        reflectClassDump(klass);
    }
}

-(void)methodOfA
{
}

@end

@interface B : A
@property (nonatomic) NSString *propertyOfB;
@end

@implementation B
@end

@interface C : A
@end

@implementation C {
    int ivarOfC;
}
@end

int main() {
    A *b = [[B alloc] init];
    A *c = [[C alloc] init];

    return b != c;
}

// vim: set expandtab:
