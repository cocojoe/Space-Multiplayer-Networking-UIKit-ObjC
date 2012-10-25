//
//  PlanetViewController.h
//  space
//
//  Created by Martin Walsh on 24/10/2012.
//  Copyright (c) 2012 Pedro LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullToRefreshView.h"

@interface PlanetViewController : UITableViewController  <PullToRefreshViewDelegate>

// Pull Refresh
@property (nonatomic) PullToRefreshView *pull;

// Data
@property (nonatomic) NSMutableArray* planets;

#pragma mark Data Processing
-(void) refreshData;

@end
