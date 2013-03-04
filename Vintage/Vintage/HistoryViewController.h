//
//  HistoryViewController.h
//  Vintage
//
//  Created by Philippe Hausler on 3/3/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Trackable.h"

@interface HistoryViewController : UITableViewController
+ (HistoryViewController *)history:(Trackable *)trackable;
@end
