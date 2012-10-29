//
//  BuildingSelectionTableViewController.m
//  space
//
//  Created by Martin Walsh on 26/10/2012.
//  Copyright (c) 2012 Pedro LTD. All rights reserved.
//

#import "BuildingSelectionTableViewController.h"
#import "BuildingCell.h"
#import "BuildingBuildView.h"
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
    return 47;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"BuildingCell";
    BuildingCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[BuildingCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    //[cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
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
    // Create Popup
    [self createBuildingPopup:[_buildingsFiltered objectAtIndex:indexPath.row]];
}

#pragma mark Building Popup
-(void) createBuildingPopup:(NSDictionary*) buildingDict
{
    // Create Grey Background
    UIView *dimBackgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    dimBackgroundView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.75f];
    [self.view addSubview:dimBackgroundView];
    
    // Disable Scroll
    //[self.view setUserInteractionEnabled:NO];
    
    // Create Building Build View
    BuildingBuildView *buildingPopup = [[[NSBundle mainBundle] loadNibNamed:@"BuildingBuildView" owner:self options:nil] objectAtIndex:0];
    [buildingPopup setCenter:CGPointMake(self.view.bounds.size.width*0.5f, (self.view.bounds.size.height*0.5f)+self.tableView.contentOffset.y)];
    [self.view addSubview:buildingPopup];

    
    // Populate Cell
    [buildingPopup refresh:buildingDict];

}

@end
