//
//  BuildingQueueView.h
//  space
//
//  Created by Martin Walsh on 30/10/2012.
//  Copyright (c) 2012 Pedro LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define BUILDING_QUEUE_ITEM_BORDER              5.0f
#define BUILDING_QUEUE_DEFAULT_HEIGHT           20.0f

@interface BuildingQueueView : UIView {
    NSMutableArray* _items;
}

// IB Outlet
@property (nonatomic) IBOutlet UILabel* headerText;

-(void) setupQueue:(NSMutableArray*) itemQueueArray;
-(void) updateQueue;

@end
