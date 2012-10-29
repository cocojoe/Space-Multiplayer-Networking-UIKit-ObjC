//
//  BuildingSelectionTableViewController.m
//  space
//
//  Created by Martin Walsh on 26/10/2012.
//  Copyright (c) 2012 Pedro LTD. All rights reserved.
//

#import "BuildingSelectionTableViewController.h"
#import "BuildingCell.h"
#import "GameManager.h"

@interface BuildingSelectionTableViewController ()

@end

@implementation BuildingSelectionTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _buildingsAllowed  = [[NSMutableArray alloc] init];
        _buildingsFiltered = [[NSMutableArray alloc] init];
        self.title         = NSLocalizedString(@"BuildingSelectionTitleKey", @"");
        [self setupNotification];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    // Nav Style
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    
    // Navigation
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self.navigationController.parentViewController action:@selector(dismissModalViewControllerAnimated:)];
    
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor redColor];
    
    // Create Pull Loader
    _pull = [[PullToRefreshView alloc] initWithScrollView:(UIScrollView *) self.tableView];
    [_pull setDelegate:self];
    [self.tableView addSubview:_pull];

}

#pragma mark Data Processing
-(void) refreshData
{
    [[GameManager sharedInstance] refreshBuildingsAllowed:^(NSDictionary *jsonDict){
        
        // Assign Inventory JSON
        _buildingsAllowed = [jsonDict objectForKey:@"buildings"];
        
        [self defaultFilter];
    }];

}

#pragma mark Search Helpers
-(void) defaultFilter
{

    // Clear Filter
    [_buildingsFiltered removeAllObjects];
    
    // ReBuild Inventory - Attach Item/Group Details
    for(NSDictionary* building in [[GameManager sharedInstance] masterBuildingList])
    {
        for(NSNumber* buildingID in _buildingsAllowed)
        {
            if([[building objectForKey:@"id"] integerValue]==[buildingID integerValue])
                [_buildingsFiltered addObject:building];
        }
    }
    
    [self.tableView reloadData];
}

// For example after a modal is dimissed (that may have refreshed player)
-(void) viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self refreshData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [_buildingsFiltered count];
}

// Table Size (Custom Cell)
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"BuildingCell";
    BuildingCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[BuildingCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    //[cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
    
    // Populate Cell
    [cell refresh:[_buildingsFiltered objectAtIndex:indexPath.row]];
    
     return cell;
}

#pragma mark Rotation Fix
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    BOOL shouldAutorotate = NO;
    
    if (interfaceOrientation == UIInterfaceOrientationPortrait
        || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        
        shouldAutorotate = YES;
    }
    
    return shouldAutorotate;
}


#pragma mark Pull To Refresh Delegate Methods
- (void)pullToRefreshViewShouldRefresh:(PullToRefreshView *)view;
{
    [self refreshData];
}

#pragma mark Notification Handling
-(void) setupNotification
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:@"cancelPullDown"
                                               object:nil];
}

- (void) handleNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"cancelPullDown"])
    {
        // Cancel Refresh
        [_pull finishedLoading];
    }
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
