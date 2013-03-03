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

@interface BarrelStatusViewController ()

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *contentsButton;

@end

@implementation BarrelStatusViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.label.text = [NSString stringWithFormat:@"%@ gallons %@ %@", self.barrel.volume, self.barrel.toast, self.barrel.material];
    
    if(self.barrel.trackableKey) {
        
        Trackable *trackable = [Model loadModelForKey:self.barrel.trackableKey];
        
        NSString *str = [NSString stringWithFormat:@"%@ gallons of %@", trackable.volume, trackable.vintage];
        
        [self.contentsButton setTitle:str forState:UIControlStateNormal];
    }
}

- (IBAction)contentsTap:(id)sender
{
    TrackableListViewController *controller = [TrackableListViewController new];
    
    controller.vessel = self.barrel;
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
