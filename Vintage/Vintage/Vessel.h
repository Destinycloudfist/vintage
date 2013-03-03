//
//  Vessel.h
//  Vintage
//
//  Created by Philippe Hausler on 3/2/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import "Trackable.h"

@interface Vessel : Trackable

@property (nonatomic, strong) NSString *sourceId;

@property (nonatomic, strong) NSNumber *volume;

@end
