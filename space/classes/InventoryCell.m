//
//  InventoryCell.m
//  space
//
//  Created by Martin Walsh on 18/10/2012.
//  Copyright (c) 2012 Pedro LTD. All rights reserved.
//

#import "InventoryCell.h"

@implementation InventoryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"InventoryCell" owner:self options:nil];
        self = [nibArray objectAtIndex:0];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) refresh:(NSDictionary*) cellDict;
{
    // Number Formatter
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    // Name
    self.labelName.text = [cellDict objectForKey:@"name"];
    
    // Description
    if([cellDict objectForKey:@"description"] == [NSNull null])
    {
        self.labelDescription.text = [NSString stringWithFormat:@"\"%@\"",@"Describe Me!"];
    } else {
        self.labelDescription.text = [NSString stringWithFormat:@"\"%@\"",[cellDict objectForKey:@"description"]];
    }
    
    // Description
    if([cellDict objectForKey:@"group_name"] == [NSNull null])
    {
        self.labelGroup.text = @"Misc";
    } else {
        self.labelGroup.text = [cellDict objectForKey:@"group_name"];
    }
    
    // Image
    if([cellDict objectForKey:@"icon"] != [NSNull null])
    {
        self.imageIcon.image = [UIImage imageNamed:[cellDict objectForKey:@"icon"]];
    }
    
    // Amount (Formatted)
    NSNumber* amount = [NSNumber numberWithInt:[[cellDict objectForKey:@"amount"] integerValue]];
    self.labelAmount.text = [formatter stringFromNumber:amount];

}

@end
