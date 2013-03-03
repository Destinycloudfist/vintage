//
//  TrackableListViewController.h
//  Vintage
//
//  Created by Dustin Dettmer on 3/3/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Vessel.h"
#import "VesselListViewcontroller.h"

@interface TrackableListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, VesselListDelegate>

@property (nonatomic, strong) Vessel *vessel;

@end
