//
//  Model.h
//  Vintage
//
//  Created by Dustin Dettmer on 3/2/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ModelProtocol <NSObject>

- (id)uniqueId;

@end

@interface Model : NSObject<ModelProtocol>

- (void)save;

+ (id<ModelProtocol>)loadModel:(Class)class withUniqueId:(id)uniqueId;

+ (NSArray*)loadModels:(Class)class;

@end
