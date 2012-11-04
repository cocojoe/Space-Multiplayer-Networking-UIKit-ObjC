//
//  PlanetBuildingViewController.h
//  space
//
//  Created by Martin Walsh on 26/10/2012.
//  Copyright (c) 2012 Pedro LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullToRefreshView.h"

@class BuildingListView;
@class BuildingQueueView;

@interface PlanetBuildingViewController : UIViewController <PullToRefreshViewDelegate>
{
    CGRect _originalListFrame;
    NSTimer* _refreshTimer;
    PullToRefreshView *_pull;
}

@property (nonatomic) IBOutlet UIScrollView* mainScrollView;

// Custom IBOutlet Views
@property (nonatomic) IBOutlet BuildingListView* buildingListView;
@property (nonatomic) IBOutlet BuildingQueueView* buildingQueueView;
@property (nonatomic) IBOutlet UISegmentedControl* segmentGroup;

#pragma mark Segment
- (IBAction)segmentSwitch:(id)sender;

#pragma mark Data Processing
-(void) refreshData;

#pragma mark Navigation Extras
-(void) showBuildingList;

@end
