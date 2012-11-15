//
//  AppDelegate.m
//  space
//
//  Created by Martin Walsh on 09/10/2012.
//  Copyright (c) 2012 Pedro LTD. All rights reserved.
//

#import "cocos2d.h"

#import "AppDelegate.h"

// Master
#import "MasterViewController.h"

// Default Views
#import "MenuViewController.h"
#import "HubViewController.h"

// Singletons
#import "GameManager.h"
#import "SimpleAudioEngine.h"

// Loader
#import "LoginViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Cocos2D/3D Setup Director
    [CCDirector setDirectorType: kCCDirectorTypeDisplayLink];
    CCTexture2D.defaultAlphaPixelFormat = kCCTexture2DPixelFormat_RGBA8888;
    
    CCDirector *director      = CCDirector.sharedDirector;
    director.runLoopCommon    = YES;		// Improves display link integration with UIKit
    director.animationInterval = (1.0f / kAnimationFrameRate);
    director.displayFPS = YES; // Crashes on Second Opening

    // Initalise Game Manager
    [GameManager sharedInstance];
    
    // Initialise Default Views for Master
    MenuViewController* menuViewController = [[MenuViewController alloc] init];
   
    
    HubViewController* hubViewController = [[HubViewController alloc] init];
    
    // Create Navigation Controller from Hub - See HubViewController for Explanation (ZUUIReveal)
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:hubViewController];
    
    // Master Controller
    MasterViewController* masterViewController = [[MasterViewController alloc] initWithFrontViewController:navigationController rearViewController:menuViewController];
    self.viewController = masterViewController;
    
    [[GameManager sharedInstance] setView:masterViewController];

    // Override point for customization after application launch.
    self.window.rootViewController = self.viewController; // Set Login
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    // Initialise Sound Engine
    //[CDSoundEngine setMixerSampleRate:32000];
	//[SimpleAudioEngine sharedEngine];
    
    // Login
    [[GameManager sharedInstance] loginStart];
    
    // Reset Badges
    application.applicationIconBadgeNumber = 0;
    
    return YES;

}

- (void)application:(UIApplication *)app didReceiveLocalNotification:(UILocalNotification *)notif {
    
    if([[notif alertBody] isEqualToString:_lastNotification])
        return;
    
    UIApplicationState state = [app applicationState];
    if (state == UIApplicationStateActive) {
        CCLOG(@"Notification UIApplicationStateActive: %@",notif);
        // Alert Popup
        [[GameManager sharedInstance] createNotificationPopup:[notif alertBody]];
    }
    else if(state == UIApplicationStateInactive){
        CCLOG(@"Notification UIApplicationStateInActive: %@",notif);
    }
    
    // Set Last Notification (Hack for Dupe Alerts, Known Bug in 2010?!)
    _lastNotification = [notif alertBody];
}

-(void) applicationDidReceiveMemoryWarning: (UIApplication*) application {
	[CCDirector.sharedDirector purgeCachedData];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [CCDirector.sharedDirector stopAnimation];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [CCDirector.sharedDirector startAnimation];
    
    // Reset Badges
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [CCDirector.sharedDirector.openGLView removeFromSuperview];
	[CCDirector.sharedDirector end];
}

-(void) applicationSignificantTimeChange: (UIApplication*) application {
	[CCDirector.sharedDirector setNextDeltaTimeZero: YES];
}

@end
