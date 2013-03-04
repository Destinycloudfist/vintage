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

#if TARGET_OS_ANDROID
#import <NFC/APNFCManager.h>
#else

@implementation APNFCManager : NSObject

+(void)readNFCTagWithCompletionBlock:(void(^)(BOOL success, NSString *payload))block
{
    block(YES, @"");
}

+(void)writeNFCTagWithURLString:(NSString *)urlString completionBlock:(void(^)(BOOL success, NSString *payload))block
{
    block(YES, @"");    
}

@end


#endif


@interface BarrelViewController ()

@property (weak, nonatomic) IBOutlet UITextField *gallons;
@property (weak, nonatomic) IBOutlet UITextField *toast;
@property (weak, nonatomic) IBOutlet UITextField *material;

@end

@implementation BarrelViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.gallons.text = self.barrel.volume.description;
    self.toast.text = self.barrel.toast;
    self.material.text = self.barrel.material;
}

- (IBAction)save:(id)sender
{
    if(!self.barrel)
        self.barrel = [Barrel new];
    
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
    WaitForTapController *waitController = [[WaitForTapController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:waitController animated:YES];
    NSString *url = [[[NSURL alloc] initWithScheme:@"vintage" host:@"Barrel" path:self.barrel.uniqueId] absoluteString];
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
