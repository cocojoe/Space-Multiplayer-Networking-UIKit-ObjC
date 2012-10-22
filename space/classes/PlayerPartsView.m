//
//  PlayerProfileView.m
//  space
//
//  Created by Martin Walsh on 17/10/2012.
//  Copyright (c) 2012 Pedro LTD. All rights reserved.
//

#import "PlayerPartsView.h"
#import "PartView.h"
#import "GameManager.h"

#define PART_HEAD       1
#define PART_HANDS      2

@implementation PlayerPartsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self applyDefaultStyle];
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
    
    // curve the corners
    self.layer.cornerRadius = 4;
    
    // apply the border
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    // add the drop shadow
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOffset = CGSizeMake(2.0, 2.0);
    self.layer.shadowOpacity = 0.25;
}

-(void) refresh:(NSMutableArray*) parts
{
    
    // Check Head
    [_partHead setupPartID:PART_HEAD];
    for(NSDictionary* part in parts)
    {
        if([[part objectForKey:@"part_id"] integerValue]==PART_HEAD)
            [_partHead refresh:[[part objectForKey:@"item_id"] integerValue]];
    }
      
    // Check Head
    [_partHands setupPartID:PART_HANDS];
    for(NSDictionary* part in parts)
    {
        if([[part objectForKey:@"part_id"] integerValue]==PART_HANDS)
            [_partHands refresh:[[part objectForKey:@"item_id"] integerValue]];
    }
      
}


@end
