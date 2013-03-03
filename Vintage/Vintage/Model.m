//
//  Model.m
//  Vintage
//
//  Created by Dustin Dettmer on 3/2/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import "Model.h"
#import "ModelBackend.h"
#import <objc/runtime.h>

#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

@interface PropertyInfo : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) SEL getter;
@property (nonatomic, assign) SEL setter;

@end

@implementation PropertyInfo

- (NSString*)description
{
    return [NSString stringWithFormat:@"%@ %s %s",
            self.name, sel_getName(self.getter), sel_getName(self.setter)];
}

@end

@implementation Model

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)init
{
    self = [super init];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(objectUpdated:)
     name:ModelBackendObjectsUpdated
     object:nil];
    
    return self;
}

- (void)objectUpdated:(NSNotification*)note
{
    NSArray *keys = note.object;
    
    int updates = 0;
    
    for(PropertyInfo *propertyInfo in [self.class getPropertyInfos]) {
        for(NSString *key in keys) {
            
            NSString *propKey = [[self.class description] stringByAppendingFormat:@".%@.%@", self.uniqueId, propertyInfo.name];
            
            if([propKey isEqual:key]) {
                
                updates++;
                
                [self performSelector:propertyInfo.setter withObject:[[ModelBackend shared] objectForKey:key]];
            }
        }
    }
    
    if(updates)
        [self.delegate modelUpdated:self];
}

+ (NSArray*)getPropertyInfos
{
    NSMutableArray *array = [@[] mutableCopy];
    
    unsigned int outCount, i;
    
    for(Class class = self.class; class; class = class_getSuperclass(class)) {
        
        if(class == [Model class]) {
            
            PropertyInfo *propertyInfo = [PropertyInfo new];
            
            propertyInfo.name = @"uniqueId";
            propertyInfo.getter = @selector(uniqueId);
            propertyInfo.setter = @selector(setUniqueId:);
            
            [array addObject:propertyInfo];
            
            break;
        }
        
        objc_property_t *properties = class_copyPropertyList(class, &outCount);
        
        for(i = 0; i < outCount; i++) {
            
            PropertyInfo *propertyInfo = [PropertyInfo new];
            
            propertyInfo.name = [NSString stringWithUTF8String:property_getName(properties[i])];
            
            const char *attrs = property_getAttributes(properties[i]);
            
            NSString *getter = propertyInfo.name;
            NSString *setter = nil;
            
            NSMutableString *tmp = [[[getter substringToIndex:1] capitalizedString] mutableCopy];
            
            [tmp appendString:[getter substringFromIndex:1]];
            
            setter = [NSString stringWithFormat:@"set%@:", tmp];
            
            if(attrs) {
                
                NSString *str = [NSString stringWithUTF8String:attrs];
                
                for(NSString *part in [str componentsSeparatedByString:@","]) {
                    
                    if([part characterAtIndex:0]== 'G')
                        getter = [part substringFromIndex:1];
                    
                    if([part characterAtIndex:0]== 'S')
                        setter = [part substringFromIndex:1];
                }
            }
            
            if(getter)
                propertyInfo.getter = sel_getUid([getter UTF8String]);
            
            if(setter)
                propertyInfo.setter = sel_getUid([setter UTF8String]);
            
            [array addObject:propertyInfo];
        }
        
        free(properties);
    }
    
    return array;
}

- (NSString*)description
{
    NSMutableString *str = [@"{ " mutableCopy];
    
    int i = 0;
    
    for(PropertyInfo *propertyInfo in [self.class getPropertyInfos]) {
        
        if(i++)
            [str appendFormat:@", "];
        
        [str appendFormat:@"%@: %@", propertyInfo.name, [self performSelector:propertyInfo.getter]];
    }
    
    [str appendFormat:@" }"];
    
    return str;
}

- (void)save
{
    NSParameterAssert(self.uniqueId);
    
    NSArray *oldKeys = [[ModelBackend shared] keys];
    NSMutableArray *keys = oldKeys ? [oldKeys mutableCopy] : [@[] mutableCopy];
    
    for(PropertyInfo *propertyInfo in [self.class getPropertyInfos]) {
        
        if([propertyInfo.name isEqualToString:@"uniqueId"])
            continue;
        
        NSString *key = [[[self class] description] stringByAppendingFormat:@".%@.%@", self.uniqueId, propertyInfo.name];
        
        id object = nil;
        
        if(propertyInfo.getter)
            object = [self performSelector:propertyInfo.getter];
        
        if(![keys containsObject:key])
            [keys addObject:key];
        
        [[ModelBackend shared] setObject:object forKey:key];
    }
    
    if(oldKeys.count != keys.count) {
        
        [[ModelBackend shared] setKeys:keys];
    }
    
    [[ModelBackend shared] synchronize];
}

+ (id<ModelProtocol>)loadModelForKey:(NSString *)key
{
    NSArray *array = [key componentsSeparatedByString:@"."];
    
    Class class = objc_lookUpClass([[array objectAtIndex:0] UTF8String]);
    
    return [self loadModel:class withUniqueId:[array objectAtIndex:1]];
}

+ (id<ModelProtocol>)loadModel:(Class)class withUniqueId:(id)uniqueId
{
    id model = [class new];
    
    int propertiesSet = 0;
    
    for(PropertyInfo *propertyInfo in [class getPropertyInfos]) {
        
        if([propertyInfo.name isEqualToString:@"uniqueId"]) {
            
            [model performSelector:propertyInfo.setter withObject:uniqueId];
            
            propertiesSet++;
            
            continue;
        }
        
        NSString *key = [[class description] stringByAppendingFormat:@".%@.%@", uniqueId, propertyInfo.name];
        
        id object = [[ModelBackend shared] objectForKey:key];
        
        if(object) {
            
            [model performSelector:propertyInfo.setter withObject:object];
            
            propertiesSet++;
        }
    }
    
    if(!propertiesSet)
        return nil;
    
    return model;
}

+ (id<ModelProtocol>)createModel:(Class)class
{
    Model *model = [class new];
    
    model.uniqueId = [[ModelBackend shared] generateUniqueId];
    
    return model;
}

+ (NSArray*)loadModels:(Class)class
{
    NSMutableArray *array = [@[] mutableCopy];
    
    NSString *className = [class description];
    
    NSMutableSet *set = [NSMutableSet set];
    
    for(NSString *key in [[ModelBackend shared] keys]) {

        if([key hasPrefix:className] && [key characterAtIndex:className.length] == '.') {
            
            NSString *uniqueId = [[key componentsSeparatedByString:@"."] objectAtIndex:1];
            
            [set addObject:uniqueId];
        }
    }
    
    for(NSString *uniqueId in set) {
        
        id model = [self loadModel:class withUniqueId:uniqueId];
        
        [array addObject:model];
    }
    
    return array;
}

@end
