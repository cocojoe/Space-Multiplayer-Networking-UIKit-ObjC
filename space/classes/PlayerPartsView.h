//
//  PlayerProfileView.h
//  space
//
//  Created by Martin Walsh on 17/10/2012.
//  Copyright (c) 2012 Pedro LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class PartView;

@interface PlayerPartsView : UIView

@property (nonatomic) IBOutlet PartView* partHead;
@property (nonatomic) IBOutlet PartView* partHands;

-(void) refresh:(NSDictionary*) partsDict;

@end
