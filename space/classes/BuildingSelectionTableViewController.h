//
//  BuildingSelectionTableViewController.h
//  space
//
//  Created by Martin Walsh on 26/10/2012.
//  Copyright (c) 2012 Pedro LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PullToRefreshView.h"

@interface BuildingSelectionTableViewController : UITableViewController  <PullToRefreshViewDelegate>

// Pull Refresh
@property (nonatomic) PullToRefreshView *pull;

// Data
@property (nonatomic) NSMutableArray* buildingsAllowed;
@property (nonatomic) NSMutableArray* buildingsFiltered;

#pragma mark Data Processing
-(void) refreshData;


@end
