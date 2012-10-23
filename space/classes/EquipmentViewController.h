//
//  EquipmentViewController.h
//  space
//
//  Created by Martin Walsh on 23/10/2012.
//  Copyright (c) 2012 Pedro LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullToRefreshView.h"

@class PlayerPartsView;

@interface EquipmentViewController : UIViewController <PullToRefreshViewDelegate>

@property (nonatomic) UIScrollView* mainScrollView;

// Custom IBOutlet Views
@property (nonatomic) IBOutlet PlayerPartsView* partsProfileView;

#pragma mark Manual Creation
- (id)initWithTitle:(NSString *)title;

#pragma mark Data Processing
-(void) refreshData;

@end
