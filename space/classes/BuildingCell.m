//
//  BuildingCell.m
//  space
//
//  Created by Martin Walsh on 26/10/2012.
//  Copyright (c) 2012 Pedro LTD. All rights reserved.
//

#import "BuildingCell.h"
#import "GameManager.h"

@implementation BuildingCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"BuildingCell" owner:self options:nil];
        self = [nibArray objectAtIndex:0];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) refresh:(NSDictionary*) buildingDict;
{
    // Number Formatter
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    // Name
    _buildingName.text = [buildingDict objectForKey:@"name"];
    _buildingDescription.text = [buildingDict objectForKey:@"description"];
    
    // Build Time
    float buildTime = [[buildingDict objectForKey:@"build_time"] floatValue];
    buildTime*=[[GameManager sharedInstance] speed];
    _buildingTime.text = [NSString stringWithFormat:@"%@s",[[NSNumber numberWithInt:buildTime] stringValue]];
    
    // Set Cost / Incomes
    NSNumber* number;
    // Food
    number = [buildingDict objectForKey:@"cost_food"];
    _buildingCostFood.text  = [formatter stringFromNumber:number];
    // Workers
    number = [buildingDict objectForKey:@"cost_workers"];
    _buildingCostWorkers.text  = [formatter stringFromNumber:number];
    // Energy
    number = [buildingDict objectForKey:@"cost_energy"];
    _buildingCostEnergy.text  = [formatter stringFromNumber:number];
    // Minerals
    number = [NSNumber numberWithInt:0];
    _buildingCostMinerals.text  = [formatter stringFromNumber:number];
    
}

@end
