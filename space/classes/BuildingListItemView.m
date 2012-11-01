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
    self.layer.borderColor = [UIColor colorWithRed:6/255.0f green:50/255.0f blue:65/255.0f alpha:1.0f].CGColor;
    self.layer.borderWidth = 2.0f;
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
            
            // Amount (QTY)
            qty = [[buildingDict objectForKey:@"amount"] intValue];
            _buildingAmount.text  = [NSString stringWithFormat:@"x%@",[formatter stringFromNumber:[NSNumber numberWithInt:qty]]];
            
            // Incomes
            NSDictionary* incomeDict = [buildingDetail objectForKey:@"income"];
            
            // Food
            value = [[incomeDict objectForKey:@"food"] intValue];
            value*=qty;
            [_buildingFood setTextRate:[NSNumber numberWithInt:value]];
            
            // Workers
            value = [[incomeDict objectForKey:@"workers"] intValue];
            value*=qty;
            [_buildingWorkers setTextRate:[NSNumber numberWithInt:value]];
            
            // Energy
            value = [[incomeDict objectForKey:@"energy"] intValue];
            value*=qty;
            [_buildingEnergy setTextRate:[NSNumber numberWithInt:value]];
            
            // Minerals
            value = [[incomeDict objectForKey:@"minerals"] intValue];
            value*=qty;
            [_buildingMinerals setTextRate:[NSNumber numberWithInt:value]];
          
        }
    }
}

@end
