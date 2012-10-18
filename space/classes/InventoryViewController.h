//
//  InventoryViewController.h
//  space
//
//  Created by Martin Walsh on 09/10/2012.
//  Copyright (c) 2012 Pedro LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullToRefreshView.h"

@interface InventoryViewController : UITableViewController <PullToRefreshViewDelegate>

@property (nonatomic) NSMutableArray* inventory;
@property (nonatomic) PullToRefreshView *pull;

@end
