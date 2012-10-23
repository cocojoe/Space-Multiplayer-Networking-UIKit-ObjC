//
//  TabBarItemViewController.h
//  SimpleTabBarApp
//
//  Created by Deminem on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullToRefreshView.h"

@class PlayerProfileView;

@interface PlayerViewController : UIViewController <PullToRefreshViewDelegate>

@property (nonatomic) UIScrollView* mainScrollView;

// Custom IBOutlet Views
@property (nonatomic) IBOutlet PlayerProfileView* playerProfileView;

#pragma mark Manual Creation
- (id)initWithTitle:(NSString *)title;

#pragma mark Data Processing
-(void) refreshData;

@end

