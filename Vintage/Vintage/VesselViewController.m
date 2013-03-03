//
//  VesselViewController.m
//  Vintage
//
//  Created by Philippe Hausler on 3/3/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import "VesselViewController.h"

@interface VesselViewController ()

@end

@implementation VesselViewController

- (void)setDataSource:(VesselDataSource)dataSource
{
    if (_dataSource != dataSource)
    {
        _dataSource = dataSource;
        self.statusButton.enabled = _dataSource != VesselStatusDataSource;
        self.contentsButton.enabled = _dataSource != VesselContentsDataSource;
        self.tasksButton.enabled = _dataSource != VesselTasksDataSource;
        [self.tableView reloadData];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setDataSource:VesselStatusDataSource];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (self.dataSource)
    {
        case VesselStatusDataSource:
            return [self numberOfStatusItems];
        case VesselContentsDataSource:
            return [self numberofContentsItems];
        case VesselTasksDataSource:
            return [self numberOfTaskItems];
    }
    NSAssert(0, @"Invalid data source");
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.dataSource)
    {
        
    }
    return nil;
}

- (NSUInteger)numberOfStatusItems
{
    return 0;
}

- (NSUInteger)numberofContentsItems
{
    return 0;
}

- (NSUInteger)numberOfTaskItems
{
    return 0;
}

- (IBAction)showStatus:(UIBarButtonItem *)sender
{
    [self setDataSource:VesselStatusDataSource];
}

- (IBAction)showContents:(UIBarButtonItem *)sender
{
    [self setDataSource:VesselContentsDataSource];
}

- (IBAction)showTasks:(UIBarButtonItem *)sender
{
    [self setDataSource:VesselTasksDataSource];
}

@end
