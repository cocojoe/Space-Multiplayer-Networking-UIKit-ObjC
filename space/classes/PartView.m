//
//  PartView.m
//  space
//
//  Created by Martin Walsh on 19/10/2012.
//  Copyright (c) 2012 Pedro LTD. All rights reserved.
//

#import "UIView+FindUIViewController.h"
#import "PartView.h"
#import "GameManager.h"
#import "MasterViewController.h"
#import "InventoryViewController.h"

@implementation PartView

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
       
        // Tap Handler INIT
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(equipmentTap)];
        [_tap setNumberOfTouchesRequired:1];
        [_tap setNumberOfTapsRequired:1];
        
        // Add Head Handler
        self.userInteractionEnabled = NO;
        [self addGestureRecognizer:_tap];
        
        [self applyDefaultStyle];
    }
    return self;
}

- (void)applyDefaultStyle {
    
    // apply the border
    [self setBackgroundColor:[UIColor clearColor]];
}

-(void) setupPartID:(int) partID
{

    _partID   = partID;
    _equipped = NO;
    
    NSMutableArray* partList = [[GameManager sharedInstance] masterPartList];
    for(NSDictionary* part in partList)
    {
        if([[part objectForKey:@"id"] integerValue]==partID)
        {
            // Setup Part
            _searchText      = [part objectForKey:@"name"];
            _imagePart.image = [UIImage imageNamed:[part objectForKey:@"icon"]];
        }
    }
    
    // Enable Touch
    self.userInteractionEnabled = YES;
}

-(void) refresh:(int) itemID
{
    _equipped = YES;
    
    NSMutableArray* itemList = [[GameManager sharedInstance] masterItemList];
    for(NSDictionary* item in itemList)
    {
        if([[item objectForKey:@"id"] integerValue]==itemID)
        {
            // Setup Part
            _labelName.text         = [item objectForKey:@"name"];
            _labelDescription.text  = [NSString stringWithFormat:@"\"%@\"",[item objectForKey:@"description"]];
            _imagePart.image        = [UIImage imageNamed:[item objectForKey:@"icon"]];
        }
    }

    // Enable Touch
    self.userInteractionEnabled = YES;
    
}

#pragma mark Handle Equipment Touch
-(void) equipmentTap {
    CCLOG(@"Equipment Touched: %@, PartID: %d, Filter: %@",_labelName.text, _partID, _searchText);
    
    // Create Inventroy
    InventoryViewController* inventoryViewController = [[InventoryViewController alloc] initWithNibName:@"InventoryViewController" bundle:nil];
    
    // Set Inventory Fixed Search
    [inventoryViewController setSearchText:_searchText];
    [inventoryViewController setPartID:_partID];
    [inventoryViewController setShowRemove:_equipped];
    
    // Add Navigation (For Bar Control)
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:inventoryViewController];
    
    // Push Inventory Selection View
    UIViewController* viewController = [[GameManager sharedInstance] view];
    [viewController presentModalViewController:navigation animated:YES];
    
}

@end
