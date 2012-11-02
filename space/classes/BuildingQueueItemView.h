//
//  BuildingQueueItemView.h
//  space
//
//  Created by Martin Walsh on 30/10/2012.
//  Copyright (c) 2012 Pedro LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface BuildingQueueItemView : UIView

@property (nonatomic) IBOutlet UILabel* itemName;
@property (nonatomic) IBOutlet UILabel* itemAmount;
@property (nonatomic) IBOutlet UILabel* itemETA;
@property (nonatomic) IBOutlet UIProgressView* itemProgress;

// Track Current Item
@property (nonatomic, readwrite) int itemID;
@property (nonatomic, readwrite) double startTime;
@property (nonatomic, readwrite) double endTime;

@end
