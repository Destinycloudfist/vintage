//
//  ViewController.m
//  Vintage
//
//  Created by Dustin Dettmer on 3/2/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import "ViewController.h"
#import "ItemScannedController.h"

@interface ViewController ()

@end

@implementation ViewController

- (IBAction)itemScanned:(id)sender {
    
    [self.navigationController pushViewController:[ItemScannedController new] animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Vintage";
}

@end
