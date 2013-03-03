//
//  SourceListViewController.m
//  Vintage
//
//  Created by Dustin Dettmer on 3/3/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import "SourceListViewController.h"
#import "SourceViewController.h"

@interface SourceListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *sources;

@end

@implementation SourceListViewController

- (IBAction)addSource:(id)sender {
    
    SourceViewController *controller = [SourceViewController new];
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    BOOL firstTime = self.sources == nil;
    
    self.sources = [Model loadModels:[Source class]];
    
    if(!firstTime)
        [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sources.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    if(!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    
    cell.textLabel.text = [[self.sources objectAtIndex:indexPath.row] prettyDescription];
    
    return cell;
}

@end
