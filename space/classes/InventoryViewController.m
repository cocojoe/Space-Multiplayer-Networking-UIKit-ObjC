//
//  InventoryViewController.m
//  space
//
//  Created by Martin Walsh on 09/10/2012.
//  Copyright (c) 2012 Pedro LTD. All rights reserved.
//

#import "InventoryViewController.h"
#import "GameManager.h"

// Custom Cell
#import "InventoryCell.h"

@interface InventoryViewController ()

@end

@implementation InventoryViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _inventory         = [[NSMutableArray alloc] init];
        _inventoryAppended = [[NSMutableArray alloc] init];
        _inventoryFiltered = [[NSMutableArray alloc] init];
        _partID            = 0;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _inventory         = [[NSMutableArray alloc] init];
        _inventoryAppended = [[NSMutableArray alloc] init];
        _inventoryFiltered = [[NSMutableArray alloc] init];
        _partID            = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	// ZUUIRevealConbtroller (Master)
    // Add Reveal Actions (Button / Swipe)
	if ([self.navigationController.parentViewController respondsToSelector:@selector(revealGesture:)] && [self.navigationController.parentViewController respondsToSelector:@selector(revealToggle:)])
	{
        // Swipe/Pan Gesture
		UIPanGestureRecognizer *navigationBarPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
		[self.navigationController.navigationBar addGestureRecognizer:navigationBarPanGestureRecognizer];
		
        // Left Button
		self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_menu.png"] style:UIBarButtonItemStylePlain target:self.navigationController.parentViewController action:@selector(revealToggle:)];
        
        [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
        
        // Create Pull Loader
        _pull = [[PullToRefreshView alloc] initWithScrollView:(UIScrollView *) self.tableView];
        [_pull setDelegate:self];
        [self.tableView addSubview:_pull];
        
        self.title = NSLocalizedString(@"InventoryTitleKey", @"");
	} else if(_partID) { // Part Selection
        
        // Manually Presented Search
        _filterSearch.placeholder              = _searchText;
        _filterSearch.userInteractionEnabled   = NO;
        _filterSearch.hidden                   = YES;
        
        // Correct Size for Hidden Frame
        CGRect newBounds = self.tableView.bounds;
        newBounds.origin.y = newBounds.origin.y + _filterSearch.bounds.size.height;
        self.tableView.bounds = newBounds;
        _filterSearch.hidden                   = YES;
        
        // Part Selection Title
        self.title = [NSString stringWithFormat:@"Select %@ item",_searchText];
        
        // Nav Style
        [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
        
        // Navigation 
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_menu.png"] style:UIBarButtonItemStylePlain target:self.navigationController.parentViewController action:@selector(dismissModalViewControllerAnimated:)];
        
        // Clear Item If Currently Equipped
        if(_showRemove==YES) {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Remove" style:UIBarButtonItemStylePlain target:self action:@selector(clearItem)];
            
            self.navigationItem.rightBarButtonItem.tintColor = [UIColor redColor];
        }
    }
    
    // Grab Data
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
    return [_inventoryFiltered count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"InventoryCell";
    InventoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[InventoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Populate Cell
    NSDictionary* cellDict  = [_inventoryFiltered objectAtIndex:indexPath.row];
    [cell refresh:cellDict];
    
    
    return cell;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    BOOL shouldAutorotate = NO;
    
    if (interfaceOrientation == UIInterfaceOrientationPortrait
        || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        
        shouldAutorotate = YES;
    }
    
    return shouldAutorotate;
}

// Table Size (Custom Cell)
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark Item Management
-(void) clearItem {
    [[GameManager sharedInstance] clearPart:_partID setBlock:^(NSDictionary *jsonDict){
        
        // Force Refresh Player Cache
        [[NSNotificationCenter defaultCenter] postNotificationName:@"playerRefresh" object:self];
        
        // Dismiss
        [self dismissModalViewControllerAnimated:YES];
    }];

}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* itemDict = [_inventoryFiltered objectAtIndex:indexPath.row];
    
    if(_partID) {
        [[GameManager sharedInstance] setPart:_partID setItem:[[[itemDict objectForKey:@"item"] objectForKey:@"id"] integerValue] setBlock:^(NSDictionary *jsonDict){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"playerRefresh" object:self];
            
            // Dismiss
            [self dismissModalViewControllerAnimated:YES];
        }];
    }
    
}

#pragma mark Data Processing
-(void) refreshData
{
   
    [[GameManager sharedInstance] refreshInventory:^(NSDictionary *jsonDict){
        // Assign Inventory JSON
        _inventory = [jsonDict objectForKey:@"inventory"];
        
        [self defaultFilter];
        
        // Complete Loading
        [_pull finishedLoading];
    }];

}

#pragma mark Search Helpers
-(void) defaultFilter
{
    // ReBuild Inventory - Attach Item/Group Details
    for(NSDictionary* inventoryItem in _inventory)
    {
        NSDictionary* item      = [[[GameManager sharedInstance] masterItemList] objectAtIndex:[[inventoryItem objectForKey:@"item_id"] integerValue]-1];
        NSDictionary* itemGroup = [[[GameManager sharedInstance] masterGroupList] objectAtIndex:[[item objectForKey:@"group_id"] integerValue]-1];
        [_inventoryAppended addObject:[NSDictionary dictionaryWithObjectsAndKeys:item, @"item",
                                                                                 itemGroup, @"group",
                                                                                 [inventoryItem objectForKey:@"amount"], @"amount",nil]];
    }
    
    // Manual Search
    if([_searchText length]>0)
    {
        [self filterData:_searchText];
    } else {
        // Filter Inventory
        _inventoryFiltered = [NSMutableArray arrayWithArray:_inventoryAppended];
    }

    [self.tableView reloadData];
}

-(void) filterData:(NSString*) searchString {
    
    [_inventoryFiltered removeAllObjects];
    
    for (NSDictionary* inventoryItem in _inventoryAppended)
    {
        NSDictionary* item      = [inventoryItem objectForKey:@"item"];
        NSDictionary* itemGroup = [inventoryItem objectForKey:@"group"];
        
        NSRange nameSearch = [[item objectForKey:@"name"] rangeOfString:searchString options:NSCaseInsensitiveSearch];
        
        NSRange groupSearch = [[itemGroup objectForKey:@"name"] rangeOfString:searchString options:NSCaseInsensitiveSearch];
        
        if(nameSearch.location != NSNotFound ||
           groupSearch.location != NSNotFound)
        {
            [_inventoryFiltered addObject:inventoryItem];
        }
    }
}

#pragma mark Pull To Refresh Delegate Methods
- (void)pullToRefreshViewShouldRefresh:(PullToRefreshView *)view;
{
    [self refreshData];
}

#pragma mark - UISearchDisplayController Delegate Methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {

    [self filterData:searchString];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    CCLOG(@"searchDisplayControllerWillEndSearch");
    [self defaultFilter];
}

@end
