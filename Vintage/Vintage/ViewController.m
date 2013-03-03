//
//  ViewController.m
//  Vintage
//
//  Created by Dustin Dettmer on 3/2/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import "ViewController.h"
#import "BarrelViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *tagIdField;

@property (nonatomic, strong) NSArray *barrels;

@end

@implementation ViewController

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
    
    Barrel *barrel = [Model loadModel:[Barrel class] withUniqueId:self.tagIdField.text];
    
    if(!barrel) {
        
        barrel = [Barrel new];
        barrel.uniqueId = self.tagIdField.text;
    }
    
    BarrelViewController *controller = [[BarrelViewController alloc] initWithBarrel:barrel];
    
    [self.navigationController pushViewController:controller animated:YES];
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
    
    cell.textLabel.text = barrel.uniqueId;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Barrel *barrel = [self.barrels objectAtIndex:indexPath.row];
    
    BarrelViewController *controller = [[BarrelViewController alloc] initWithBarrel:barrel];
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)reloadBarrels
{
    self.barrels = [Model loadModels:[Barrel class]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Vintage";
}

@end
