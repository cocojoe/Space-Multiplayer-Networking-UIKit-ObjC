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

@implementation PlayerPartsView

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

-(void) refresh:(NSDictionary*) partsDict
{
    // Check Head
    if([partsDict objectForKey:@"head"])
    {
        NSDictionary* itemDict = [[partsDict objectForKey:@"head"] objectForKey:@"item"];
        
        [_partHead refresh:itemDict setPartID:[[[partsDict objectForKey:@"head"] objectForKey:@"part_id"] integerValue]];
    } else {
        // Harcoded Part Reference
        // Default Values
        NSDictionary* itemDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"You have no head item", @"name",
                                  @"Click to equip an item", @"description",
                                  @"parts_head_empty", @"icon",
                                  [NSNumber numberWithBool:NO],@"remove", nil];
        [_partHead refresh:itemDict setPartID:1];
    }
    [_partHead setSearchText:@"head"];
    
    
    // Check Head
    if([partsDict objectForKey:@"hands"])
    {
        NSDictionary* itemDict = [[partsDict objectForKey:@"hands"] objectForKey:@"item"];
        
        [_partHands refresh:itemDict setPartID:[[[partsDict objectForKey:@"hands"] objectForKey:@"part_id"] integerValue]];
    } else {
        // Harcoded Part Reference
        // Default Values
        NSDictionary* itemDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"You have no hands item", @"name",
                                  @"Click to equip an item", @"description",
                                  @"parts_hands_empty", @"icon",
                                  [NSNumber numberWithBool:NO],@"remove", nil];
        [_partHands refresh:itemDict setPartID:2];
    }
    [_partHands setSearchText:@"hands"];
    
}


@end
