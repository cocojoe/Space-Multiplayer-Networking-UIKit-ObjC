//
//  PlanetBuildingViewController.h
//  space
//
//  Created by Martin Walsh on 26/10/2012.
//  Copyright (c) 2012 Pedro LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullToRefreshView.h"
#import "PlanetDetailView.h"

@interface PlanetBuildingViewController : UIViewController <PullToRefreshViewDelegate>

@property (nonatomic) UIScrollView* mainScrollView;

#pragma mark Data Processing
-(void) refreshData;

#pragma mark Navigation Extras
-(void) showBuildingList;

@end
