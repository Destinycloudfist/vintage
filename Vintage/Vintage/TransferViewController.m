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
}

- (void)updateRemaining
{
    double amount = self.trackable.volume.doubleValue;
    
    amount -= self.transferVolume.text.doubleValue;
    
    amount -= self.wastedVolume.text.doubleValue;
    
    self.wastedVolume.text = [@(amount) description];
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
    self.transferVolume.text = [@(self.trackable.volume.doubleValue * self.transferVolumeSlider.value) description];
    
    [self updateRemaining];
}

- (IBAction)wastedVolumeChanged:(id)sender
{
    [self updateRemaining];
}


@end
