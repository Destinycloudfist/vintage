//
//  Model.m
//  Vintage
//
//  Created by Dustin Dettmer on 3/2/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import "Model.h"
#import <objc/runtime.h>

@implementation Model

- (void)save
{
    unsigned int outCount, i;
    
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for(i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        if(propName) {
            NSLog(@"property: %s", propName);
        }
    }
    free(properties);
}

- (id)uniqueId
{
    NSAssert(NO, @"uniqueId not implemented on %@", [self class]);
    
    return nil;
}

+ (id<ModelProtocol>)loadModel:(Class)class withUniqueId:(id)uniqueId
{
    return nil;
}

+ (NSArray*)loadModels:(Class)class
{
    return nil;
}

@end
