//
//  TransferViewController.m
//  Vintage
//
//  Created by Dustin Dettmer on 3/3/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import "TransferViewController.h"

@interface TransferViewController ()

@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UILabel *toLabel;
@property (weak, nonatomic) IBOutlet UITextField *transferVolume;
@property (weak, nonatomic) IBOutlet UISlider *transferVolumeSlider;
@property (weak, nonatomic) IBOutlet UITextField *wastedVolume;
@property (weak, nonatomic) IBOutlet UILabel *remainingLabel;

@end

@implementation TransferViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.fromLabel.text = [[self.fromVessel class] description];
    self.toLabel.text = [[self.toVessel class] description];
    
    [self updateRemaining];
}

- (NSString*)printDouble:(double)number
{
    return [NSString stringWithFormat:@"%.2f", number];
}

- (void)updateRemaining
{
    double amount = self.trackable.volume.doubleValue;
    
    amount -= self.transferVolume.text.doubleValue;
    
    amount -= self.wastedVolume.text.doubleValue;
    
    self.remainingLabel.text = [self printDouble:amount];
}

- (IBAction)transferVolumeChanged:(id)sender
{
    if(self.transferVolume.text.doubleValue > self.trackable.volume.doubleValue)
        self.transferVolume.text = self.trackable.volume.description;
    
    self.transferVolumeSlider.value = self.transferVolume.text.doubleValue / self.trackable.volume.doubleValue;
    
    [self updateRemaining];
}

- (IBAction)transferSliderChanged:(id)sender
{
    self.transferVolume.text = [self printDouble:self.trackable.volume.doubleValue * self.transferVolumeSlider.value];
    
    [self updateRemaining];
}

- (IBAction)wastedVolumeChanged:(id)sender
{
    [self updateRemaining];
}

- (IBAction)confirmTap:(id)sender
{
    Trackable *newTrackable = [Trackable new];
    
    newTrackable.date = [NSDate date];
    newTrackable.volume = @(self.transferVolume.text.doubleValue);
    newTrackable.vesselKey = self.toVessel.key;
    newTrackable.vintage = self.trackable.vintage;
    newTrackable.year = self.trackable.year;
    newTrackable.notes = self.trackable.notes;
    newTrackable.sourceKeys = @[self.trackable.key];
    newTrackable.sourceVolumes = @[newTrackable.volume];
    
    [newTrackable save];
    
    self.toVessel.trackableKey = newTrackable.key;
    
    [self.toVessel save];
    
    if(self.wastedVolume.text.doubleValue > 0.0) {
        
        Trackable *newTrackable = [Trackable new];
        
        newTrackable.date = [NSDate date];
        newTrackable.isWaste = @(YES);
        newTrackable.volume = @(self.wastedVolume.text.doubleValue);
        newTrackable.vesselKey = self.toVessel.key;
        newTrackable.vintage = self.trackable.vintage;
        newTrackable.year = self.trackable.year;
        newTrackable.notes = self.trackable.notes;
        newTrackable.sourceKeys = @[self.trackable.key];
        newTrackable.sourceVolumes = @[newTrackable.volume];
        
        [newTrackable save];
    }
    
    double amount = self.trackable.volume.doubleValue;

    amount -= self.transferVolume.text.doubleValue;

    amount -= self.wastedVolume.text.doubleValue;
    
    self.trackable.isDeleted = @(YES);
    [self.trackable save];
    
    if(amount > 0.0) {
        
        Trackable *newTrackable = [Trackable new];
        
        newTrackable.date = [NSDate date];
        newTrackable.volume = @(amount);
        newTrackable.vesselKey = self.toVessel.key;
        newTrackable.vintage = self.trackable.vintage;
        newTrackable.year = self.trackable.year;
        newTrackable.notes = self.trackable.notes;
        newTrackable.sourceKeys = @[self.trackable.key];
        newTrackable.sourceVolumes = @[newTrackable.volume];
        
        [newTrackable save];
        
        self.fromVessel.trackableKey = newTrackable.key;
    }
    else {
        
        self.fromVessel.trackableKey = nil;
    }
    
    [self.fromVessel save];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
