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

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *barrels;

@property (nonatomic, strong) NSMutableDictionary *capacityByIndexPath;

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
    [self reloadBarrels];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.barrels.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120.0f;
}

#define FUZZY_EQUALS(a, b, fuzz) (a > b - fuzz && a < b + fuzz)

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"UITableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    int RedBarrelTag = 1;
    UIImageView *redBarrel = nil;
    
    if(!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        CGRect frame =
        {
            0.0f, 119.0f,
            80.0f, 0.0f
        };
        
        redBarrel = [[UIImageView alloc] initWithFrame:frame];
        
        redBarrel.image = [UIImage imageNamed:@"barrel_red.png"];
        
        redBarrel.autoresizingMask = UIViewAutoresizingNone;
        
        redBarrel.clipsToBounds = YES;
        
        redBarrel.contentMode = UIViewContentModeBottom;
        
        redBarrel.tag = RedBarrelTag;
        
        [cell.imageView addSubview:redBarrel];
    }
    
    redBarrel = (id)[cell.imageView viewWithTag:RedBarrelTag];
    
    Barrel *barrel = [self.barrels objectAtIndex:indexPath.row];
    
    Trackable *trackable = [Model loadModelForKey:barrel.trackableKey];
    
    double capacity = 0.0f;
    NSString *vintage = @"";
    const char *str = "";
    
    if(trackable.vintage.length) {
        
        vintage = trackable.vintage;
        str = " ";
    }
    
    if(trackable.volume.doubleValue > 0.0)
        capacity = trackable.volume.doubleValue / barrel.volume.doubleValue;
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%.0f Gallons)%s%@",
                           barrel.name, barrel.volume.doubleValue, str, vintage];
    
    cell.imageView.image = [UIImage imageNamed:@"barrel.png"];
    
    redBarrel.frame = (CGRect)
    {
        0, (1 - capacity) * cell.imageView.frame.size.height,
        cell.imageView.frame.size.width, capacity * cell.imageView.frame.size.height
    };
    
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
    
    self.capacityByIndexPath = [@{} mutableCopy];
    
    self.title = @"Vintage";
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(reloadBarrels)
     name:ModelBackendKeysUpdated
     object:nil];
}

@end
