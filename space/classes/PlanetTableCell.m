//
//  PlanetTableCell.m
//  space
//
//  Created by Martin Walsh on 25/10/2012.
//  Copyright (c) 2012 Pedro LTD. All rights reserved.
//

#import "GameManager.h"
#import "PlanetTableCell.h"

@implementation PlanetTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"PlanetTableCell" owner:self options:nil];
        self = [nibArray objectAtIndex:0];
        [self applyDefaultStyle];
    }
    return self;
}

- (void)applyDefaultStyle {
    
    // Cornered
    self.layer.cornerRadius = 4;
    self.layer.borderColor = [UIColor colorWithRed:6/255.0f green:50/255.0f blue:65/255.0f alpha:1.0f].CGColor;
    self.layer.borderWidth = 2.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// Adjust Size To Match XIB Frame
- (void)setFrame:(CGRect)frame {
    float inset = 10.0f;
    frame.origin.x += inset;
    frame.size.width -= 2 * inset;
    frame.size.height -= 2 * 2.5f;
    [super setFrame:frame];
}

-(void) refresh:(NSDictionary*) planetDict;
{
    // Number Formatter
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber* number;
    
    // Name
    _planetName.text = [planetDict objectForKey:@"name"];
    
    // System
    _planetSystem.text = [NSString stringWithFormat:@"%@ System",[[planetDict objectForKey:@"system"] objectForKey:@"name"]];
    
    // Score
    number = [NSNumber numberWithInt:[[planetDict objectForKey:@"score"] integerValue]];
    _planetScore.text = [formatter stringFromNumber:number];
    
}

@end
