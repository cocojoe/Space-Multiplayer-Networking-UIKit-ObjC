//
//  BuildingListItemView.h
//  space
//
//  Created by Martin Walsh on 29/10/2012.
//  Copyright (c) 2012 Pedro LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface BuildingListItemView : UIView

@property (nonatomic) IBOutlet UILabel* buildingName;
@property (nonatomic) IBOutlet UILabel* buildingAmount;

@property (nonatomic) IBOutlet UILabel* buildingEnergy;
@property (nonatomic) IBOutlet UILabel* buildingWorkers;
@property (nonatomic) IBOutlet UILabel* buildingFood;
@property (nonatomic) IBOutlet UILabel* buildingMinerals;

@property (nonatomic, readwrite) int buildingID;
@property (nonatomic, readwrite) int buildingTime;

-(void) refresh:(NSDictionary*) buildingDict;

// Buttons
@property (nonatomic) IBOutlet UIButton* button;
-(IBAction) buttonPressed:(id)sender;


@end
