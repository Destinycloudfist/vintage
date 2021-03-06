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
#import "WaitForTapController.h"
#import "Stubs.h"


@interface BarrelViewController ()

@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *gallons;
@property (weak, nonatomic) IBOutlet UITextField *toast;
@property (weak, nonatomic) IBOutlet UITextField *material;

@end

@implementation BarrelViewController

- (id)initWithModel:(Model *)model
{
    self = [super initWithModel:model];
    if (self)
    {
        self.barrel = (Barrel *)model;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.name.text = self.barrel.name;
    self.gallons.text = self.barrel.volume.description;
    self.toast.text = self.barrel.toast;
    self.material.text = self.barrel.material;
}

- (IBAction)save:(id)sender
{
    if(!self.barrel)
        self.barrel = [Barrel new];
    
    self.barrel.name = self.name.text;
    self.barrel.volume = @([self.gallons.text doubleValue]);
    self.barrel.toast = self.toast.text;
    self.barrel.material = self.material.text;
    
    [self.barrel save];
    
    BarrelStatusViewController *controller = [BarrelStatusViewController new];
    
    controller.barrel = self.barrel;
    
    [self.navigationController popToRootViewControllerAnimated:NO];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)tag:(id)sender
{
    if(!self.barrel)
        self.barrel = [Barrel new];
    
    self.barrel.name = self.name.text;
    self.barrel.volume = @([self.gallons.text doubleValue]);
    self.barrel.toast = self.toast.text;
    self.barrel.material = self.material.text;
    
    [self.barrel save];
    
    WaitForTapController *waitController = [[WaitForTapController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:waitController animated:YES];
    NSString *url = [NSString stringWithFormat:@"vintage://%@", self.barrel.keyPath];
    [APNFCManager writeNFCTagWithURLString:url completionBlock:^(BOOL success, NSString *payload){
        if (success) {
            BarrelStatusViewController *controller = [BarrelStatusViewController new];
            
            controller.barrel = self.barrel;
            
            [self.navigationController popToRootViewControllerAnimated:NO];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }];
}

@end
