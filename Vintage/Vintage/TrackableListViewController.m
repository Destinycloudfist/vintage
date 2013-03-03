//
//  TrackableListViewController.m
//  Vintage
//
//  Created by Dustin Dettmer on 3/3/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import "TrackableListViewController.h"
#import "Trackable.h"
#import "TransferViewController.h"

@interface TrackableListViewController ()

@property (nonatomic, strong) Trackable *trackable;

@end

@implementation TrackableListViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (self.vessel.trackableKey ? 1 : 0) + self.vessel.oldTrackableKeys.count;
}

- (NSString*)keyForIndexPath:(NSIndexPath *)indexPath
{
    NSString *trackableKey = nil;
    
    if(indexPath.row == 0 && self.vessel.trackableKey)
        trackableKey = self.vessel.trackableKey;
    else
        trackableKey = [self.vessel.oldTrackableKeys objectAtIndex:indexPath.row - (self.vessel.trackableKey ? 1 : 0)];
    
    return trackableKey;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    if(!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    
    Trackable *trackable = [Model loadModelForKey:[self keyForIndexPath:indexPath]];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ gallons of %@", trackable.volume, trackable.vintage];
    
    return cell;
}

- (void)vesselList:(VesselListViewcontroller *)controller selectedVessel:(Vessel *)vessel
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    TransferViewController *newController = [TransferViewController new];
    
    newController.trackable = self.trackable;
    newController.fromVessel = [Model loadModelForKey:self.trackable.vesselKey];
    newController.toVessel = vessel;
    
    [self.navigationController pushViewController:newController animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.trackable = [Model loadModelForKey:[self keyForIndexPath:indexPath]];
    
    VesselListViewcontroller *controller = [VesselListViewcontroller new];
    
    controller.delegate = self;
    
    [self presentViewController:controller animated:YES completion:nil];
}

@end
