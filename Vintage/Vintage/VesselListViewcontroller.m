//
//  VesselListViewcontroller.m
//  Vintage
//
//  Created by Dustin Dettmer on 3/3/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import "VesselListViewcontroller.h"
#import "Barrel.h"
#import "Bottles.h"
#import "Tank.h"

@interface VesselListViewcontroller ()

@property (nonatomic, strong) NSArray *vessels;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation VesselListViewcontroller

- (void)viewWillAppear:(BOOL)animated
{
    BOOL firstTime = self.vessels == nil;
    
    NSMutableArray *array = [@[] mutableCopy];
    
    id items = [Model loadModelsForClasses:@[[Barrel class], [Bottles class], [Tank class]]];
    
    for(Vessel *vessel in items)
        if(![self.excludeKeys containsObject:vessel.key])
            [array addObject:vessel];
    
    self.vessels = array;
    
    if(!firstTime)
        [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.vessels.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    if(!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    
    Vessel *vessel = [self.vessels objectAtIndex:indexPath.row];
    
    NSString *name = [[vessel class] description];
    
    if([vessel respondsToSelector:@selector(name)])
       name = [(id)vessel name];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %.0f Gallons", name, vessel.volume.doubleValue];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate vesselList:self selectedVessel:[self.vessels objectAtIndex:indexPath.row]];
}

@end
