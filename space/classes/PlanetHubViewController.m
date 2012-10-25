//
//  PlanetHubViewController.m
//  space
//
//  Created by Martin Walsh on 25/10/2012.
//  Copyright (c) 2012 Pedro LTD. All rights reserved.
//

#import "PlanetHubViewController.h"

// Sub Views
#import "PlanetOverviewViewController.h"

// Modals
#import "PlanetViewController.h"

// Game Manager Singleton
#import "GameManager.h"

#define TAG_PLANET_PLANETS_VIEW     1

@interface PlanetHubViewController ()

@end

@implementation PlanetHubViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = NSLocalizedString(@"PlanetTitleKey", @"");
	
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
    
    // Add Planet Controller (Default)
    _planetOverviewViewController = [[PlanetOverviewViewController alloc] initWithNibName:@"PlanetOverviewViewController" bundle:nil];
    [self.view insertSubview:_planetOverviewViewController.view belowSubview:_customTabBar];
    
    // Default Selection
    [_customTabBar setSelectedItem:[_customTabBar.items objectAtIndex:0]];
    
    [self setPlanetOverviewController];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    BOOL shouldAutorotate = NO;
    
    if (interfaceOrientation == UIInterfaceOrientationPortrait
        || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        
        shouldAutorotate = YES;
    }
    
    return shouldAutorotate;
}

-(void) setPlanetOverviewController
{

    self.navigationItem.title = _planetOverviewViewController.title;
    [_planetOverviewViewController refreshData];

    // Search Planet Option
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:_planetOverviewViewController action:@selector(showPlanetList)];
}

#pragma mark UITabBar Delegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    switch(item.tag)
    {
        case TAG_PLANET_PLANETS_VIEW:
            [self setPlanetOverviewController];
            break;
    }
    
    // Ensure Tab Bar
    [self.view bringSubviewToFront:_customTabBar];
}

@end
