//
//  PlanetResearchViewController.h
//  space
//
//  Created by Martin Walsh on 31/10/2012.
//  Copyright (c) 2012 Pedro LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullToRefreshView.h"

@interface PlanetResearchViewController : UIViewController <PullToRefreshViewDelegate> {
    PullToRefreshView *_pull;
}

// IBOutlets
@property (nonatomic) IBOutlet UIScrollView* mainScrollView;

#pragma mark Public Methods
-(void) refreshData;

@end
