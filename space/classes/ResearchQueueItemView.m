//
//  ResearchQueueItemView.m
//  space
//
//  Created by Martin Walsh on 02/11/2012.
//  Copyright (c) 2012 Pedro LTD. All rights reserved.
//

#import "ResearchQueueItemView.h"

@implementation ResearchQueueItemView

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
    }
    return self;
}

- (void)applyDefaultStyle {
    
    // Cornered
    self.layer.cornerRadius = 4;
}

@end
