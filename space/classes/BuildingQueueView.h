//
//  BuildingQueueView.h
//  space
//
//  Created by Martin Walsh on 30/10/2012.
//  Copyright (c) 2012 Pedro LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define BUILDING_QUEUE_ITEM_BORDER             5.0f

@interface BuildingQueueView : UIView {
    NSMutableArray* _items;
}

-(void) setupQueue:(NSMutableArray*) itemQueueArray;

@end
