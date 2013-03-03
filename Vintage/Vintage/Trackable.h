//
//  Trackable.h
//  Vintage
//
//  Created by Dustin Dettmer on 3/3/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import "Model.h"

@interface Trackable : Model

@property (nonatomic) NSDate *date;
@property (nonatomic) NSNumber *isDeleted;
@property (nonatomic) NSNumber *isWaste;
@property (nonatomic) NSNumber *volume;
@property (nonatomic) NSString *vesselKey;

@property (nonatomic) NSString *vintage;
@property (nonatomic) NSString *year;
@property (nonatomic) NSString *notes;

// Array of NSNumbers holding doubles and an array of NSDates
// holding the dates of the readings respectively.
@property (nonatomic) NSArray *phReadings;
@property (nonatomic) NSArray *phReadingDates;

// Array of NSNumbers holding doubles and an array of NSDates
// holding the dates of the readings respectively.
@property (nonatomic) NSArray *brixReadings;
@property (nonatomic) NSArray *brixReadingDates;

// Array of NSStrings holding keys to Trackable objects and NSNumbers holding
// doubles of gallons respectively.
@property (nonatomic) NSArray *sourceKeys;
@property (nonatomic) NSArray *sourceVolumes;

@end
