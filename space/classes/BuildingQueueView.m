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
    
    // Items to Add
    if([itemQueueArray count]==0)
    {
        // Rest Frame Height
        CGRect frame = [self frame];
        frame.size.height = 0;
        [self setFrame:frame];
        return;
    }
    
    // Start Point (Relative to View)
    float totalHeight  = 0;
    float itemHeight   = 0;
    // Center in Parent View Horizontal, Border From Top
    CGPoint centerView = CGPointMake(self.bounds.size.width/2.0f, totalHeight);
    
    // Build Views
    for(NSDictionary* itemQueue in itemQueueArray)
    {
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
        
        // Set Timer / Progress
        [self updateQueueTimer:newItem];

        // Alignment
        if(totalHeight==0)
        {
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
        if([self updateQueueTimer:newItem])
            bRefresh = YES;
    }
    
    // Refresh Required
    if(bRefresh)
    {
        // Invalidate Cache / Full Refresh
        [[[GameManager sharedInstance] planetDict] removeAllObjects];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"buildingRefresh" object:self];
    }
}

-(BOOL) updateQueueTimer:(BuildingQueueItemView*) newItem
{
    // Calculate Progress
    double progressDivision = 1.0f / ([newItem endTime] - [newItem startTime]);
    double currentProgress  = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970];
    double ETA              = [newItem endTime] - currentProgress;
    float progress          = 0.0f;
    if(ETA<=0)
        ETA = 0; // CAP ETA 0
    
    // Cap Completion
    if(ETA==0) {
        progress = 1.0f;
    } else { // Calculate Progress
        progress = (currentProgress - [newItem startTime]) * progressDivision;
    }
    
    // Set Progress Bar
    [[newItem itemProgress] setProgress:progress animated:NO];
    [newItem.itemETA setTimerText:[NSNumber numberWithDouble:ETA]];
    
    if(ETA==0)
        return YES; // Refresh
    
    return NO;

}

@end
