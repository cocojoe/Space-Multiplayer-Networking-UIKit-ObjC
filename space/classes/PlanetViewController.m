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
    return [_planets count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PlanetTableCell";
    PlanetTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[PlanetTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Populate Cell
    [cell refresh:[_planets objectAtIndex:indexPath.row]];


    return cell;
}

// Colour Cell
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if([[[_planets objectAtIndex:indexPath.row] objectForKey:@"id"] intValue] == [[GameManager sharedInstance] planetID])
    {
        cell.backgroundColor = [UIColor colorWithRed:6/255.0f green:50/255.0f blue:65/255.0f alpha:0.7f];
    }

}

// Table Size (Custom Cell)
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
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
    NSDictionary* planetDict = [_planets objectAtIndex:indexPath.row];
    
    // Set Game Manager Planet
    [[GameManager sharedInstance] setPlanet:[[planetDict objectForKey:@"id"] intValue]];
    
    // Refresh Planet
    [[NSNotificationCenter defaultCenter] postNotificationName:@"planetRefresh" object:self];
    
    // Dismiss
    [self dismissModalViewControllerAnimated:YES];

}

@end
