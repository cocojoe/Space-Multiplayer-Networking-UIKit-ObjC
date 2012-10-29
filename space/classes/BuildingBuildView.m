//
//  BuildingBuildView.m
//  space
//
//  Created by Martin Walsh on 29/10/2012.
//  Copyright (c) 2012 Pedro LTD. All rights reserved.
//

#import "BuildingBuildView.h"
#import "GameManager.h"
#import "UILabel+formatHelpers.h"

#define DEFAULT_BUILD_AMOUNT    1

@implementation BuildingBuildView

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
        _amount = DEFAULT_BUILD_AMOUNT; // Default
    }
    return self;
}


-(void) refresh:(NSDictionary *)buildingDict
{
    // Setup Stepper
    _stepperAmount.maximumValue = 10;
    _stepperAmount.minimumValue = 1;
    _stepperAmount.value        = _amount;
    _stepperAmount.stepValue    = 1;
    
    // Store Dictionary
    _buildingDict = [NSDictionary dictionaryWithDictionary:buildingDict];
    
    // Name
    _buildingName.text = [buildingDict objectForKey:@"name"];
    _buildingDescription.text = [buildingDict objectForKey:@"description"];
    
    [self updateAmount];
}

-(void) updateAmount
{
    // Number Formatter
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    // Build Time
    float buildTime = [[_buildingDict objectForKey:@"build_time"] floatValue];
    buildTime=(buildTime*[[GameManager sharedInstance] speed])*_amount;
    _buildingTime.text = [NSString stringWithFormat:@"%@s",[[NSNumber numberWithInt:buildTime] stringValue]];
    
    int value = 0;
    
    // Set Cost / Incomes
    // Food
    value = [[_buildingDict objectForKey:@"cost_food"] intValue];
    value*=_amount;
    _buildingCostFood.text  = [formatter stringFromNumber:[NSNumber numberWithInt:value]];
    // Workers
    value = [[_buildingDict objectForKey:@"cost_workers"] intValue];
    value*=_amount;
    _buildingCostWorkers.text  = [formatter stringFromNumber:[NSNumber numberWithInt:value]];
    // Energy
    value = [[_buildingDict objectForKey:@"cost_energy"] intValue];
    value*=_amount;
    _buildingCostEnergy.text  = [formatter stringFromNumber:[NSNumber numberWithInt:value]];
    // Minerals
    value = 0;
    value*=_amount;
    _buildingCostMinerals.text  = [formatter stringFromNumber:[NSNumber numberWithInt:value]];
  
    // Set Rates
    // Food
    value = [[_buildingDict objectForKey:@"income_food"] intValue];
    value*=_amount;
    [_buildingRateFood setTextRate:[NSNumber numberWithInt:value]];
    
    // Workers
    value = [[_buildingDict objectForKey:@"income_workers"] intValue];
    value*=_amount;
    [_buildingRateWorkers setTextRate:[NSNumber numberWithInt:value]];
    
    // Energy
    value = [[_buildingDict objectForKey:@"income_energy"] intValue];
    value*=_amount;
    [_buildingRateEnergy setTextRate:[NSNumber numberWithInt:value]];
    
    // Minerals
    value = [[_buildingDict objectForKey:@"income_minerals"] intValue];
    value*=_amount;
    [_buildingRateMinerals setTextRate:[NSNumber numberWithInt:value]];

    // Rate Multiplier
    _buildingCostAmount.text = [NSString stringWithFormat:@"x%d",_amount];
    _buildingRateAmount.text = [NSString stringWithFormat:@"x%d",_amount];
}

#pragma mark UI Action Controls
- (IBAction) stepperValueChanged:(id)sender
{
    _amount = _stepperAmount.value;
    [self updateAmount];
}



@end
