//
//  PlanetDetailView.m
//  space
//
//  Created by Martin Walsh on 25/10/2012.
//  Copyright (c) 2012 Pedro LTD. All rights reserved.
//

#import "PlanetDetailView.h"
#import "UILabel+formatHelpers.h"

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
    number = [NSNumber numberWithInt:[[planetDict objectForKey:@"score"] intValue]];
    _planetScore.text = [formatter stringFromNumber:number];
    
    // Food
    number = [NSNumber numberWithInt:[[planetDict objectForKey:@"food"] intValue]];
    _planetFood.text = [formatter stringFromNumber:number];
    
    number = [NSNumber numberWithInt:[[planetDict objectForKey:@"food_rate"] intValue]];
    [_planetFoodRate setTextRate:number];
    
    // Workers
    number = [NSNumber numberWithInt:[[planetDict objectForKey:@"workers"] intValue]];
    _planetWorker.text = [formatter stringFromNumber:number];
    
    number = [NSNumber numberWithInt:[[planetDict objectForKey:@"worker_rate"] intValue]];
    [_planetWorkerRate setTextRate:number];
    
    
    // Energy
    number = [NSNumber numberWithInt:[[planetDict objectForKey:@"energy"] intValue]];
    _planetEnergy.text = [formatter stringFromNumber:number];
    
    number = [NSNumber numberWithInt:[[planetDict objectForKey:@"energy_rate"] intValue]];
    [_planetEnergyRate setTextRate:number];
    
    // Mineral
    number = [NSNumber numberWithInt:[[planetDict objectForKey:@"mineral"] intValue]];
    _planetMineral.text = [formatter stringFromNumber:number];
    
    number = [NSNumber numberWithInt:[[planetDict objectForKey:@"mineral_rate"] intValue]];
    [_planetMineralRate setTextRate:number];

}


@end
