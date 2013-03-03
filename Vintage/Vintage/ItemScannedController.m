//
//  ItemScannedController.m
//  Vintage
//
//  Created by Dustin Dettmer on 3/2/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import "ItemScannedController.h"

@interface ItemScannedController ()

@property (weak, nonatomic) IBOutlet UIImageView *mapImage;

@property (nonatomic, strong) CLLocationManager *manager;

@end

@implementation ItemScannedController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.manager = [CLLocationManager new];
    
    self.manager.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.manager startUpdatingLocation];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *loc = [locations lastObject];
    
    int width = self.mapImage.frame.size.width;
    int height = self.mapImage.frame.size.height;
    
    NSString *str = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/staticmap?center=%f,%f&zoom=16&size=%dx%d&sensor=false", loc.coordinate.latitude, loc.coordinate.longitude, width, height];
    
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:str]];
    
    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *resp, NSData *data, NSError *error) {
        
        self.mapImage.image = [UIImage imageWithData:data];
    }];
    
    [manager stopUpdatingLocation];
}

@end
