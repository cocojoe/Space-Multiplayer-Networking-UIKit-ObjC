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

-(void) refresh:(NSDictionary*) itemDict setPartID:(int) partID
{
    // Set Internal Part ID
    _partID   = partID;
    _equipped = YES;
    
    // Check Item Dictionary
    if(itemDict!=nil)
    {
        _labelName.text  = [itemDict objectForKey:@"name"];
        _labelDescription.text  = [NSString stringWithFormat:@"\"%@\"",[itemDict objectForKey:@"description"]];
        _imagePart.image = [UIImage imageNamed:[itemDict objectForKey:@"icon"]];
        
        if([itemDict objectForKey:@"remove"])
            _equipped = NO;
    }
    
    // Enable Touch
    self.userInteractionEnabled = YES;
    
}

#pragma mark Handle Equipment Touch
-(void) equipmentTap {
    CCLOG(@"Equipment Touched: %@, PartID: %d, Filter: %@",_labelName.text, _partID, _searchText);
    
    // Create Inventroy
    InventoryViewController* inventoryViewController = [[InventoryViewController alloc] initWithNibName:@"InventoryViewController" bundle:nil];
    
    // Display Inventory View
    [inventoryViewController setSearchText:_searchText];
    [inventoryViewController setPartID:_partID];
    [inventoryViewController setShowRemove:_equipped];
    
    // Add Navigation (For Bar Control)
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:inventoryViewController];
    
    // Create
    UIViewController* viewController = [[GameManager sharedInstance] view];
    [viewController presentModalViewController:navigation animated:YES];
    
}

@end
