//
//  TrackableViewController.m
//  Vintage
//
//  Created by Dustin Dettmer on 3/3/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import "TrackableViewController.h"
#import "TransferViewController.h"

@interface TrackableViewController ()

@property (weak, nonatomic) IBOutlet UILabel *volume;
@property (weak, nonatomic) IBOutlet UILabel *vintage;
@property (weak, nonatomic) IBOutlet UILabel *year;

@property (nonatomic, strong) NSArray *sources;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TrackableViewController

- (void)viewWillAppear:(BOOL)animated
{
    BOOL firstTime = self.sources == nil;
    
    self.volume.text = self.trackable.volume.description;
    self.vintage.text = self.trackable.vintage;
    self.year.text = self.trackable.year;
    
    self.sources = [Model loadModelsForKeys:self.trackable.sourceKeys];
    
    if(!firstTime)
        [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sources.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    if(!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    
    cell.textLabel.text = [[self.sources objectAtIndex:indexPath.row] prettyDescription];
    
    return cell;
}

- (IBAction)transfer
{
    VesselListViewcontroller *controller = [VesselListViewcontroller new];
    
    controller.delegate = self;
    
    [self presentViewController:controller animated:YES completion:nil];
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

@end
