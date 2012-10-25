//
//  InventoryViewController.h
//  space
//
//  Created by Martin Walsh on 09/10/2012.
//  Copyright (c) 2012 Pedro LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullToRefreshView.h"

@interface InventoryViewController : UITableViewController <PullToRefreshViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>

// Pull Refresh
@property (nonatomic) PullToRefreshView *pull;

// Outlets
@property (nonatomic) IBOutlet UISearchBar* filterSearch;

// Inventory Data
@property (nonatomic) NSMutableArray* inventory;
@property (nonatomic) NSMutableArray* inventoryAppended;
@property (nonatomic) NSMutableArray* inventoryFiltered;

// Fixed Search
@property (nonatomic) NSString* searchText;

// Part Change Helpers
@property (nonatomic,readwrite) int partID;
@property (nonatomic,readwrite) bool showRemove;

@end
