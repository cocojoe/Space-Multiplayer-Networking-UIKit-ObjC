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
#import "PlanetBuildingViewController.h"
#import "PlanetResearchViewController.h"

// Modals
#import "PlanetViewController.h"

// Game Manager Singleton
#import "GameManager.h"

#define TAG_PLANET_PLANETS_VIEW     1
#define TAG_PLANET_BUILDING_VIEW    2
#define TAG_PLANET_RESEARCH_VIEW    3

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
    
    // Add Planet Building Controller 
    _planetBuildingViewController = [[PlanetBuildingViewController alloc] initWithNibName:@"PlanetBuildingViewController" bundle:nil];
    [self.view insertSubview:_planetBuildingViewController.view belowSubview:_planetOverviewViewController.view];
    
    // Add Research Building Controller
    _planetResearchViewController = [[PlanetResearchViewController alloc] initWithNibName:@"PlanetResearchViewController" bundle:nil];
    [self.view insertSubview:_planetResearchViewController.view belowSubview:_planetOverviewViewController.view];
    
    // Set View Reference
    [self setCurrentView:_planetResearchViewController.view];
    
    // Default Selection
    [_customTabBar setSelectedItem:[_customTabBar.items objectAtIndex:0]];
    
    [self setPlanetOverviewController];

    // Ensure Tab Bar
    [self.view bringSubviewToFront:_customTabBar];
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
    [self transitionToView:_planetOverviewViewController.view];
    [_planetOverviewViewController refreshData];

    // Select Planet Option
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:_planetOverviewViewController action:@selector(showPlanetList)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor blueColor];
    
    // Set View Reference
    [self setCurrentView:_planetOverviewViewController.view];
}

-(void) setPlanetBuildingController
{
    
    self.navigationItem.title = _planetBuildingViewController.title;
    [self transitionToView:_planetBuildingViewController.view];
    [_planetBuildingViewController refreshData];
    //[[self navigationItem] setRightBarButtonItem:nil];
    
    // Set View Reference
    [self setCurrentView:_planetBuildingViewController.view];
   
}

-(void) setPlanetResearchController
{
    
    self.navigationItem.title = _planetResearchViewController.title;
    [self transitionToView:_planetResearchViewController.view];
    [_planetResearchViewController refreshData];
    //[[self navigationItem] setRightBarButtonItem:nil];
    
    // Set View Reference
    [self setCurrentView:_planetResearchViewController.view];
}

-(void) transitionToView:(UIView*) viewTo
{
    [UIView transitionFromView:_currentView
                        toView:viewTo
                      duration:0.25f
                       options:UIViewAnimationOptionShowHideTransitionViews | UIViewAnimationOptionTransitionCrossDissolve
                    completion:^(BOOL finished){
                    }];
}

#pragma mark UITabBar Delegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    switch(item.tag)
    {
        case TAG_PLANET_PLANETS_VIEW:
            [self setPlanetOverviewController];
            break;
        case TAG_PLANET_BUILDING_VIEW:
            [self setPlanetBuildingController];
            break;
        case TAG_PLANET_RESEARCH_VIEW:
            [self setPlanetResearchController];
            break;

    }
    
    // Ensure Tab Bar
    [self.view bringSubviewToFront:_customTabBar];
}

@end
