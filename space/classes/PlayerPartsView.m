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
#define PART_ARMS       3
#define PART_CHEST      4
#define PART_HANDS      2
#define PART_LEGS       5
#define PART_FEET       6

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
    
    // Cornered
    self.layer.cornerRadius = 4;
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
    
    // Check Arms
    [_partArms setupPartID:PART_ARMS];
    for(NSDictionary* part in parts)
    {
        if([[part objectForKey:@"part_id"] integerValue]==PART_ARMS)
            [_partArms refresh:[[part objectForKey:@"item_id"] integerValue]];
    }
    
    // Check Chest
    [_partChest setupPartID:PART_CHEST];
    for(NSDictionary* part in parts)
    {
        if([[part objectForKey:@"part_id"] integerValue]==PART_CHEST)
            [_partChest refresh:[[part objectForKey:@"item_id"] integerValue]];
    }
    
    // Check Hands
    [_partHands setupPartID:PART_HANDS];
    for(NSDictionary* part in parts)
    {
        if([[part objectForKey:@"part_id"] integerValue]==PART_HANDS)
            [_partHands refresh:[[part objectForKey:@"item_id"] integerValue]];
    }
    
    // Check Legs
    [_partLegs setupPartID:PART_LEGS];
    for(NSDictionary* part in parts)
    {
        if([[part objectForKey:@"part_id"] integerValue]==PART_LEGS)
            [_partLegs refresh:[[part objectForKey:@"item_id"] integerValue]];
    }
    
    // Check Legs
    [_partFeet setupPartID:PART_FEET];
    for(NSDictionary* part in parts)
    {
        if([[part objectForKey:@"part_id"] integerValue]==PART_FEET)
            [_partFeet refresh:[[part objectForKey:@"item_id"] integerValue]];
    }
      
}

@end
