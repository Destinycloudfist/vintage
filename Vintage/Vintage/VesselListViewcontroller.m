//
//  VesselListViewcontroller.m
//  Vintage
//
//  Created by Dustin Dettmer on 3/3/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import "VesselListViewcontroller.h"
#import "Barrel.h"
#import "Bottles.h"
#import "Tank.h"
#import "AppDelegate.h"

@interface VesselListViewcontroller ()

@property (nonatomic, strong) NSArray *vessels;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation VesselListViewcontroller

- (void)viewDidLoad
{
    [[AppDelegate sharedInstance] setNCFAction:^(Model *model){
        [self.delegate vesselList:self selectedVessel:(Vessel *)model];
        [[AppDelegate sharedInstance] setNCFAction:nil];
        return YES;
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    BOOL firstTime = self.vessels == nil;
    
    self.vessels = [Model loadModelsForClasses:@[[Barrel class], [Bottles class], [Tank class]]];
    
    if(!firstTime)
        [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.vessels.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    if(!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    
    cell.textLabel.text = [[self.vessels objectAtIndex:indexPath.row] prettyDescription];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate vesselList:self selectedVessel:[self.vessels objectAtIndex:indexPath.row]];
}

@end
