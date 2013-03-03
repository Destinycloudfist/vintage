//
//  Model.h
//  Vintage
//
//  Created by Dustin Dettmer on 3/2/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Model;

@protocol ModelProtocol <NSObject>

- (id)uniqueId;

@end

@protocol ModelDelegate <NSObject>

- (void)modelUpdated:(id<ModelProtocol>)model;

@end

@interface Model : NSObject<ModelProtocol>

@property (nonatomic, weak) id<ModelDelegate> delegate;

@property (nonatomic, strong) NSString *uniqueId;

+ (id<ModelProtocol>)loadModel:(Class)class withUniqueId:(id)uniqueId;

/// Creates a new model of the given class with a generic uniqueId.
+ (id<ModelProtocol>)createModel:(Class)class;

+ (NSArray*)loadModels:(Class)class;

- (void)save;

@end
