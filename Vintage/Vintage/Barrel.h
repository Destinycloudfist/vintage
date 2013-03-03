//
//  Barrel.h
//  Vintage
//
//  Created by Dustin Dettmer on 3/2/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Vessel.h"

@interface Barrel : Vessel

@property (nonatomic, strong) NSString *uniqueId;
@property (nonatomic, strong) NSString *vintage;
@property (nonatomic, strong) NSString *year;
@property (nonatomic, strong) NSString *notes;

@end
