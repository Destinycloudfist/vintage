//
//  ViewController.m
//  Vintage
//
//  Created by Dustin Dettmer on 3/2/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import "ViewController.h"
#import "BarrelViewController.h"
#import "ModelBackend.h"
#import "NewVesselController.h"
#import "BarrelStatusViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *tagIdField;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *barrels;

@end

@implementation ViewController

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)itemScanned:(id)sender {
    
    if(!self.tagIdField.text.length) {
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Trouble"
                              message:@"You must enter a tag id"
                              delegate:nil
                              cancelButtonTitle:@"Okay"
                              otherButtonTitles:nil];
        
        [alert show];
        
        return;
    }
    
    NewVesselController *controller = [NewVesselController new];
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.tagIdField.text = @"";
    
    [self reloadBarrels];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.barrels.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"UITableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    Barrel *barrel = [self.barrels objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", barrel.uniqueId];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Barrel *barrel = [self.barrels objectAtIndex:indexPath.row];
    
    BarrelStatusViewController *controller = [BarrelStatusViewController new];
    
    controller.barrel = barrel;
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)reloadBarrels
{
    self.barrels = [Model loadModels:[Barrel class]];
    
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Vintage";
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(reloadBarrels)
     name:ModelBackendKeysUpdated
     object:nil];
}

@end
