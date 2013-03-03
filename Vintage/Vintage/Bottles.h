//
//  Bottles.h
//  Vintage
//
//  Created by Dustin Dettmer on 3/2/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import "Vessel.h"

@interface Bottles : Vessel

@property (nonatomic, strong) NSNumber *numberOfCases;
@property (nonatomic, strong) NSNumber *bottlesPerCase;
@property (nonatomic, strong) NSNumber *volumePerBottle;

@end
