//
//  SourceStatusViewController.m
//  Vintage
//
//  Created by Dustin Dettmer on 3/3/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import "SourceStatusViewController.h"
#import "Trackable.h"
#import "TrackableViewController.h"

@interface SourceStatusViewController ()

@property (weak, nonatomic) IBOutlet UITextField *volume;
@property (weak, nonatomic) IBOutlet UITextField *vintage;
@property (weak, nonatomic) IBOutlet UITextField *year;

@end

@implementation SourceStatusViewController

- (IBAction)continueTap:(id)sender {
    
    Trackable *trackable = [Trackable new];
    
    trackable.date = [NSDate date];
    trackable.volume = @(self.volume.text.doubleValue);
    trackable.vintage = self.vintage.text;
    trackable.year = self.year.text;
    
    trackable.sourceKeys = @[self.source.key];
    trackable.sourceVolumes = @[trackable.volume];
    
    [trackable save];
    
    TrackableViewController *controller = [TrackableViewController new];
    
    controller.trackable = trackable;
    
    UINavigationController *nav = self.navigationController;
    
    [nav popToRootViewControllerAnimated:NO];
    [nav pushViewController:controller animated:NO];
    
    [controller transfer];
}

@end
