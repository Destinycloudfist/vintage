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

@property (weak, nonatomic) IBOutlet UITextField *tagIdField;

@end

@implementation ViewController

- (IBAction)itemScanned:(id)sender {
    
    ItemScannedController *controller = [[ItemScannedController alloc] initWithTagId:self.tagIdField.text];
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Vintage";
}

@end
