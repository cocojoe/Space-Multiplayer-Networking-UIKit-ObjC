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

-(void) setTimerText:(NSNumber *)time
{
    double buildTime = [time doubleValue];
    
    float hours   = floorf(buildTime/(60*24));
    float minutes = floorf(buildTime/60);
    float seconds = roundf(buildTime - minutes * 60);
    self.text = [NSString stringWithFormat:@"%02d:%02d:%02d",(int)hours,(int)minutes,(int)seconds];
}

@end
