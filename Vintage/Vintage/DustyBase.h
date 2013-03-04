//
//  DustyBase.h
//  Vintage
//
//  Created by Dustin Dettmer on 3/3/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import <Foundation/Foundation.h>

// Object is an array of two elements, key and value respectively.
extern NSString *DustyBaseNewIdNotification;

typedef enum DustyBaseEventType {
    DustyBaseEventTypeValue = 0
} DustyBaseEventType;

@interface DustyBase : NSObject

@property (nonatomic, readonly, strong) NSString *name;

- (id)initWithUrl:(NSString*)url;

// Deprecated: Don't use this crap. Use DustyBaseNewIdNotification instead.
- (void)set:(id)value onComplete:(void (^)(NSError* error))callback;

- (void)on:(DustyBaseEventType)eventType doCallback:(void (^) (id key, id value))callback;

- (DustyBase*)child:(NSString*)path;

- (DustyBase*)push;

@end
