//
//  PlanetOverviewViewController.h
//  space
//
//  Created by Martin Walsh on 25/10/2012.
//  Copyright (c) 2012 Pedro LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullToRefreshView.h"

@interface PlanetOverviewViewController : UIViewController <PullToRefreshViewDelegate>

@property (nonatomic) UIScrollView* mainScrollView;

@property (nonatomic) IBOutlet UILabel* planetName;

#pragma mark Data Processing
-(void) refreshData;

#pragma mark Navigation Extras
-(void) showPlanetList;

@end
