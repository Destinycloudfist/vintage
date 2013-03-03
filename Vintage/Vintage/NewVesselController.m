//
//  NewVesselController.m
//  Vintage
//
//  Created by Dustin Dettmer on 3/3/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import "NewVesselController.h"
#import "BottlesViewController.h"
#import "TankViewController.h"
#import "BarrelViewController.h"

@interface NewVesselController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation NewVesselController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableCiewCell"];
    
    if(!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableCiewCell"];
    
    if(indexPath.row == 0)
        cell.textLabel.text = @"New Barrel";
    if(indexPath.row == 1)
        cell.textLabel.text = @"New Tank";
    if(indexPath.row == 2)
        cell.textLabel.text = @"New Bottles";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *controller = nil;
    
    if(indexPath.row == 0)
        controller = [BarrelViewController new];
    
    if(indexPath.row == 1)
        controller = [TankViewController new];
    
    if(indexPath.row == 2)
        controller = [BottlesViewController new];
    
    [self.navigationController pushViewController:controller animated:YES];
}

@end
