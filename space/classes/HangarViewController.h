//
//  TabBarItemViewController.h
//  SimpleTabBarApp
//
//  Created by Deminem on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullToRefreshView.h"


@interface HangarViewController : UIViewController <PullToRefreshViewDelegate>

@property (nonatomic) UIScrollView* mainScrollView;
@property (nonatomic) IBOutlet UILabel* test;

#pragma Public Creation
- (id)initWithTitle:(NSString *)title;

@end

