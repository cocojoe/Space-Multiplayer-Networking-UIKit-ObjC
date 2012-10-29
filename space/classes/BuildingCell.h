//
//  BuildingCell.h
//  space
//
//  Created by Martin Walsh on 26/10/2012.
//  Copyright (c) 2012 Pedro LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuildingCell : UITableViewCell

@property (nonatomic) IBOutlet UILabel* buildingName;
@property (nonatomic) IBOutlet UILabel* buildingDescription;
@property (nonatomic) IBOutlet UILabel* buildingTime;

@property (nonatomic) IBOutlet UILabel* buildingCostEnergy;
@property (nonatomic) IBOutlet UILabel* buildingCostWorkers;
@property (nonatomic) IBOutlet UILabel* buildingCostFood;
@property (nonatomic) IBOutlet UILabel* buildingCostMinerals;


-(void) refresh:(NSDictionary*) buildingDict;

@end
