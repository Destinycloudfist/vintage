//
//  ModelBackend.m
//  Vintage
//
//  Created by Dustin Dettmer on 3/2/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import "ModelBackend.h"

@implementation ModelBackend

+ (ModelBackend*)shared
{
    static ModelBackend *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [ModelBackend new];
    });
    
    return instance;
}

- (NSArray*)keys
{
    return [[NSUserDefaults standardUserDefaults] arrayForKey:@"keys"];
}

- (void)setKeys:(NSArray *)keys
{
    [[NSUserDefaults standardUserDefaults] setObject:keys forKey:@"keys"];
}

- (id)objectForKey:(NSString*)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

- (void)setObject:(id)object forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:object forKey:key];
}

- (void)synchronize
{
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
