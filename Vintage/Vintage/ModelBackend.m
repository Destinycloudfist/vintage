//
//  ModelBackend.m
//  Vintage
//
//  Created by Dustin Dettmer on 3/2/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import "ModelBackend.h"
#import "Firebase.h"

NSString *ModelBackendKeysUpdated = @"ModelBackendKeysUpdated";
NSString *ModelBackendObjectsUpdated = @"ModelBackendObjectsUpdated";

@interface ModelBackend()

@property (nonatomic, strong) Firebase *firebase;

@end

@implementation ModelBackend
@synthesize firebase;

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
    return [NSString stringWithFormat:@"object/%@",
            [key stringByReplacingOccurrencesOfString:@"." withString:@"/"]];
}

- (void)monitorKey:(NSString*)key
{
    __weak ModelBackend *weakSelf = self;
    
    Firebase *fb = [weakSelf.firebase child:[self pathForKey:key]];
    
    [fb on:FEventTypeValue doCallback:^(FDataSnapshot *snapshot) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(![[snapshot val] isEqual:[NSNull null]]) {
                
                [weakSelf setObjectInLocalCache:[snapshot val] forKey:key];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:ModelBackendKeysUpdated object:@[key]];
            }
        });
    }];
}

- (id)init
{
    self = [super init];
    
    self.firebase = [[Firebase alloc] initWithUrl:@"https://vikrum.firebaseio.com/"];
    
    Firebase *fb = [self.firebase child:@"keys"];
    
    // Spawn initial key change monitor
    self.keys = self.keys;
    
    __weak ModelBackend *weakSelf = self;
    
    [fb on:FEventTypeValue doCallback:^(FDataSnapshot *snapshot) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(![[snapshot val] isEqual:[NSNull null]]) {
                
                NSArray *newKeys = [weakSelf _setKeys:[snapshot val]];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:ModelBackendKeysUpdated object:newKeys];
            }
        });
    }];
    
    return self;
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
    
    if(newKeys.count) {
        
        [[NSUserDefaults standardUserDefaults] setObject:keys forKey:@"firebase_keys"];
        
        Firebase *fb = [self.firebase child:@"keys"];
        
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
    
    return newKeys;
}

- (void)setKeys:(NSArray*)keys
{
    [self _setKeys:keys];
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
    Firebase *fb = [self.firebase child:[self pathForKey:key]];
    
    [fb set:[object description] onComplete:^(NSError *error) {
        
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
