//
//  BarellStatusViewController.m
//  Vintage
//
//  Created by Dustin Dettmer on 3/3/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import "BarrelStatusViewController.h"
#import "Trackable.h"
#import "TrackableListViewController.h"
#import "BarrelViewController.h"


@interface BarrelStatusViewController ()

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *contentsButton;

@end

@implementation BarrelStatusViewController


- (id)initWithModel:(Model *)model
{
    self = [super initWithModel:model];
    if (self)
    {
        self.barrel = (Barrel *)model;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.name.text = self.barrel.name;
    
    self.label.text = [NSString stringWithFormat:@"%.1f gallon %@ %@",
                       self.barrel.volume.doubleValue, self.barrel.toast, self.barrel.material];
    
    if(self.barrel.trackableKey) {
        
        Trackable *trackable = [Model loadModelForKey:self.barrel.trackableKey];
        
        NSString *str = [NSString stringWithFormat:@"%@ gallons of %@", trackable.volume, trackable.vintage];
        
        [self.contentsButton setTitle:str forState:UIControlStateNormal];
    }
}

- (IBAction)contentsTap:(id)sender {
    
    TrackableListViewController *controller = [TrackableListViewController new];
    
    controller.vessel = self.barrel;
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)reconfigureTap:(id)sender {
    
    BarrelViewController *controller = [BarrelViewController new];
    
    controller.barrel = self.barrel;
    
    UINavigationController *nav = self.navigationController;
    
    [nav popToRootViewControllerAnimated:NO];
    [nav pushViewController:controller animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
