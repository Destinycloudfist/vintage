//
//  ModelBackend.m
//  Vintage
//
//  Created by Dustin Dettmer on 3/2/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import "ModelBackend.h"
#import "DustyBase.h"

NSString *ModelBackendKeysUpdated = @"ModelBackendKeysUpdated";
NSString *ModelBackendObjectsUpdated = @"ModelBackendObjectsUpdated";

@interface ModelBackend()

@property (nonatomic, strong) DustyBase *dustybase;

@end

@implementation ModelBackend
@synthesize dustybase;

+ (ModelBackend*)shared
{
    static ModelBackend *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [ModelBackend new];
    });
    
    return instance;
}

- (NSString*)pathForKey:(NSString*)key
{
    return [key stringByReplacingOccurrencesOfString:@"." withString:@"/"];
}

- (void)monitorKey:(NSString*)key
{
    __weak ModelBackend *weakSelf = self;
    
    DustyBase *fb = [weakSelf.dustybase child:[self pathForKey:key]];
    
    [fb on:DustyBaseEventTypeValue doCallback:^(id key, id value) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(value && ![value isEqual:[NSNull null]]) {
                
                [weakSelf setObjectInLocalCache:value forKey:key];
                
                NSLog(@"Firing ModelBackendKeysUpdated %@", @[key]);
                
                [[NSNotificationCenter defaultCenter] postNotificationName:ModelBackendKeysUpdated object:@[key]];
            }
        });
    }];
}

- (id)init
{
    self = [super init];
    
    self.dustybase = [[DustyBase alloc] initWithUrl:@"http://dustytech.com/dustybase"];
    
    DustyBase *fb = [self.dustybase child:@"keys"];
    
    // Spawn initial key change monitor
    self.keys = self.keys;
    
    __weak ModelBackend *weakSelf = self;
    
    [fb on:DustyBaseEventTypeValue doCallback:^(id key, id value) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(value && ![value isEqual:[NSNull null]]) {
                
                NSArray *newKeys = [weakSelf _setKeys:value];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:ModelBackendKeysUpdated object:newKeys];
            }
        });
    }];
    
    return self;
}

- (NSString*)generateUniqueId
{
    return [[self.dustybase push] name];
}

- (NSArray*)keys
{
    return [[NSUserDefaults standardUserDefaults] arrayForKey:@"firebase_keys"];
}

- (NSArray*)_setKeys:(NSArray*)keys
{
    NSMutableArray *newKeys = [@[] mutableCopy];
    NSArray *ourKeys = self.keys;
    
    if(![ourKeys isEqualToArray:keys]) {
        for(NSString *key in keys) {
            if(![ourKeys containsObject:key]) {
                
                [newKeys addObject:key];
                
                [self monitorKey:key];
            }
        }
    }
    
    if(newKeys.count)
        [[NSUserDefaults standardUserDefaults] setObject:keys forKey:@"firebase_keys"];
    
    return newKeys;
}

- (void)setKeys:(NSArray*)keys
{
    if([self _setKeys:keys].count) {
        
        DustyBase *fb = [self.dustybase child:@"keys"];
        
        [fb set:keys onComplete:^(NSError *error) {
            
            if(error)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    UIAlertView *alert = [[UIAlertView alloc]
                                          initWithTitle:@"Trouble"
                                          message:error.localizedDescription
                                          delegate:nil
                                          cancelButtonTitle:@"Okay"
                                          otherButtonTitles:nil];
                    
                    [alert show];
                });
            }
        }];
    }
}

- (id)objectForKey:(NSString*)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:[@"firebase_" stringByAppendingString:key]];
}

- (void)setObjectInLocalCache:(id)object forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:object forKey:[@"firebase_" stringByAppendingString:key]];
}

- (void)setObject:(id)object forKey:(NSString *)key
{
    DustyBase *fb = [self.dustybase child:[self pathForKey:key]];
    
    [fb set:object onComplete:^(NSError *error) {
        
        if(error)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"Trouble"
                                      message:error.localizedDescription
                                      delegate:nil
                                      cancelButtonTitle:@"Okay"
                                      otherButtonTitles:nil];
                
                [alert show];
            });
        }
    }];
    
    [self setObjectInLocalCache:object forKey:key];
}

- (void)synchronize
{
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
