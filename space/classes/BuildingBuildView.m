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
#import "BuildingSelectionTableViewController.h"

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


-(void) setup:(NSDictionary *)buildingDict
{
    // Setup Stepper
    _stepperAmount.maximumValue = 10;
    _stepperAmount.minimumValue = 1;
    _stepperAmount.value        = _amount;
    _stepperAmount.stepValue    = 1;
    
    // Modify Button
    UIImage *buttonImage = [[UIImage imageNamed:@"blueButton"]
                            resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
    [_button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    
    // Store Dictionary
    _buildingDict = [NSDictionary dictionaryWithDictionary:buildingDict];
    
    // Basic Outlets
    _buildingName.text        = [buildingDict objectForKey:@"name"];
    
    // Building ID
    _building_id = [[buildingDict objectForKey:@"id"] intValue];
    
    // Load Icon
    if([buildingDict objectForKey:@"image"]!=[NSNull null])
    {
        [_buildingIcon setImage:[UIImage imageNamed:[buildingDict objectForKey:@"image"]]];
    }
    
    // Dynamic Updates
    [self updateAmount];
    
    self.alpha = 0.0f;
    [UIView animateWithDuration:0.25f
                          delay:0.0f
                        options: UIViewAnimationCurveLinear
                     animations:^{
                         self.alpha = 1.0f;
                     }
                     completion:^(BOOL finished){
                     }];
}

-(void) updateAmount
{
    // Number Formatter
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    // Build Time
    double buildTime = [[_buildingDict objectForKey:@"time"] doubleValue];
    buildTime*=_amount;
    [_buildingTime setTimerText:[NSNumber numberWithDouble:buildTime]];
    
    int value = 0;
    
    // Costs
    NSDictionary* costDict = [_buildingDict objectForKey:@"cost"];
    
    // Set Cost / Incomes
    // Food
    value = [[costDict objectForKey:@"food"] intValue];
    value*=_amount;
    _buildingCostFood.text  = [formatter stringFromNumber:[NSNumber numberWithInt:value]];
    // Workers
    value = [[costDict objectForKey:@"workers"] intValue];
    value*=_amount;
    _buildingCostWorkers.text  = [formatter stringFromNumber:[NSNumber numberWithInt:value]];
    // Energy
    value = [[costDict objectForKey:@"energy"] intValue];
    value*=_amount;
    _buildingCostEnergy.text  = [formatter stringFromNumber:[NSNumber numberWithInt:value]];
    // Minerals
    value = 0;
    value*=_amount;
    _buildingCostMinerals.text  = [formatter stringFromNumber:[NSNumber numberWithInt:value]];
  
    
    NSDictionary* incomeDict = [_buildingDict objectForKey:@"income"];
    
    // Set Rates
    // Food
    value = [[incomeDict objectForKey:@"food"] intValue];
    value*=_amount;
    [_buildingRateFood setTextRate:[NSNumber numberWithInt:value]];
    
    // Workers
    value = [[incomeDict objectForKey:@"workers"] intValue];
    value*=_amount;
    [_buildingRateWorkers setTextRate:[NSNumber numberWithInt:value]];
    
    // Energy
    value = [[incomeDict objectForKey:@"energy"] intValue];
    value*=_amount;
    [_buildingRateEnergy setTextRate:[NSNumber numberWithInt:value]];
    
    // Minerals
    value = [[incomeDict objectForKey:@"minerals"] intValue];
    value*=_amount;
    [_buildingRateMinerals setTextRate:[NSNumber numberWithInt:value]];

    // Rate Multiplier
    _buildingRateAmount.text = [NSString stringWithFormat:@"x%d",_amount];
    
}

#pragma mark UI Action Controls
- (IBAction) stepperValueChanged:(id)sender
{
    _amount = _stepperAmount.value;
    [self updateAmount];
}

-(IBAction) buttonPressed:(id)sender
{
    [self lockUI];
    
    [[GameManager sharedInstance] addBuilding:_building_id setAmount:_amount setPlanet:[[GameManager sharedInstance] planetID]  setBlock:^(NSDictionary *jsonDict){
        
        double time = [[[jsonDict objectForKey:@"build"] objectForKey:@"end_time"] doubleValue];
        // Format Time
        // Date Formatter from Unix Timestamp
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy'-'MM'-'dd HH':'mm':'ss"];
        
        [[TKAlertCenter defaultCenter] postAlertWithMessage:[NSString stringWithFormat:@"Building Added to Queue\n ETA: %@",[dateFormat stringFromDate:date]]];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"buildingRefresh" object:self];
        
        // Set Notification
        [[GameManager sharedInstance] createNotification:time setMessage:[NSString stringWithFormat:@"%@ completed",_buildingName.text]];
        
    } setBlockFail:^(){
        [self unlockUI];
    }];

}

-(void) lockUI
{
    [_button setUserInteractionEnabled:NO];
    [_stepperAmount setUserInteractionEnabled:NO];
}

-(void) unlockUI
{
    [_button setUserInteractionEnabled:YES];
    [_stepperAmount setUserInteractionEnabled:YES];
}


@end
