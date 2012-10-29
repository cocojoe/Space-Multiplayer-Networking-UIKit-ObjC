//
//  BuildingBuildView.h
//  space
//
//  Created by Martin Walsh on 29/10/2012.
//  Copyright (c) 2012 Pedro LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuildingBuildView : UIView

@property (nonatomic) NSDictionary* buildingDict;

@property (nonatomic) IBOutlet UILabel* buildingName;
@property (nonatomic) IBOutlet UILabel* buildingDescription;
@property (nonatomic) IBOutlet UILabel* buildingTime;

@property (nonatomic) IBOutlet UILabel* buildingCostEnergy;
@property (nonatomic) IBOutlet UILabel* buildingCostWorkers;
@property (nonatomic) IBOutlet UILabel* buildingCostFood;
@property (nonatomic) IBOutlet UILabel* buildingCostMinerals;
@property (nonatomic) IBOutlet UILabel* buildingCostAmount;

@property (nonatomic) IBOutlet UILabel* buildingRateEnergy;
@property (nonatomic) IBOutlet UILabel* buildingRateWorkers;
@property (nonatomic) IBOutlet UILabel* buildingRateFood;
@property (nonatomic) IBOutlet UILabel* buildingRateMinerals;
@property (nonatomic) IBOutlet UILabel* buildingRateAmount;

@property (nonatomic,readwrite) int amount;

// UI Controls
@property (nonatomic) IBOutlet UIStepper* stepperAmount;
-(IBAction) stepperValueChanged:(id)sender;

-(void) refresh:(NSDictionary*) buildingDict;

@end
