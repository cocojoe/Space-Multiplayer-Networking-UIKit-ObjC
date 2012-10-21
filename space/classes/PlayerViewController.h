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
@class PlayerPartsView;

@interface PlayerViewController : UIViewController <PullToRefreshViewDelegate>

@property (nonatomic) UIScrollView* mainScrollView;

// Custom Views
@property (nonatomic) IBOutlet PlayerProfileView* playerProfileView;
@property (nonatomic) IBOutlet PlayerPartsView* partsProfileView;


#pragma mark Manual Creation
- (id)initWithTitle:(NSString *)title;

#pragma mark Data Processing
-(void) refreshData;

@end

