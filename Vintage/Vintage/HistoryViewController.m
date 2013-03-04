//
//  HistoryViewController.m
//  Vintage
//
//  Created by Philippe Hausler on 3/3/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import "HistoryViewController.h"
#import "Vessel.h"
#import "Bottles.h"
#import "Barrel.h"
#import "Tank.h"


@interface HistoryViewController ()
@property (nonatomic, strong) NSMutableArray *historyData;
@property (nonatomic, strong) Trackable *trackable;
@end

@implementation HistoryViewController

+ (HistoryViewController *)history:(Trackable *)trackable
{
    return [[HistoryViewController alloc] initWithTrackable:trackable];
}

- (id)initWithTrackable:(Trackable *)trackable
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self)
    {
        self.historyData = [[NSMutableArray alloc] init];
        self.trackable = trackable;
    }
    return self;
}

- (void)dealloc
{
    self.historyData = nil;
#if !__has_feature(objc_arc)
    [super dealloc]; // it makes me feel better
#endif
}

- (void)reloadData
{
    [self.historyData removeAllObjects];
    Trackable *item = self.trackable;
    while (item != NULL)
    {
        [self.historyData addObject:item];
        if ([item.sourceKeys count] > 0)
        {
            item = (Trackable *)[Model loadModelForKey:item.sourceKeys[0]];
        }
        else
        {
            break;
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.historyData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Trackable *item = (Trackable *)[self.historyData objectAtIndex:[indexPath indexAtPosition:1]];
    
    Vessel *vessel = (Vessel *)[Model loadModelForKey:item.vesselKey];
    
    if ([vessel isKindOfClass:[Bottles class]])
    {
        cell.textLabel.text = @"Bottled";
    }
    else if ([vessel isKindOfClass:[Barrel class]])
    {
        cell.textLabel.text = [(Barrel *)vessel name];
    }
    else if ([vessel isKindOfClass:[Tank class]])
    {
        cell.textLabel.text = [(Tank *)vessel name];
    }
    
    cell.detailTextLabel.text = [item.date description];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
