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
    
    // Remove Views
    for(BuildingQueueItemView* item in _items)
    {
        [item removeFromSuperview];
    }
    
    // Track Vertical
    // Initial Center in Parent UIView Horizontal, Variable Gap From Top
    CGPoint centerView = CGPointMake(self.bounds.size.width/2.0f, BUILDING_QUEUE_ITEM_VERTICAL_OFFSET);
    float totalHeight  = 0;
    
    // Build Views
    for(NSDictionary* itemQueue in itemQueueArray)
    {
        // Create UIView
        BuildingQueueItemView *newItem = [[[NSBundle mainBundle] loadNibNamed:@"BuildingQueueItemView" owner:self options:nil] objectAtIndex:0];
        
        // Set Items(id)
        [newItem setItemID:[[itemQueue objectForKey:@"building_id"] intValue]];
        
        // Grab Building Data
        NSDictionary* itemMasterDetail = [[GameManager sharedInstance] getBuilding:[newItem itemID]];

        // Calculate Progress
        double progressDivision = 1.0f / (([[itemQueue objectForKey:@"end_time"] doubleValue] - [[itemQueue objectForKey:@"start_time"] doubleValue]));
        double currentProgress  = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970];
        double ETA              = [[itemQueue objectForKey:@"end_time"] doubleValue] - currentProgress;
        if(ETA<=0)
        {
            ETA = 0; // CAP ETA 0
            
            // Clear Cache / Refresh
            [[[GameManager sharedInstance] planetDict] removeAllObjects];
            // General Timer Will Catch Refresh
            // [[NSNotificationCenter defaultCenter] postNotificationName:@"buildingRefresh" object:self];
        } 
        float progress          = 0.0f;
        
        // Check Completion
        if(currentProgress>=[[itemQueue objectForKey:@"end_time"] doubleValue])
            progress = 1.0f;
        else { // Calculate Progress
            progress = (currentProgress - [[itemQueue objectForKey:@"start_time"] doubleValue]) * progressDivision;
        }
                                                                                
        // Setup Item Details
        newItem.itemName.text         = [itemMasterDetail objectForKey:@"name"];
        newItem.itemAmount.text       = [NSString stringWithFormat:@"x%d",[[itemQueue objectForKey:@"amount"] intValue]];
        [[newItem itemProgress] setProgress:progress animated:NO];
        //[[newItem itemProgress] setProgressTintColor:[UIColor blueColor]];
        [newItem.itemETA setTimerText:[NSNumber numberWithDouble:ETA]];

        
        // View Alignment
        [newItem setCenter:centerView];
        
        // Next Position
        centerView.y+=BUILDING_QUEUE_ITEM_BORDER+(newItem.bounds.size.height);
        totalHeight+=newItem.bounds.size.height;
        
        [self addSubview:newItem];
        [_items addObject:newItem];
    }
    
    // Correct Frame Bounds
    CGRect frame = [self frame];
    frame.size.height = totalHeight;
    [self setFrame:frame];

}

@end
