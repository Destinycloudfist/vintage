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
#import "SourceListViewController.h"
#import "Bottles.h"
#import "Tank.h"
#import "Trackable.h"

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
    
    Trackable *trackable = [Model loadModelForKey:barrel.trackableKey];
    
    float capacity = 0.0f;
    NSString *vintage = @"";
    const char *str = "";
    
    if(trackable.vintage) {
        
        vintage = trackable.vintage;
        str = "of ";
    }
    
    if(trackable.volume.doubleValue > 0.0 && barrel.volume.doubleValue > 0.0)
        capacity = 100 * trackable.volume.doubleValue / barrel.volume.doubleValue;
    
    cell.textLabel.text = [NSString stringWithFormat:@"%.0f Gallon %@ at %.0f%% capacity %s%@", barrel.volume.doubleValue, [barrel class], capacity, str, vintage];
    
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
    self.barrels = [Model loadModelsForClasses:@[[Barrel class]]];
    
    [self.tableView reloadData];
}

- (IBAction)sourcesTap:(id)sender {
    
    SourceListViewController *controller = [SourceListViewController new];
    
    [self.navigationController pushViewController:controller animated:YES];
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
