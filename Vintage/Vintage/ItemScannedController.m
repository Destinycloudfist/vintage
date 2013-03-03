//
//  ItemScannedController.m
//  Vintage
//
//  Created by Dustin Dettmer on 3/2/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import "ItemScannedController.h"

@interface ItemScannedController ()

@property (nonatomic, strong) NSString *tagId;

@end

@implementation ItemScannedController

- (id)initWithTagId:(NSString*)tagId
{
    self = [super init];
    
    if(self) {
        
        self.tagId = tagId;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.tagId;
}

- (IBAction)cancel:(id)sender
{
    
}

- (IBAction)save:(id)sender
{
    
}

@end
