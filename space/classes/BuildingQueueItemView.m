//
//  BuildingQueueItemView.m
//  space
//
//  Created by Martin Walsh on 30/10/2012.
//  Copyright (c) 2012 Pedro LTD. All rights reserved.
//

#import "BuildingQueueItemView.h"
#import "UILabel+formatHelpers.h"

@implementation BuildingQueueItemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Initialization From NIB
- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if(self) {
        [self applyDefaultStyle];
        _ignore = YES;
    }
    return self;
}

- (void)applyDefaultStyle {
    
    // Cornered
    self.layer.cornerRadius = 4;
}

#pragma mark Progress
-(BOOL) updateQueueProgress
{

    // Calculate Progress
    double progressDivision = 1.0f / (_endTime - _startTime);
    double currentProgress  = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970];
    double ETA              = _endTime - currentProgress;
    float progress          = 0.0f;
    if(ETA<=0)
        ETA = 0; // CAP ETA 0
    
    // Cap Completion
    if(ETA<=1) {
        progress = 1.0f;
    } else { // Calculate Progress
        progress = (currentProgress - _startTime) * progressDivision;
    }
    
    // Update Progress Bar
    [_itemProgress setProgress:progress animated:NO];
    [_itemETA setTimerText:[NSNumber numberWithDouble:ETA]];
    
    if(ETA==0)
    {
        _ignore = YES;
        return YES; // Refresh
    }
    
    return NO;
    
}


@end
