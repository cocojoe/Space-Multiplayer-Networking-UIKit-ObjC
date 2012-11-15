//
//  ResearchActionView.m
//  space
//
//  Created by Martin Walsh on 05/11/2012.
//  Copyright (c) 2012 Pedro LTD. All rights reserved.
//

#import "GameManager.h"
#import "ResearchActionView.h"
#import "UILabel+formatHelpers.h"

@implementation ResearchActionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Initialization From NIB
- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if(self) {
    }
    return self;
}

#pragma mark Creation
-(void) setup:(int) itemID
{
    
    // Modify Button
    UIImage *buttonImage = [[UIImage imageNamed:@"blueButton"]
                            resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
    [_button setBackgroundImage:buttonImage forState:UIControlStateNormal];

    
    NSDictionary* researchDict = [[GameManager sharedInstance] getResearch:itemID];
    
    _name.text = [researchDict objectForKey:@"name"];
    _description.text = [NSString stringWithFormat:@"\"%@\"",[researchDict objectForKey:@"description"]];
 
    [_time setTimerText:[NSNumber numberWithInt:_itemTime]];
    
    // Set Internals
    _itemID = itemID;
}

-(IBAction) buttonPressed:(id)sender
{

    [[GameManager sharedInstance] addResearch:_itemID setPlanet:[[GameManager sharedInstance] planetID]  setBlock:^(NSDictionary *jsonDict){
        
        double time = [[[jsonDict objectForKey:@"research"] objectForKey:@"end_time"] doubleValue];
        
        // Format Time
        // Date Formatter from Unix Timestamp
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy'-'MM'-'dd HH':'mm':'ss"];
        
        [[TKAlertCenter defaultCenter] postAlertWithMessage:[NSString stringWithFormat:@"Research Added to Queue\n ETA: %@",[dateFormat stringFromDate:date]]];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"researchRefresh" object:self];
        
        // Set Notification
        [[GameManager sharedInstance] createNotification:time setMessage:[NSString stringWithFormat:@"Research Complete"]];
        
        
    } setBlockFail:^(){
        // TODO
    }];

    
    // Dismiss
    [[GameManager sharedInstance] dismissPopup:nil];

}


@end
