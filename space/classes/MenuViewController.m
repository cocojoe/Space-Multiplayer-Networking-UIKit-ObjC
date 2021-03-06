//
//  MenuViewController.m
//  space
//
//  Created by Martin Walsh on 09/10/2012.
//  Copyright (c) 2012 Pedro LTD. All rights reserved.
//

#import "MenuViewController.h"

#import "MasterViewController.h"
#import "HubViewController.h"
#import "InventoryViewController.h"
#import "PlanetHubViewController.h"

#import "CC3DRevealViewController.h"
#import "Planet3DScene.h"
#import "Planet3DLayer.h"

// Various Object Definition(s)
#import "MenuObject.h"

#define MENU_HUB            0
#define MENU_PLANET         1
#define MENU_INVENTORY      2
#define MENU_TEST           3

@interface MenuViewController ()

@end

@implementation MenuViewController

@synthesize menuList = _menuList;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
        // Correct Size (Was Redundant To Space on iOS5)
        //self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
         //self.navigationItem.title = NSLocalizedString(@"MenuTitleKey", @"");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    // Menu Data
    [self createMenuArray];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Menu Data Management
-(void) createMenuArray
{
    // Menu Array
    _menuList = [[NSMutableArray alloc] init];
    MenuObject* menuItem;
    
    // Home
    menuItem = [[MenuObject alloc] init];
    [menuItem setIconName:@"icon_home.png"];
    [menuItem setName:NSLocalizedString(@"PlayerTitleKey", @"")];
    [_menuList addObject:menuItem];
    
    // Planet
    menuItem = [[MenuObject alloc] init];
    [menuItem setIconName:@"icon_planet.png"];
    [menuItem setName:NSLocalizedString(@"PlanetTitleKey", @"")];
    [_menuList addObject:menuItem];
    
    // Inventory
    menuItem = [[MenuObject alloc] init];
    [menuItem setIconName:@"icon_inventory.png"];
    [menuItem setName:NSLocalizedString(@"InventoryTitleKey", @"")];
    [_menuList addObject:menuItem];
    
    // 3D Controller TEST
    menuItem = [[MenuObject alloc] init];
    [menuItem setIconName:@"icon_planet.png"];
    [menuItem setName:NSLocalizedString(@"3DTESTTitleKey", @"")];
    [_menuList addObject:menuItem];
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
    return [_menuList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    MenuObject* menuItem = [_menuList objectAtIndex:indexPath.row];
    cell.textLabel.text = [menuItem name];
    cell.imageView.image = [UIImage imageNamed:[menuItem iconName]];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    // Grab a handle to the master controller, as if you'd do with a navigtion controller via self.navigationController.
	MasterViewController *masterController = [self.parentViewController isKindOfClass:[MasterViewController class]] ? (MasterViewController *)self.parentViewController : nil;
    
    // Bit Lazy
	if (indexPath.row == MENU_HUB) // Hub Controller
	{
		// Now let's see if we're not attempting to swap the current frontViewController for a new instance of ITSELF, which'd be highly redundant.
		if ([masterController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)masterController.frontViewController).topViewController isKindOfClass:[HubViewController class]])
		{
			HubViewController *viewController = [[HubViewController alloc] initWithNibName:@"HubViewController" bundle:nil];
			UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
			[masterController setFrontViewController:navigationController animated:YES];
			
		}
		// Seems the user attempts to 'switch' to exactly the same controller he came from!
		else
		{
			[masterController revealToggle:self];
		}
	} else if (indexPath.row == MENU_INVENTORY) // Inventory
	{
		// Now let's see if we're not attempting to swap the current frontViewController for a new instance of ITSELF, which'd be highly redundant.
		if ([masterController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)masterController.frontViewController).topViewController isKindOfClass:[InventoryViewController class]])
		{
			InventoryViewController *viewController = [[InventoryViewController alloc] initWithNibName:@"InventoryViewController" bundle:nil];
            
			UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
            
			[masterController setFrontViewController:navigationController animated:YES];
			
		}
		// Seems the user attempts to 'switch' to exactly the same controller he came from!
		else
		{
			[masterController revealToggle:self];
		}
	} else if (indexPath.row == MENU_PLANET) // Planet
	{
		// Now let's see if we're not attempting to swap the current frontViewController for a new instance of ITSELF, which'd be highly redundant.
		if ([masterController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)masterController.frontViewController).topViewController isKindOfClass:[PlanetHubViewController class]])
		{
			PlanetHubViewController *viewController = [[PlanetHubViewController alloc] initWithNibName:@"PlanetHubViewController" bundle:nil];
            
			UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
            
			[masterController setFrontViewController:navigationController animated:YES];
			
		}
		// Seems the user attempts to 'switch' to exactly the same controller he came from!
		else
		{
			[masterController revealToggle:self];
		}
	} else if (indexPath.row == MENU_TEST) // Test Controller
	{
		// Now let's see if we're not attempting to swap the current frontViewController for a new instance of ITSELF, which'd be highly redundant.
		if ([masterController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)masterController.frontViewController).topViewController isKindOfClass:[CC3DRevealViewController class]])
		{

            //CC3DRevealViewController *viewController = [CC3DRevealViewController controller];
            CC3DRevealViewController *viewController = [[CC3DRevealViewController alloc] initWithNibName:@"CC3DRevealViewController" bundle:nil];
            viewController.supportedInterfaceOrientations = UIInterfaceOrientationMaskPortrait;
            
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
            [masterController setFrontViewController:navigationController animated:YES];
            
            // Set GLView to This Controller View
            [[CCDirector sharedDirector] setOpenGLView:viewController.view];
            
            // 3D Setup
            // Create the customized CC3Layer that supports 3D rendering and schedule it for automatic updates.
            Planet3DLayer* cc3Layer = [Planet3DLayer node];
            [cc3Layer scheduleUpdate];
            
            // Create the customized 3D scene and attach it to the layer.
            // Could also just create this inside the customer layer.
            cc3Layer.cc3Scene = [Planet3DScene scene];
            
            // Assign to a generic variable so we can uncomment options below to play with the capabilities
            CC3ControllableLayer* mainLayer = cc3Layer;

            // Attach the layer to the controller and run a scene with it.
            [viewController runSceneOnNode: mainLayer];
            
            //UIImageView* image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_space.jpg"]];
            //[viewController.view addSubview:image];
			
		}
		// Seems the user attempts to 'switch' to exactly the same controller he came from!
		else
		{
			[masterController revealToggle:self];
		}
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    BOOL shouldAutorotate = NO;
    
    if (interfaceOrientation == UIInterfaceOrientationPortrait
        || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        
        shouldAutorotate = YES;
    }
    
    return shouldAutorotate;
}

@end
