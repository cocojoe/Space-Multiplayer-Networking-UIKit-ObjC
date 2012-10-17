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

#pragma mark Manual Creation
- (id)initWithTitle:(NSString *)title;

#pragma mark Data Processing
-(void) refreshData;

@end

