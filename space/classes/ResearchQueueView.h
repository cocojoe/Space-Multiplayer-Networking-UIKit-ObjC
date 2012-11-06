//
//  ResearchQueueView.h
//  space
//
//  Created by Martin Walsh on 02/11/2012.
//  Copyright (c) 2012 Pedro LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define RESEARCH_QUEUE_ITEM_BORDER             5.0f
#define RESEARCH_QUEUE_DEFAULT_HEIGHT          20.0f

@interface ResearchQueueView : UIView {
    NSMutableArray* _items;
}

// IB Outlets
@property (nonatomic) IBOutlet UILabel* header;

-(void) createQueue:(NSMutableArray*) itemQueueArray;
-(void) updateQueueProgress;

@end
