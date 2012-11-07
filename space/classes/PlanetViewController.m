//
//  PlanetViewController.m
//  space
//
//  Created by Martin Walsh on 24/10/2012.
//  Copyright (c) 2012 Pedro LTD. All rights reserved.
//

#import "PlanetViewController.h"
#import "GameManager.h"

// Custom Cell
#import "PlanetTableCell.h"

@interface PlanetViewController ()

@end

@implementation PlanetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _planets         = [[NSMutableArray alloc] init];
        _planetsGrouped  = [[NSMutableDictionary alloc] init];
        self.title       = NSLocalizedString(@"PlanetSelectionTitleKey", @"");
        [self setupNotification];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Nav Style
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    
    // Navigation (Only Show if We Have A Planet)
    if([[GameManager sharedInstance] planetID])
    {
        // Navigation
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self.navigationController.parentViewController action:@selector(dismissModalViewControllerAnimated:)];
        
        self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];

    }
    
    // Set Background
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_space.jpg"]];
    self.tableView.backgroundView = imageView;
    
    // Create Pull Loader
    _pull = [[PullToRefreshView alloc] initWithScrollView:(UIScrollView *) self.tableView];
    [_pull setDelegate:self];
    [self.tableView addSubview:_pull];
    
}

#pragma mark Data Processing
-(void) refreshData
{
    [[GameManager sharedInstance] refreshPlanets:^(NSDictionary *jsonDict){
        
        // Assign Inventory JSON
        _planets = [jsonDict objectForKey:@"planets"];
        
        [self defaultFilter];
    }];
}

#pragma mark Search Helpers
-(void) defaultFilter
{
    // Process Data
    // Create 'System' Groups
    [self createGrouped];
    
    [self.tableView reloadData];
}

-(void) createGrouped {
    
    /* Interesting Way For Counting
     NSCountedSet * countedSet = [[NSCountedSet alloc]init];
     [countedSet addObject:[[itemDict objectForKey:@"system"] objectForKey:@"name"]];
     [countedSet allObjects]
     [countedSet countForObject:countryName]
    */
    
    [_planetsGrouped removeAllObjects];

    for (NSDictionary* itemDict in _planets ) {
        NSMutableArray* tempArray = [_planetsGrouped objectForKey:[[itemDict objectForKey:@"system"] objectForKey:@"name"]];
        if(tempArray==nil)
        {
            tempArray = [NSMutableArray array];
            [_planetsGrouped setObject:tempArray forKey:[[itemDict objectForKey:@"system"] objectForKey:@"name"]];
        }
        [tempArray addObject:itemDict];
    
    }
    
    _planetGroupList = [[_planetsGrouped allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];

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
    return [_planetGroupList count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [_planetGroupList objectAtIndex:section];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[_planetsGrouped objectForKey:[_planetGroupList objectAtIndex:section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PlanetTableCell";
    PlanetTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[PlanetTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Disable Selection Highlight
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    NSString * systemName    = [_planetGroupList objectAtIndex:indexPath.section];
    NSArray *systemPlanets   = [_planetsGrouped objectForKey:systemName];
    NSDictionary *planetDict = [systemPlanets objectAtIndex:indexPath.row];
    
    // Populate Cell
    [cell refresh:planetDict];


    return cell;
}

// Colour Currently Selected Cell
/*
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if([[[_planets objectAtIndex:indexPath.row] objectForKey:@"id"] intValue] == [[GameManager sharedInstance] planetID])
    {
        cell.backgroundColor = [UIColor colorWithRed:6/255.0f green:50/255.0f blue:65/255.0f alpha:0.7f];
    }

}
*/

// Table Size (Custom Cell)
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
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
    NSString * systemName    = [_planetGroupList objectAtIndex:indexPath.section];
    NSArray *systemPlanets   = [_planetsGrouped objectForKey:systemName];
    NSDictionary *planetDict = [systemPlanets objectAtIndex:indexPath.row];
    
    // Set Game Manager Planet
    [[GameManager sharedInstance] setPlanet:[[planetDict objectForKey:@"id"] intValue]];
    
    // Refresh Views
    [[NSNotificationCenter defaultCenter] postNotificationName:@"planetRefresh" object:self];
    
    // Dismiss
    [self dismissModalViewControllerAnimated:YES];

}

- (void) dealloc
{
    // If you don't remove yourself as an observer, the Notification Center
    // will continue to try and send notification objects to the deallocated
    // object.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
