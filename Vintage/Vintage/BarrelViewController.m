//
//  ItemScannedController.m
//  Vintage
//
//  Created by Dustin Dettmer on 3/2/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import "BarrelViewController.h"

@interface BarrelViewController ()

@property (nonatomic, strong) Barrel *barrel;

@property (weak, nonatomic) IBOutlet UITextField *vintage;
@property (weak, nonatomic) IBOutlet UITextField *year;
@property (weak, nonatomic) IBOutlet UITextView *notesTextView;

@end

@implementation BarrelViewController

- (id)initWithModel:(Model *)model
{
    self = [super initWithModel:model];
    
    if(self) {
        
        self.barrel = (Barrel *)model;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = [self.barrel.uniqueId description];
}

- (IBAction)cancel:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)save:(id)sender
{
    [self.barrel save];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
