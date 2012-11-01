//
//  BuildingCell.m
//  space
//
//  Created by Martin Walsh on 26/10/2012.
//  Copyright (c) 2012 Pedro LTD. All rights reserved.
//

#import "BuildingCell.h"
#import "GameManager.h"
#import "UILabel+formatHelpers.h"

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
    
    // Build Time
    [_buildingTime setTimerText:[buildingDict objectForKey:@"time"]];
    
    // Load Icon
    if([buildingDict objectForKey:@"image"]!=[NSNull null])
    {
        [_buildingIcon setImage:[UIImage imageNamed:[buildingDict objectForKey:@"image"]]];
    }
}

@end
