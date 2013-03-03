//
//  Bottles.h
//  Vintage
//
//  Created by Dustin Dettmer on 3/2/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import "Vessel.h"

@interface Bottles : Vessel

@property (nonatomic) NSNumber *numberOfCases;
@property (nonatomic) NSNumber *bottlesPerCase;
@property (nonatomic) NSNumber *volumePerBottle;
@property (nonatomic) NSString *type;
@property (nonatomic) NSString *color;

@end
