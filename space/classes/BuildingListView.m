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
        _viewArray          = [[NSMutableArray alloc] init];
        _building           = [[NSMutableArray alloc] init];
        _buildingFiltered   = [[NSMutableArray alloc] init];
        _groupFilter        = @"";
    }
    return self;
}

- (void)applyDefaultStyle {
    
    // Cornered
    self.layer.cornerRadius = 4;
}

-(void) refresh:(NSMutableArray*) buildingList
{
    
    // Remove Views
    for(BuildingListItemView* item in _viewArray)
    {
        [item removeFromSuperview];
    }
    [_viewArray removeAllObjects];
    
    
    // Update Interal Dictionary
    if(buildingList)
        _building = [NSMutableArray arrayWithArray:buildingList];
    
    // Filter
    [self filterBuildings];
    
    // Anything to Add?
    if([_buildingFiltered count]==0)
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
    
    for(NSDictionary* building in _buildingFiltered)
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

#pragma mark Data Filtering
-(void) filterBuildings
{
    // Filter
    NSMutableArray* buildingGroup = [[GameManager sharedInstance] getBuildingGroup:_groupFilter];
    
    //CCLOG(@"Segment Filter: %@",buildingGroup);
    
    // Filtering
    [_buildingFiltered removeAllObjects];
    
    // Loop Through Planet Buildings
    for(NSDictionary* buildingItem in _building)
    {
        NSDictionary* buildingEntry = [[GameManager sharedInstance] getBuilding:[[buildingItem objectForKey:@"id"] intValue]];
        
        // Matching Group Filtering
        for(NSNumber* groupID in buildingGroup)
        {
            if([[buildingEntry objectForKey:@"group_id"] intValue]==[groupID intValue])
            {
                // Add Building
                [_buildingFiltered addObject:buildingItem];
            }
        }
        
    }
    
}


@end
