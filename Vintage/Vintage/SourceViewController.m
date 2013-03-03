//
//  SourceViewController.m
//  Vintage
//
//  Created by Dustin Dettmer on 3/3/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import "SourceViewController.h"
#import "Source.h"

@interface SourceViewController ()
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *notes;

@end

@implementation SourceViewController

- (IBAction)saveSource:(id)sender {
    
    Source *source = [Source new];
    
    source.name = self.name.text;
    source.notes = self.notes.text;
    
    [source save];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
