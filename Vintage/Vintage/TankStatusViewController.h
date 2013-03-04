//
//  TankStatusViewController.h
//  Vintage
//
//  Created by Dustin Dettmer on 3/3/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelViewController.h"

@class Tank;

@interface TankStatusViewController : ModelViewController

@property (nonatomic, strong) Tank *tank;

@end
