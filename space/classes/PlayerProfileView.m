//
//  PlayerProfileView.m
//  space
//
//  Created by Martin Walsh on 17/10/2012.
//  Copyright (c) 2012 Pedro LTD. All rights reserved.
//

#import "PlayerProfileView.h"
#import "GameManager.h"

@implementation PlayerProfileView

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
        [self applyDefaultStyle];
    }
    return self;
}

- (void)applyDefaultStyle {
    
    // Cornered
    self.layer.cornerRadius = 4;
}

-(void) refresh:(NSDictionary*) playerDict
{
    // Process JSON
    
    // Date Formatter from Unix Timestamp
    /*
     NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[jsonDict objectForKey:@"time"] doubleValue]];
     NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
     [dateFormat setDateFormat:@"yyyy'-'MM'-'dd HH':'mm':'ss"];
     _labelServerTime.text = [dateFormat stringFromDate:date];
     */
    
    // Currency Child Dictionary
    NSDictionary *currencyDict = [NSDictionary dictionaryWithDictionary:[playerDict objectForKey:@"currency"]];
    
    //// IB Outlets Profile
    // Name
    _labelPlayerName.text = [playerDict objectForKey:@"name"];
    
    // Number Formatter
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    // Cash
    NSNumber* cash = [NSNumber numberWithInt:[[currencyDict objectForKey:@"cash"] integerValue]];
    _labelPlayerCurrencyCash.text = [formatter stringFromNumber:cash];
    
    // Premium
    NSNumber* premium = [NSNumber numberWithInt:[[currencyDict objectForKey:@"premium"] integerValue]];
    _labelPlayerCurrencyPremium.text = [formatter stringFromNumber:premium];
    
    // Score
    NSNumber* score = [NSNumber numberWithInt:[[playerDict objectForKey:@"score"] integerValue]];
    _labelPlayerScore.text = [formatter stringFromNumber:score];
}

@end
