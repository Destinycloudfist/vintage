//
//  TransferViewController.h
//  Vintage
//
//  Created by Dustin Dettmer on 3/3/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Trackable.h"
#import "Vessel.h"

@interface TransferViewController : UIViewController

@property (nonatomic, strong) Trackable *trackable;
@property (nonatomic, strong) Vessel *fromVessel;
@property (nonatomic, strong) Vessel *toVessel;

@end
