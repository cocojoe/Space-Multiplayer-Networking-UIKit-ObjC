//
//  BuildingCell.m
//  space
//
//  Created by Martin Walsh on 26/10/2012.
//  Copyright (c) 2012 Pedro LTD. All rights reserved.
//

#import "BuildingCell.h"

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
    
    //NSNumber* number;
    
    // Name
    _buildingName.text = [buildingDict objectForKey:@"name"];
    _buildingDescription.text = [buildingDict objectForKey:@"description"];
    
    /*
    // Score
    number = [NSNumber numberWithInt:[[planetDict objectForKey:@"score"] integerValue]];
    _planetScore.text = [formatter stringFromNumber:number];
    */
    
}

@end
