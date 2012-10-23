//
//  InventoryCell.m
//  space
//
//  Created by Martin Walsh on 18/10/2012.
//  Copyright (c) 2012 Pedro LTD. All rights reserved.
//

#import "InventoryCell.h"
#import "GameManager.h"

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
    
    NSDictionary* item      = [cellDict objectForKey:@"item"];
    NSDictionary* itemGroup = [cellDict objectForKey:@"group"];
    
    // Name
    self.labelName.text = [item objectForKey:@"name"];
    
    // Description
    if([[item objectForKey:@"description"] length]>0)
    {
        self.labelDescription.text = [NSString stringWithFormat:@"\"%@\"",[item objectForKey:@"description"]];
    } else {
        self.labelDescription.text = [NSString stringWithFormat:@"\"%@\"",@"No description."];
    }
    
    // Description
    if([itemGroup objectForKey:@"name"] == [NSNull null])
    {
        self.labelGroup.text = @"Other";
    } else {
        self.labelGroup.text = [itemGroup objectForKey:@"name"];
    }
    
    // Image
    if([[item objectForKey:@"icon"] length]>0)
    {
        self.imageIcon.image = [UIImage imageNamed:[item objectForKey:@"icon"]];
    } else {
        // Dummy Holder
        self.imageIcon.image = [UIImage imageNamed:@"item_default"];
    }
    
    // Amount (Formatted)
    NSNumber* amount = [NSNumber numberWithInt:[[cellDict objectForKey:@"amount"] integerValue]];
    self.labelAmount.text = [formatter stringFromNumber:amount];

}

@end
