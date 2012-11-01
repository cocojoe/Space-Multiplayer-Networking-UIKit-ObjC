//
//  BuildingListView.m
//  space
//
//  Created by Martin Walsh on 29/10/2012.
//  Copyright (c) 2012 Pedro LTD. All rights reserved.
//

#import "BuildingListView.h"
#import "BuildingListItemView.h"
#import "GameManager.h"

#define BUILDING_LIST_VIEW_BORDER   5.0f

@implementation BuildingListView

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
        _viewArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)applyDefaultStyle {
    
    // Cornered
    self.layer.cornerRadius = 4;
}

-(void) refresh:(NSMutableArray*) buildingDict
{
    
    // Remove Views
    for(BuildingListItemView* item in _viewArray)
    {
        [item removeFromSuperview];
    }
    
    // Items to Add?
    if([buildingDict count]==0)
    {
        return;
    }
    
    // Start Point (Relative to View)
    float totalHeight  = 0;
    float itemHeight   = 0;
    
    // Center in Parent View Horizontal, Border From Top
    CGPoint centerView = CGPointMake(self.bounds.size.width/2.0f, totalHeight);
    
    for(NSDictionary* building in buildingDict)
    {
        // Create UIView
        BuildingListItemView *buildingItem = [[[NSBundle mainBundle] loadNibNamed:@"BuildingListItemView" owner:self options:nil] objectAtIndex:0];
        [self addSubview:buildingItem];
        [buildingItem refresh:building];
        
        // Alignment
        if(totalHeight==0)
        {
            totalHeight+=buildingItem.frame.size.height*0.5f; // First Centre Point
        } else {
            totalHeight+=buildingItem.frame.size.height; // Next Centre Point
        }
        totalHeight+=BUILDING_LIST_VIEW_BORDER; // Border Top, Between Views
        centerView.y=totalHeight;
        [buildingItem setCenter:centerView];
        
        [_viewArray addObject:buildingItem];
        
        // Required for Final Frame Height
        itemHeight = buildingItem.frame.size.height;
    }
    
    // Bottom Border
    totalHeight+=BUILDING_LIST_VIEW_BORDER+(itemHeight*0.5f);
    
    // Correct Frame Height (Dynamic)
    CGRect frame = [self frame];
    frame.size.height = totalHeight;
    [self setFrame:frame];
    
}


@end
