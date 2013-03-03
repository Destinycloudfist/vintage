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

@property (weak, nonatomic) IBOutlet UITextView *notesTextView;

@end

@implementation BarrelViewController

- (id)initWithBarrel:(Barrel*)barrel
{
    self = [super init];
    
    if(self) {
        
        self.barrel = barrel;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = [self.barrel.uniqueId description];
    
    self.notesTextView.text = self.barrel.notes;
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
