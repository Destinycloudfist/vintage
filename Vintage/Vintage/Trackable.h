//
//  Trackable.h
//  Vintage
//
//  Created by Dustin Dettmer on 3/3/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import "Model.h"

@interface Trackable : Model

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSNumber *isDeleted;
@property (nonatomic, strong) NSNumber *volume;
@property (nonatomic, strong) NSString *containerKey;

@property (nonatomic, strong) NSString *vintage;
@property (nonatomic, strong) NSString *year;
@property (nonatomic, strong) NSString *notes;

// Array of NSNumbers holding doubles and an array of NSDates
// holding the dates of the readings respectively.
@property (nonatomic, strong) NSArray *phReadings;
@property (nonatomic, strong) NSArray *phReadingDates;

// Array of NSNumbers holding doubles of and an array of NSDates
// holding the dates of the readings respectively.
@property (nonatomic, strong) NSArray *bixReadings;
@property (nonatomic, strong) NSArray *bixReadingDates;

// Array of NSStrings holding keys to Trackable objects and NSNumbers holding
// doubles of gallons respectively.
@property (nonatomic, strong) NSArray *sourceKeys;
@property (nonatomic, strong) NSArray *sourceVolumes;

@end
