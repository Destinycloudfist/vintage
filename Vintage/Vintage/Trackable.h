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
@property (nonatomic, strong) NSNumber *isHidden;

@end
