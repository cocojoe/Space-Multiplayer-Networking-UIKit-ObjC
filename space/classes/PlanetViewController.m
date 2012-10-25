//
//  PlanetViewController.m
//  space
//
//  Created by Martin Walsh on 24/10/2012.
//  Copyright (c) 2012 Pedro LTD. All rights reserved.
//

#import "PlanetViewController.h"
#import "GameManager.h"

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
    
    // Navigation
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_menu.png"] style:UIBarButtonItemStylePlain target:self.navigationController.parentViewController action:@selector(dismissModalViewControllerAnimated:)];
    
    // Create Pull Loader
    _pull = [[PullToRefreshView alloc] initWithScrollView:(UIScrollView *) self.tableView];
    [_pull setDelegate:self];
    [self.tableView addSubview:_pull];
    
}

// For example after a modal is dimissed (that may have refreshed player)
-(void) viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self refreshData];
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
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
    
    // Populate Cell
    NSDictionary* cellDict  = [_planets objectAtIndex:indexPath.row];
    cell.textLabel.text     = [cellDict objectForKey:@"name"];
    
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
    NSDictionary* planetDict = [_planets objectAtIndex:indexPath.row];
    
    // Set Game Manager Planet
    [[GameManager sharedInstance] setPlanetID:[[planetDict objectForKey:@"id"] integerValue]];
    
    // Refresh Planet
    [[NSNotificationCenter defaultCenter] postNotificationName:@"planetRefresh" object:self];
    
    // Dismiss
    [self dismissModalViewControllerAnimated:YES];

}

@end
