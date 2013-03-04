//
//  SourceListViewController.m
//  Vintage
//
//  Created by Dustin Dettmer on 3/3/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import "SourceListViewController.h"
#import "SourceViewController.h"
#import "SourceStatusViewController.h"
#import "ModelBackend.h"

@interface SourceListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *sources;

@end

@implementation SourceListViewController

#ifdef APPORTABLE
- (id)init
{
    self = [super initWithNibName:[[[self class] description] stringByAppendingString:@"Android"] bundle:nil];
    
    return self;
}
#endif

- (IBAction)addSource:(id)sender {
    
    SourceViewController *controller = [SourceViewController new];
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)loadSources
{
    self.sources = [Model loadModels:[Source class]];
}

- (void)viewWillAppear:(BOOL)animated
{
    BOOL firstTime = self.sources == nil;
    
    [self loadSources];
    
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
    
    cell.textLabel.text = [[self.sources objectAtIndex:indexPath.row] name];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SourceStatusViewController *controller = [SourceStatusViewController new];
    
    controller.source = [self.sources objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)backendKeysUpdated
{
    [self loadSources];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(backendKeysUpdated)
     name:ModelBackendKeysUpdated
     object:nil];
}

@end
