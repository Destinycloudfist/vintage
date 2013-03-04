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
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(objectReceived:)
     name:DustyBaseNewIdNotification
     object:nil];
    
    self.dustybase = [[DustyBase alloc] initWithUrl:@"http://dustytech.com/dustybase"];
    
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

- (void)setKeys:(NSArray*)keys
{
    [[NSUserDefaults standardUserDefaults] setObject:keys forKey:@"firebase_keys"];
}

- (id)objectForKey:(NSString*)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:[@"firebase_" stringByAppendingString:key]];
}

- (void)setObjectInLocalCache:(id)object forKey:(NSString *)key
{
    NSArray *array = self.keys;
    
    if(!array)
        array = @[];
    
    if(![array containsObject:key])
        self.keys = [array arrayByAddingObject:key];
    
    [[NSUserDefaults standardUserDefaults] setObject:object forKey:[@"firebase_" stringByAppendingString:key]];
}

- (void)objectReceived:(NSNotification*)note
{
    NSArray *array = note.object;
    
    [self setObjectInLocalCache:[array objectAtIndex:1] forKey:[array objectAtIndex:0]];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ModelBackendKeysUpdated object:nil];
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
