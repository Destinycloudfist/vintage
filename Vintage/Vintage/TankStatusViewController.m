//
//  TankStatusViewController.m
//  Vintage
//
//  Created by Dustin Dettmer on 3/3/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import "TankStatusViewController.h"
#import "TrackableListViewController.h"
#import "Tank.h"
#import "TankViewController.h"
#import "Trackable.h"

@interface TankStatusViewController ()

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *contentsButton;

@end

@implementation TankStatusViewController

- (id)initWithModel:(Model *)model
{
    self = [super initWithModel:model];
    if (self)
    {
        self.tank = (Tank *)model;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.name.text = self.tank.name;
    
    self.label.text = [NSString stringWithFormat:@"%.0f Gallons %@%@",
                       self.tank.volume.doubleValue, self.tank.shape,
                       self.tank.coolingJacket ? @" - Cooling Jacket" : @""];
    
    if(self.tank.trackableKey) {
        
        Trackable *trackable = [Model loadModelForKey:self.tank.trackableKey];
        
        NSString *str = [NSString stringWithFormat:@"%.2f Gallon of %@", trackable.volume.doubleValue, trackable.vintage];
        
        [self.contentsButton setTitle:str forState:UIControlStateNormal];
    }
}

- (IBAction)contentsTap:(id)sender {
    
    TrackableListViewController *controller = [TrackableListViewController new];
    
    controller.vessel = self.tank;
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)reconfigureTap:(id)sender {
    
    TankViewController *controller = [TankViewController new];
    
    controller.tank = self.tank;
    
    UINavigationController *nav = self.navigationController;
    
    [nav popToRootViewControllerAnimated:NO];
    [nav pushViewController:controller animated:YES];
}

@end
