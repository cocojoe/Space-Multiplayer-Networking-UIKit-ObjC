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
#define BUILDING_LIST_VIEW_START    55.0f

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
    

    // Center in Parent View Horizontal, Border From Top
    CGPoint centerView = CGPointMake(self.bounds.size.width/2.0f, BUILDING_LIST_VIEW_START);
    float totalHeight  = BUILDING_LIST_VIEW_START;
    
    for(NSDictionary* building in buildingDict)
    {
        // Create UIView
        BuildingListItemView *buildingItem = [[[NSBundle mainBundle] loadNibNamed:@"BuildingListItemView" owner:self options:nil] objectAtIndex:0];
        [self addSubview:buildingItem];
        [buildingItem refresh:building];
        
        // Alignment
        [buildingItem setCenter:centerView];
        centerView.y+=BUILDING_LIST_VIEW_BORDER+(buildingItem.bounds.size.height);
        totalHeight+=buildingItem.bounds.size.height;
        
        [_viewArray addObject:buildingItem];
        
    }
    
    // Correct Frame Bounds
    CGRect frame = [self frame];
    frame.size.height = totalHeight;
    [self setFrame:frame];
    
}


@end
