//
//  PlanetHubViewController.h
//  space
//
//  Created by Martin Walsh on 25/10/2012.
//  Copyright (c) 2012 Pedro LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PlanetOverviewViewController;
@class PlanetBuildingViewController;
@class PlanetResearchViewController;

@interface PlanetHubViewController : UIViewController <UITabBarDelegate>

@property (nonatomic) IBOutlet UITabBar* customTabBar;

// Controllers
@property (nonatomic) PlanetOverviewViewController* planetOverviewViewController;
@property (nonatomic) PlanetBuildingViewController* planetBuildingViewController;
@property (nonatomic) PlanetResearchViewController* planetResearchViewController;

// Current 'View'
@property (nonatomic,weak) UIView* currentView;


@end
