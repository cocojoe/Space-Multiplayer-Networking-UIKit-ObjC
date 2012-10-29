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


@end
