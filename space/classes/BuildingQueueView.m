//
//  BuildingQueueView.m
//  space
//
//  Created by Martin Walsh on 30/10/2012.
//  Copyright (c) 2012 Pedro LTD. All rights reserved.
//

#import "GameManager.h"
#import "BuildingQueueView.h"
#import "BuildingQueueItemView.h"
#import "UILabel+formatHelpers.h"

@implementation BuildingQueueView

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
        _items = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)applyDefaultStyle {
    
    // Cornered
    self.layer.cornerRadius = 4;
}

-(void) setupQueue:(NSMutableArray*) itemQueueArray
{
    
    
    // Remove Existing Views
    for(BuildingQueueItemView* item in _items)
    {
        [item removeFromSuperview];
    }
    [_items removeAllObjects];
    
    // Reset Header
    if([itemQueueArray count]==0)
    {
        // Rest Frame Height
        CGRect frame = [self frame];
        frame.size.height = BUILDING_QUEUE_DEFAULT_HEIGHT;
        [self setFrame:frame];
        
        _header.hidden = NO;
        _header.text = [NSString stringWithFormat:@"%d Queue Slots Free",(_maxQueueDepth-[itemQueueArray count])];
        return;
    }
    
    if([itemQueueArray count]>=_maxQueueDepth)
    {
        // Remove Header (If We Have No Slots Available)
        _header.hidden = YES;
    }
    
    // Start Point (Relative to View)
    float totalHeight  = 0;
    float itemHeight   = 0;
    // Center in Parent View Horizontal, Border From Top
    CGPoint centerView = CGPointMake(self.bounds.size.width/2.0f, totalHeight);
    
    // Build Views
    int position = 0;
    for(NSDictionary* itemQueue in itemQueueArray)
    {
        // Increment Position
        position++;
        
        // Create UIView
        BuildingQueueItemView *newItem = [[[NSBundle mainBundle] loadNibNamed:@"BuildingQueueItemView" owner:self options:nil] objectAtIndex:0];
        
        // Set Items(id)
        [newItem setItemID:[[itemQueue objectForKey:@"building_id"] intValue]];
        
        // Set Time(s)
        [newItem setEndTime:[[itemQueue objectForKey:@"end_time"] doubleValue]];
        [newItem setStartTime:[[itemQueue objectForKey:@"start_time"] doubleValue]];
        
        // Grab Building Data
        NSDictionary* itemMasterDetail = [[GameManager sharedInstance] getBuilding:[newItem itemID]];
                                                                                
        // Setup Item Details
        newItem.itemName.text         = [itemMasterDetail objectForKey:@"name"];
        newItem.itemAmount.text       = [NSString stringWithFormat:@"x%d",[[itemQueue objectForKey:@"amount"] intValue]];
        
        // Set Position
        newItem.itemPosition.text = [NSString stringWithFormat:@"%d/%d",position,_maxQueueDepth];
        
        // Set Timer / Progress
        [self updateQueue];
        
        // Alignment
        if(totalHeight==0)
        {
            if(_header.hidden==NO) // Additional Spacing For Header Text
                totalHeight+=_header.frame.size.height*0.5f;
            totalHeight+=newItem.frame.size.height*0.5f; // First Centre Point
        } else {
            totalHeight+=newItem.frame.size.height; // Next Centre Point
        }
        totalHeight+=BUILDING_QUEUE_ITEM_BORDER; // Border Top, Between Views
        centerView.y=totalHeight;
        [newItem setCenter:centerView];
        
        [self addSubview:newItem];
        [_items addObject:newItem];
        
        // Required for Final Frame Height
        itemHeight = newItem.frame.size.height;

    }
    
    // Bottom Border
    totalHeight+=BUILDING_QUEUE_ITEM_BORDER+(itemHeight*0.5f);
    
    // Correct Frame Height (Dynamic)
    CGRect frame = [self frame];
    frame.size.height = totalHeight;
    [self setFrame:frame];
}

-(void) updateQueue
{
    // Just In Case
    if([_items count]==0)
        return;
    
    BOOL bRefresh = NO;
    for(BuildingQueueItemView* newItem in _items) {
        if([newItem updateQueueProgress])
        {
            bRefresh = YES;
        }
    }
    
    // Full API Refresh Required
    if(bRefresh)
    {
        // Invalidate Cache / Full Refresh
        [[[GameManager sharedInstance] planetDict] removeAllObjects];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"buildingRefresh" object:self];
    }
}

@end
