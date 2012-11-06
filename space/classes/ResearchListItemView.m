//
//  ResearchListItemView.m
//  space
//
//  Created by Martin Walsh on 02/11/2012.
//  Copyright (c) 2012 Pedro LTD. All rights reserved.
//

#import "ResearchListItemView.h"
#import "GameManager.h"
#import "UILabel+formatHelpers.h"

@implementation ResearchListItemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self applyDefaultStyle];
    }
    return self;
}

// Initialization From NIB
- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if(self) {
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

-(void) refresh:(NSNumber*) itemID
{
    
    // Modify Button
    UIImage *buttonImage = [[UIImage imageNamed:@"blueButton"]
                            resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
    [_button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    
    // Number Formatter
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];

    NSDictionary* itemDict = [[GameManager sharedInstance] getResearch:[itemID intValue]];
   
    // Internal
    _itemID = [itemID intValue];
    
    // Basics
    [_name setText:[itemDict objectForKey:@"name"]];
    

    // Cost
    NSDictionary* costDict = [itemDict objectForKey:@"cost"];
    
    // Food
    [_costFood setTextNegativeRate:[NSNumber numberWithInt:[[costDict objectForKey:@"food"] integerValue]]];
    
    // Workers
    [_costWorkers setTextNegativeRate:[NSNumber numberWithInt:[[costDict objectForKey:@"workers"] integerValue]]];
    
    // Energy
    [_costEnergy setTextNegativeRate:[NSNumber numberWithInt:[[costDict objectForKey:@"energy"] integerValue]]];
    
    // Minerals
    [_costMinerals setTextNegativeRate:[NSNumber numberWithInt:0]];
    
 
}

// Button Pressed
-(IBAction) buttonPressed:(id)sender
{
    //UIButton *button = (UIButton *) sender;
    // Universal Popup
    [[GameManager sharedInstance] createPopup:ePopupResearch setItem:_itemID];
}

@end
