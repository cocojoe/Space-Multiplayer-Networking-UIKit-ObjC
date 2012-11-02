//
//  UILabel+setColourDirection.m
//  space
//
//  Created by Martin Walsh on 29/10/2012.
//  Copyright (c) 2012 Pedro LTD. All rights reserved.
//

#import "UILabel+formatHelpers.h"

@implementation UILabel (formatHelpers)

-(void) setColorDirection:(NSNumber*) number
{
    // +/- Colouring
    if([number intValue]>0)
        [self setTextColor:[UIColor greenColor]];
    else if([number intValue]<0)
        [self setTextColor:[UIColor redColor]];
}

-(void) setTextRate:(NSNumber*) rate
{
    // Number Formatter
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    if([rate intValue]>0)
        [self setText:[NSString stringWithFormat:@"+%@",[formatter stringFromNumber:rate]]];
    else
        [self setText:[NSString stringWithFormat:@"%@",[formatter stringFromNumber:rate]]];
        
    [self setColorDirection:rate];
}

-(void) setTextNegativeRate:(NSNumber*) rate
{
    // Number Formatter
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];

    [self setText:[NSString stringWithFormat:@"-%@",[formatter stringFromNumber:rate]]];
    
   [self setTextColor:[UIColor redColor]];
}

-(void) setTimerText:(NSNumber *)time
{
    int buildTime = [time intValue];
    
    int hours   = floor(buildTime / 3600);
    int minutes = floor((buildTime / 60) % 60);
    int seconds = round(buildTime % 60);
    self.text = [NSString stringWithFormat:@"%02d:%02d:%02d",hours,minutes,seconds];
}

@end
