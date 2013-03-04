//
//  TankViewController.m
//  Vintage
//
//  Created by Dustin Dettmer on 3/3/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import "TankViewController.h"
#import "Tank.h"
#import "TankStatusViewController.h"
#import "Stubs.h"

@interface TankViewController ()

@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *gallons;
@property (weak, nonatomic) IBOutlet UITextField *shape;
@property (weak, nonatomic) IBOutlet UISwitch *coolingJacket;

@end

@implementation TankViewController

- (id)initWithModel:(Model *)model
{
    self = [super initWithModel:model];
    if (self)
    {
        self.tank = (Tank *)model;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.name.text = self.tank.name;
    self.gallons.text = self.tank.volume.description;
    self.shape.text = self.tank.shape;
    self.coolingJacket.on = [self.tank.coolingJacket boolValue];
}

- (IBAction)save:(id)sender
{
    if(!self.tank)
        self.tank = [Tank new];
    
    self.tank.name = self.name.text;
    self.tank.volume = @([self.gallons.text doubleValue]);
    self.tank.shape = self.shape.text;
    self.tank.coolingJacket = @(self.coolingJacket.on);
    
    [self.tank save];
    
    TankStatusViewController *controller = [TankStatusViewController new];
    
    controller.tank = self.tank;
    
    [self.navigationController popToRootViewControllerAnimated:NO];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)tag:(id)sender
{
    if(!self.tank)
        self.tank = [Tank new];
    
    self.tank.name = self.name.text;
    self.tank.volume = @([self.gallons.text doubleValue]);
    self.tank.shape = self.shape.text;
    self.tank.coolingJacket = @(self.coolingJacket.on);
    
    [self.tank save];
    
    NSString *url = [NSString stringWithFormat:@"vintage://%@", self.tank.keyPath];
    [APNFCManager writeNFCTagWithURLString:url completionBlock:^(BOOL success, NSString *payload){
        if (success) {
            TankStatusViewController *controller = [TankStatusViewController new];
            
            controller.tank = self.tank;
            
            [self.navigationController popToRootViewControllerAnimated:NO];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }];
}

@end
