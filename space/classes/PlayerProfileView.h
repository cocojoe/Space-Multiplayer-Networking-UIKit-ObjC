//
//  PlayerProfileView.h
//  space
//
//  Created by Martin Walsh on 17/10/2012.
//  Copyright (c) 2012 Pedro LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface PlayerProfileView : UIView

// Player Profile
@property (nonatomic) IBOutlet UILabel *labelPlayerName;
@property (nonatomic) IBOutlet UILabel *labelPlayerScore;
@property (nonatomic) IBOutlet UILabel *labelPlayerCurrencyCash;
@property (nonatomic) IBOutlet UILabel *labelPlayerCurrencyPremium;

-(void) refresh:(NSDictionary*) playerDict;

@end
