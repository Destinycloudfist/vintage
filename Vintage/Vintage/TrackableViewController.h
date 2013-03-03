//
//  TrackableViewController.h
//  Vintage
//
//  Created by Dustin Dettmer on 3/3/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Trackable.h"

@interface TrackableViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) Trackable *trackable;

@end
