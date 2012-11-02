//
//  ResearchQueueItemView.h
//  space
//
//  Created by Martin Walsh on 02/11/2012.
//  Copyright (c) 2012 Pedro LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ResearchQueueItemView : UIView

@property (nonatomic) IBOutlet UILabel* itemName;
@property (nonatomic) IBOutlet UILabel* itemETA;
@property (nonatomic) IBOutlet UIProgressView* itemProgress;

// Time Tracking
@property (nonatomic, readwrite) int itemID;
@property (nonatomic, readwrite) double startTime;
@property (nonatomic, readwrite) double endTime;

@end
