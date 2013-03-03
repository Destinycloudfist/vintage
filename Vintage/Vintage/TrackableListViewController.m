//
//  TrackableListViewController.m
//  Vintage
//
//  Created by Dustin Dettmer on 3/3/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import "TrackableListViewController.h"
#import "Trackable.h"

@interface TrackableListViewController ()

@end

@implementation TrackableListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (self.vessel.trackableKey ? 1 : 0) + self.vessel.oldTrackableKeys.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    if(!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    
    NSString *trackableKey = nil;
    
    if(indexPath.row == 0 && self.vessel.trackableKey)
        trackableKey = self.vessel.trackableKey;
    else
        trackableKey = [self.vessel.oldTrackableKeys objectAtIndex:indexPath.row - (self.vessel.trackableKey ? 1 : 0)];
    
    Trackable *trackable = [Model loadModelForKey:trackableKey];
    
    cell.textLabel.text = trackable.prettyDescription;
    
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
