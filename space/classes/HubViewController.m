//
//  HubViewController.m
//  space
//
//  Created by Martin Walsh on 09/10/2012.
//  Copyright (c) 2012 Pedro LTD. All rights reserved.
//

#import "HubViewController.h"
#import "ZUUIRevealController.h"

// Game Manager Singleton 
#import "GameManager.h"

// Tab Views
#import "PlayerViewController.h"
#import "HangarViewController.h"

@interface HubViewController ()

@end

@implementation HubViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

/*
 * The following lines are crucial to understanding how the ZUUIRevealController works.
 *
 * In this example, the FrontViewController is contained inside of a UINavigationController.
 * And the UINavigationController is contained inside of a ZUUIRevealController. Thus the
 * following hierarchy is created:
 *
 * - ZUUIRevealController is parent of:
 * - - UINavigationController is parent of:
 * - - - FrontViewController
 *
 * If you don't want the UINavigationController in between (which is totally fine) all you need to
 * do is to adjust the if-condition below in a way to suit your needs. If the hierarchy were to look
 * like this:
 *
 * - ZUUIRevealController is parent of:
 * - - FrontViewController
 *
 * Without a UINavigationController in between, you'd need to change:
 * self.navigationController.parentViewController TO: self.parentViewController
 *
 * Note that self.navigationController is equal to self.parentViewController. Thus you could generalize
 * the code even more by calling self.parentViewController.parentViewController. In order to make
 * the code easier to understand I decided to go with self.navigationController.
 *
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = NSLocalizedString(@"PlayerTitleKey", @"");
	
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
    
    // Add Player Controller (Default)
    NSString *controllerTitle = NSLocalizedString(@"PlayerTitleKey", @"");
    _playerViewController = [[PlayerViewController alloc] initWithTitle:controllerTitle];
    [self.view insertSubview:_playerViewController.view belowSubview:_customTabBar];
    [_customTabBar setSelectedItem:[_customTabBar.items objectAtIndex:0]];
    
    // Add Hangar Controller
    controllerTitle = NSLocalizedString(@"HangarTitleKey", @"");
    _hangarViewController = [[HangarViewController alloc] initWithTitle:controllerTitle];
    [self.view insertSubview:_hangarViewController.view belowSubview:_playerViewController.view];

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

#pragma mark UITabBar Delegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{

    switch(item.tag)
    {
        case TAG_PLAYER_VIEW:
            //CCLOG(@"Activate Player View");
            [self.view bringSubviewToFront:_playerViewController.view];
            self.navigationItem.title = _playerViewController.title;
            [_playerViewController refreshData];
            break;
        case TAG_HANGAR_VIEW:
            //CCLOG(@"Activate Hangar View");
            [self.view bringSubviewToFront:_hangarViewController.view];
            self.navigationItem.title = _hangarViewController.title;
            break;
    }
    
    // Ensure Tab Bar
    [self.view bringSubviewToFront:_customTabBar];
}

@end
