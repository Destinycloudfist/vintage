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
#import "TankStatusViewController.h"
#import "BottlesStatusViewController.h"
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
    BOOL firstTime = self.barrels == nil;
    
    [self reloadBarrels];
    
#ifndef APPORTABLE
    if(firstTime) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self reloadBarrels];
        });
    }
#endif
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.barrels.count;
}

#ifndef APPORTABLE
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Vessel *vessel = [self.barrels objectAtIndex:indexPath.row];
    
    if([vessel isMemberOfClass:[Barrel class]])
        return 120.0f;
    
    if([vessel isMemberOfClass:[Tank class]])
        return 120.0f;
    
    return 88.0f;
}
#endif

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
        
#ifndef APPORTABLE
        redBarrel = [[UIImageView alloc] initWithFrame:frame];
        
        redBarrel.autoresizingMask = UIViewAutoresizingNone;
        
        redBarrel.clipsToBounds = YES;
        
        redBarrel.contentMode = UIViewContentModeBottom;
        
        redBarrel.tag = RedBarrelTag;
        
        [cell.imageView addSubview:redBarrel];
#endif
    }
    
    redBarrel = (id)[cell.imageView viewWithTag:RedBarrelTag];
    
    Vessel *barrel = [self.barrels objectAtIndex:indexPath.row];
    
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
    
    NSString *name = [[barrel class] description];
    
    if([barrel respondsToSelector:@selector(name)])
        name = [(id)barrel name];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%.0f%% %@ (%.0f Gallons)%s%@",
                           capacity * 100, name, barrel.volume.doubleValue, str, vintage];
    
#ifndef APPORTABLE
    BOOL showImage = YES;
    
    if([barrel isMemberOfClass:[Barrel class]])
    {
        cell.imageView.image = [UIImage imageNamed:@"barrel.png"];
        
        redBarrel.image = [UIImage imageNamed:@"barrel_red.png"];
    }
    else if([barrel isMemberOfClass:[Tank class]])
    {
        cell.imageView.image = [UIImage imageNamed:@"tank"];
        
        redBarrel.image = [UIImage imageNamed:@"tank_red.png"];
    }
    else {
        
        cell.imageView.image = nil;
        
        showImage = NO;
    }
    
    if(showImage) {
        
        redBarrel.hidden = NO;
        
        if(cell.imageView.frame.size.height > 0.0) {
            
            redBarrel.frame = (CGRect)
            {
                0, (1 - capacity) * cell.imageView.frame.size.height,
                cell.imageView.frame.size.width, capacity * cell.imageView.frame.size.height
            };
        }
    }
    else {
        
        redBarrel.hidden = YES;
    }
#endif
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Vessel *vessel = [self.barrels objectAtIndex:indexPath.row];
    
    if([vessel isMemberOfClass:[Barrel class]]) {
        
        BarrelStatusViewController *controller = [BarrelStatusViewController new];
        
        controller.barrel = (id)vessel;
        
        [self.navigationController pushViewController:controller animated:YES];
    }
    
    if([vessel isMemberOfClass:[Tank class]]) {
        
        TankStatusViewController *controller = [TankStatusViewController new];
        
        controller.tank = (id)vessel;
        
        [self.navigationController pushViewController:controller animated:YES];
    }
    
    if([vessel isMemberOfClass:[Bottles class]]) {
        
        BottlesStatusViewController *controller = [BottlesStatusViewController new];
        
//        controller.bottles = (id)vessel;
        
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)reloadBarrels
{
    self.barrels = [Model loadModelsForClasses:@[[Barrel class], [Tank class], [Bottles class]]];
    
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
