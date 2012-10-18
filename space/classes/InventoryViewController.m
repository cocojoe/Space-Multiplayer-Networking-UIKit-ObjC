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
        _inventory = [[NSMutableArray alloc] init];
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
    
    self.title = NSLocalizedString(@"InventoryTitleKey", @"");
	
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
	}
    
    // Create Pull Loader
    _pull = [[PullToRefreshView alloc] initWithScrollView:(UIScrollView *) self.tableView];
    [_pull setDelegate:self];
    [self.tableView addSubview:_pull];
    
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
    //CCLOG(@"Inventory Row Count: %d",[_inventory count]);
    return [_inventory count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"InventoryCell";
    InventoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[InventoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary* cellDict  = [_inventory objectAtIndex:indexPath.row];

    // Name
    cell.labelName.text = [cellDict objectForKey:@"name"];
    
    // Description
    if([cellDict objectForKey:@"description"] == [NSNull null])
    {
        cell.labelDescription.text = [NSString stringWithFormat:@"\"%@\"",@"Describe Me!"];
    } else {
        cell.labelDescription.text = [NSString stringWithFormat:@"\"%@\"",[cellDict objectForKey:@"description"]];
    }
    
    // Description
    if([cellDict objectForKey:@"group_name"] == [NSNull null])
    {
        cell.labelGroup.text = @"Misc";
    } else {
        cell.labelGroup.text = [cellDict objectForKey:@"group_name"];
    }
    
    // Image
    if([cellDict objectForKey:@"icon"] != [NSNull null])
    {
        cell.imageIcon.image = [UIImage imageNamed:[cellDict objectForKey:@"icon"]];
    }

    
    // Amount
    cell.labelAmount.text = [NSString stringWithFormat:@"x %d",[[cellDict objectForKey:@"amount"] integerValue]];
    
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
    return 50;
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
    CCLOG(@"Inventory Item Selected");
}

#pragma mark Data Processing
-(void) refreshData
{
    
    [[GameManager sharedInstance] refreshInventory:^(NSDictionary *jsonDict){
        
        // Process JSON
        
        // Assign Inventory JSON
        _inventory = [jsonDict objectForKey:@"inventory"];
        
        //CCLOG(@"Inventory: %@",_inventory);
        
        // Refersh View
        [self.tableView reloadData];
        
        // Complete Loading
        [_pull finishedLoading];
    }];
    
}

#pragma mark Pull To Refresh Delegate Methods
- (void)pullToRefreshViewShouldRefresh:(PullToRefreshView *)view;
{
    [self refreshData];
}

@end
