//
//  ItemScannedController.m
//  Vintage
//
//  Created by Dustin Dettmer on 3/2/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import "BarrelViewController.h"
#import "Barrel.h"
#import "BarrelStatusViewController.h"

@interface BarrelViewController ()

@property (weak, nonatomic) IBOutlet UITextField *gallons;
@property (weak, nonatomic) IBOutlet UITextField *toast;
@property (weak, nonatomic) IBOutlet UITextField *material;

@end

@implementation BarrelViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)save:(id)sender
{
    Barrel *barrel = [Barrel new];
    
    barrel.volume = @([self.gallons.text doubleValue]);
    barrel.toast = self.toast.text;
    barrel.material = self.material.text;
    
    [barrel save];
    
    BarrelStatusViewController *controller = [BarrelStatusViewController new];
    
    controller.barrel = barrel;
    
    [self.navigationController popToRootViewControllerAnimated:NO];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
