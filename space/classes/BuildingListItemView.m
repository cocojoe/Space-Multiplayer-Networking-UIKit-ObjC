//
//  BuildingListItemView.m
//  space
//
//  Created by Martin Walsh on 29/10/2012.
//  Copyright (c) 2012 Pedro LTD. All rights reserved.
//

#import "BuildingListItemView.h"
#import "GameManager.h"
#import "UILabel+formatHelpers.h"

@implementation BuildingListItemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self applyDefaultStyle];
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
    
    // Cornered
    self.layer.cornerRadius = 4;
}

-(void) refresh:(NSDictionary*) buildingDict
{
   
    // Number Formatter
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    int value = 0;
    int qty   = 0;
    
    // Lookup Building
    for(NSDictionary* buildingDetail in [[GameManager sharedInstance] masterBuildingList])
    {
        // Check Master Buildings / Add
        if([[buildingDetail objectForKey:@"id"] integerValue]==[[buildingDict objectForKey:@"building_id"] integerValue])
        {
            // Internal
            _buildingID = [[buildingDict objectForKey:@"building_id"] intValue];
            
            // Basics
            [_buildingName setText:[buildingDetail objectForKey:@"name"]];
            [_buildingDescription setText:[buildingDetail objectForKey:@"description"]];
            
            // Amount (QTY)
            qty = [[buildingDict objectForKey:@"amount"] intValue];
            _buildingAmount.text  = [NSString stringWithFormat:@"x%@",[formatter stringFromNumber:[NSNumber numberWithInt:qty]]];
            
            // Incomes
            
            // Food
            value = [[buildingDetail objectForKey:@"income_food"] intValue];
            value*=qty;
            [_buildingFood setTextRate:[NSNumber numberWithInt:value]];
            
            // Workers
            value = [[buildingDetail objectForKey:@"income_workers"] intValue];
            value*=qty;
            [_buildingWorkers setTextRate:[NSNumber numberWithInt:value]];
            
            // Energy
            value = [[buildingDetail objectForKey:@"income_energy"] intValue];
            value*=qty;
            [_buildingEnergy setTextRate:[NSNumber numberWithInt:value]];
            
            // Minerals
            value = [[buildingDetail objectForKey:@"income_minerals"] intValue];
            value*=qty;
            [_buildingMinerals setTextRate:[NSNumber numberWithInt:value]];
          
        }
    }
}

@end
