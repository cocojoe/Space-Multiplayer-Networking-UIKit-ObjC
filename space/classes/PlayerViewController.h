//
//  TabBarItemViewController.h
//  SimpleTabBarApp
//
//  Created by Deminem on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullToRefreshView.h"

@interface PlayerViewController : UIViewController <PullToRefreshViewDelegate>

@property (nonatomic) UIScrollView* mainScrollView;

// Player Profile
@property (nonatomic) IBOutlet UILabel *labelPlayerName;
@property (nonatomic) IBOutlet UILabel *labelPlayerScore;
@property (nonatomic) IBOutlet UILabel *labelPlayerCurrencyCash;
@property (nonatomic) IBOutlet UILabel *labelPlayerCurrencyPremium;

// Player Equipment
// Head
@property (nonatomic) IBOutlet UILabel *labelPlayerEquipmentHead;
@property (nonatomic) IBOutlet UILabel *labelPlayerEquipmentHeadDescription;
@property (nonatomic) IBOutlet UIImageView *imagePlayerEquipmentHead;

// Hands
@property (nonatomic) IBOutlet UILabel *labelPlayerEquipmentHands;
@property (nonatomic) IBOutlet UILabel *labelPlayerEquipmentHandsDescription;
@property (nonatomic) IBOutlet UIImageView *imagePlayerEquipmentHands;

#pragma mark Manual Creation
- (id)initWithTitle:(NSString *)title;

#pragma mark Data Processing
-(void) refreshData;

@end

