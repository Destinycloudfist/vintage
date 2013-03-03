//
//  Vessel.h
//  Vintage
//
//  Created by Philippe Hausler on 3/2/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import "Model.h"

@interface Vessel : Model

@property (nonatomic) NSNumber *volume;
@property (nonatomic) NSString *trackableKey;
@property (nonatomic) NSArray *oldTrackableKeys;

@end
