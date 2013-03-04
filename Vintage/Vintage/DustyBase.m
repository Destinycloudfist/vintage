//
//  DustyBase.m
//  Vintage
//
//  Created by Dustin Dettmer on 3/3/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import "DustyBase.h"

NSString *DustyBaseNewIdNotification = @"DustyBaseNewIdNotification";

@interface DustyBase()

@property (nonatomic, strong) NSString *url;

@property (atomic, assign) int step;

@property (nonatomic, readwrite, strong) NSString *name;

@property (nonatomic, weak) DustyBase *parent;

@property (nonatomic, strong) NSMutableArray *children;

@property (nonatomic, strong) NSMutableArray *eventBlocks;

@end

@implementation DustyBase

- (void)setup:(NSString*)url
{
    self.url = url;
    self.step = [[NSUserDefaults standardUserDefaults] integerForKey:@"DustyBaseStep"];
    self.name = @"";
    self.children = [NSMutableArray array];
    self.eventBlocks = [NSMutableArray array];
}

- (id)initWithUrl:(NSString*)url
{
    self = [super init];
    
    if(self) {
        
        [self setup:url];
        
        [self performSelectorInBackground:@selector(longpoolForever) withObject:nil];
    }
    
    return self;
}

- (id)initWithUrl:(NSString*)url parent:(DustyBase*)parent
{
    self = [super init];
    
    if(self) {
        
        [self setup:url];
        
        self.parent = parent;
        [parent.children addObject:self];
    }
    
    return self;
}

- (void)sendEvents:(NSDictionary*)objects
{
    for(NSDictionary *object in objects) {
        
        if([self.name isEqualToString:[object objectForKey:@"key"]]) {
            
            NSData *data = [[object objectForKey:@"value"] dataUsingEncoding:NSUTF8StringEncoding];
            
            NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSString *key = [object objectForKey:@"key"];
            
            key = [key stringByReplacingOccurrencesOfString:@"/" withString:@"."];
            
            id value = [array objectAtIndex:0];
            
            for(void (^callback) (id key, id value) in self.eventBlocks) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    callback(key, value);
                });
            }
        }
    }
    
    for(DustyBase *child in self.children)
        [child sendEvents:objects];
}

- (void)longpoolForever
{
    while(1) @autoreleasepool {
        
        NSString *str = [NSString stringWithFormat:@"http://dustytech.com/dustybase?step=%d", self.step];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:str]];
        
        NSError *error = nil;
        
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
        
        NSDictionary *message = nil;
        
        if(data)
            message = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        if(!message)
            sleep(3);
        else {
            
            self.step = [[message objectForKey:@"step"] intValue];
            NSDictionary *objects = [message objectForKey:@"objects"];
            
            NSParameterAssert(self.step);
            
            [[NSUserDefaults standardUserDefaults] setInteger:self.step forKey:@"DustyBaseStep"];
            
            __weak DustyBase *weakSelf = self;
            
            for(NSDictionary *object in objects) {
                
                NSData *data = [[object objectForKey:@"value"] dataUsingEncoding:NSUTF8StringEncoding];
                
                NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                
                NSString *key = [object objectForKey:@"key"];
                
                key = [key stringByReplacingOccurrencesOfString:@"/" withString:@"."];
                
                id value = [array objectAtIndex:0];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:DustyBaseNewIdNotification object:@[key, value]];
                });
            }
            
            [weakSelf sendEvents:objects];
        }
    }
}

- (void)set:(id)value onComplete:(void (^)(NSError* error))callback
{
    if([value isKindOfClass:[NSDate class]])
        return;
    
    if(!value)
        value = [NSNull null];
    
    NSMutableString *str = [NSMutableString string];
    
    NSString *strName = [self.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:@[value] options:0 error:&error];
    
    NSParameterAssert(data);
    NSParameterAssert(!error);
    
    NSString *strValue = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    strValue = [strValue stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [str appendFormat:@"http://dustytech.com/dustybase?key=%@&value=%@", strName, strValue];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:str]];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            if(str.length != 1)
                callback(str.length ? (id)str : (id)error);
            else
                callback(error);
        });
    });
}

- (void)on:(DustyBaseEventType)eventType doCallback:(void (^) (id key, id value))callback
{
    [self.eventBlocks addObject:[callback copy]];
    
    NSString *query = [self.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *str = [NSString stringWithFormat:@"http://dustytech.com/dustybase?query=%@", query];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:str]];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSDictionary *message = nil;
            
            if(data)
                message = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            if(message) {
                
                NSDictionary *objects = [message objectForKey:@"objects"];
                
                [self sendEvents:objects];
            }
        });
    });
}

- (DustyBase*)child:(NSString*)name
{
    DustyBase *db = [[DustyBase alloc] initWithUrl:self.url parent:self];
    
    db.name = [self.name stringByAppendingFormat:@"%@", name];
    
    return db;
}

- (DustyBase*)push
{
    CFUUIDRef ref = CFUUIDCreate(NULL);
    
    CFStringRef strRef = CFUUIDCreateString(NULL, ref);
    
    CFRelease(ref);
    
    return [self child:CFBridgingRelease(strRef)];
}

@end
