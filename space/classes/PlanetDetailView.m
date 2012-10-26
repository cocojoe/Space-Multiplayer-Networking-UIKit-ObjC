//
//  PlanetDetailView.m
//  space
//
//  Created by Martin Walsh on 25/10/2012.
//  Copyright (c) 2012 Pedro LTD. All rights reserved.
//

#import "PlanetDetailView.h"

@implementation PlanetDetailView

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

-(void) refresh:(NSDictionary*) planetDict
{
    // Process JSON

    //// IB Outlets Profile
    // Name
    _planetName.text = [planetDict objectForKey:@"name"];
    
    // System
    _planetSystem.text = [NSString stringWithFormat:@"%@ System",[[planetDict objectForKey:@"system"] objectForKey:@"name"]];
    
    // Number Formatter
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSNumber* number;
    // Score
    number = [NSNumber numberWithInt:[[planetDict objectForKey:@"score"] integerValue]];
    _planetScore.text = [formatter stringFromNumber:number];
    
    // Food
    number = [NSNumber numberWithInt:[[planetDict objectForKey:@"food"] integerValue]];
    _planetFood.text = [formatter stringFromNumber:number];
    number = [NSNumber numberWithInt:[[planetDict objectForKey:@"food_rate"] integerValue]];
    _planetFoodRate.text = [NSString stringWithFormat:@"+%@",[formatter stringFromNumber:number]];
    
    // Workers
    number = [NSNumber numberWithInt:[[planetDict objectForKey:@"workers"] integerValue]];
    _planetWorker.text = [formatter stringFromNumber:number];
    number = [NSNumber numberWithInt:[[planetDict objectForKey:@"worker_rate"] integerValue]];
    _planetWorkerRate.text = [NSString stringWithFormat:@"+%@",[formatter stringFromNumber:number]];

    
    // Energy
    number = [NSNumber numberWithInt:[[planetDict objectForKey:@"energy"] integerValue]];
    _planetEnergy.text = [formatter stringFromNumber:number];
    number = [NSNumber numberWithInt:[[planetDict objectForKey:@"energy_rate"] integerValue]];
    _planetEnergyRate.text = [NSString stringWithFormat:@"+%@",[formatter stringFromNumber:number]];

}


@end
