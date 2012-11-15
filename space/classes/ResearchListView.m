//
//  ResearchListView.m
//  space
//
//  Created by Martin Walsh on 02/11/2012.
//  Copyright (c) 2012 Pedro LTD. All rights reserved.
//

#import "ResearchListView.h"
#import "ResearchListItemView.h"

#define RESEARCH_LIST_VIEW_BORDER   5.0f

@implementation ResearchListView

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
    }
    return self;
}

- (void)applyDefaultStyle {
    
    // Cornered
    self.layer.cornerRadius = 4;
}

-(void) refresh:(NSMutableArray*) itemList
{
    
    // Remove Views
    for(ResearchListItemView* item in _viewArray)
    {
        [item removeFromSuperview];
    }
    [_viewArray removeAllObjects];
    
    
      // Anything to Add?
    if([itemList count]==0)
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
    
    for(NSDictionary* itemDict in itemList)
    {
        // Create UIView
        ResearchListItemView *newItem = [[[NSBundle mainBundle] loadNibNamed:@"ResearchListItemView" owner:self options:nil] objectAtIndex:0];
        [self addSubview:newItem];
        [newItem refresh:itemDict];
        
        // Alignment
        if(totalHeight==0)
        {
            totalHeight+=newItem.frame.size.height*0.5f; // First Centre Point
        } else {
            totalHeight+=newItem.frame.size.height; // Next Centre Point
        }
        totalHeight+=RESEARCH_LIST_VIEW_BORDER; // Border Top, Between Views
        centerView.y=totalHeight;
        [newItem setCenter:centerView];
        
        [_viewArray addObject:newItem];
        
        // Required for Final Frame Height
        itemHeight = newItem.frame.size.height;
    }
    
    // Bottom Border
    totalHeight+=RESEARCH_LIST_VIEW_BORDER+(itemHeight*0.5f);
    
    // Correct Frame Height (Dynamic)
    CGRect frame = [self frame];
    frame.size.height = totalHeight;
    [self setFrame:frame];
    
}

@end
