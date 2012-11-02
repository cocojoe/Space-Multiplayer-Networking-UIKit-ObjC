//
//  PlanetResearchViewController.h
//  space
//
//  Created by Martin Walsh on 31/10/2012.
//  Copyright (c) 2012 Pedro LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullToRefreshView.h"

@class ResearchQueueView;
@class ResearchListView;

@interface PlanetResearchViewController : UIViewController <PullToRefreshViewDelegate> {
    PullToRefreshView *_pull;
    CGRect _originalListFrame;
    NSTimer* _refreshTimer;
}

// IBOutlets
@property (nonatomic) IBOutlet UIScrollView* mainScrollView;

// Custom IBOutlet Views
@property (nonatomic) IBOutlet ResearchQueueView* queueView;
@property (nonatomic) IBOutlet ResearchListView* listView;

#pragma mark Public Methods
-(void) refreshData;

@end
