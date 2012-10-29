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
@property (nonatomic) IBOutlet UILabel* buildingDescription;
@property (nonatomic) IBOutlet UILabel* buildingAmount;

@property (nonatomic) IBOutlet UILabel* buildingEnergy;
@property (nonatomic) IBOutlet UILabel* buildingWorkers;
@property (nonatomic) IBOutlet UILabel* buildingFood;
@property (nonatomic) IBOutlet UILabel* buildingMinerals;

@property (nonatomic, readwrite) int buildingID;

-(void) refresh:(NSDictionary*) buildingDict;


@end
