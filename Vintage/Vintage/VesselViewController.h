//
//  VesselViewController.h
//  Vintage
//
//  Created by Philippe Hausler on 3/3/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import "ModelViewController.h"

typedef NS_ENUM(NSUInteger, VesselDataSource) {
    VesselStatusDataSource,
    VesselContentsDataSource,
    VesselTasksDataSource
};

@interface VesselViewController : ModelViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UIBarButtonItem *statusButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *contentsButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *tasksButton;

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, readonly) VesselDataSource dataSource;

- (IBAction)showStatus:(UIBarButtonItem *)sender;
- (IBAction)showContents:(UIBarButtonItem *)sender;
- (IBAction)showTasks:(UIBarButtonItem *)sender;

- (NSUInteger)numberOfStatusItems;
- (NSUInteger)numberofContentsItems;
- (NSUInteger)numberOfTaskItems;

@end
