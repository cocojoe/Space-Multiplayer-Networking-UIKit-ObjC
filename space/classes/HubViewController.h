//
//  HubViewController.h
//  space
//
//  Created by Martin Walsh on 09/10/2012.
//  Copyright (c) 2012 Pedro LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PlayerViewController;
@class HangarViewController;
@class EquipmentViewController;

@interface HubViewController : UIViewController <UITabBarDelegate>

@property (nonatomic) IBOutlet UITabBar* customTabBar;

// Controllers
@property (nonatomic) PlayerViewController* playerViewController;
@property (nonatomic) HangarViewController* hangarViewController;
@property (nonatomic) EquipmentViewController* equipmentViewController;

@end
