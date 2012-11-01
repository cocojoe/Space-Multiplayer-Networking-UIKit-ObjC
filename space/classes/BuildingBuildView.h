//
//  BuildingBuildView.h
//  space
//
//  Created by Martin Walsh on 29/10/2012.
//  Copyright (c) 2012 Pedro LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BuildingSelectionTableViewController;

@interface BuildingBuildView : UIView

#pragma mark Original Data
@property (nonatomic) NSDictionary* buildingDict;

#pragma mark IB Outlets
@property (nonatomic) IBOutlet UILabel* buildingName;
@property (nonatomic) IBOutlet UIImageView* buildingIcon;
@property (nonatomic) IBOutlet UILabel* buildingTime;

@property (nonatomic) IBOutlet UILabel* buildingCostEnergy;
@property (nonatomic) IBOutlet UILabel* buildingCostWorkers;
@property (nonatomic) IBOutlet UILabel* buildingCostFood;
@property (nonatomic) IBOutlet UILabel* buildingCostMinerals;

@property (nonatomic) IBOutlet UILabel* buildingRateEnergy;
@property (nonatomic) IBOutlet UILabel* buildingRateWorkers;
@property (nonatomic) IBOutlet UILabel* buildingRateFood;
@property (nonatomic) IBOutlet UILabel* buildingRateMinerals;
@property (nonatomic) IBOutlet UILabel* buildingRateAmount;

#pragma mark Internal Reference
@property (nonatomic,readwrite) int amount;
@property (nonatomic,readwrite) int building_id;
@property (weak,nonatomic) BuildingSelectionTableViewController* parent;

#pragma mark Actions
@property (nonatomic) IBOutlet UIStepper* stepperAmount;
-(IBAction) stepperValueChanged:(id)sender;
@property (nonatomic) IBOutlet UIButton* button;
-(IBAction) buttonPressed:(id)sender;

#pragma mark Creation
-(void) setup:(NSDictionary*) buildingDict;

@end
