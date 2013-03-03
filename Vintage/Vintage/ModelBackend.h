//
//  ModelBackend.h
//  Vintage
//
//  Created by Dustin Dettmer on 3/2/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelBackend : NSObject

@property (nonatomic, strong) NSArray *keys;

+ (ModelBackend*)shared;

- (id)objectForKey:(NSString*)key;
- (void)setObject:(id)object forKey:(NSString *)key;

- (void)synchronize;

@end
