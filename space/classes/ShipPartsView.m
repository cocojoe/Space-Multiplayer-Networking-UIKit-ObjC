//
//  ShipPartsView.m
//  space
//
//  Created by Martin Walsh on 26/10/2012.
//  Copyright (c) 2012 Pedro LTD. All rights reserved.
//

#import "ShipPartsView.h"

#import "PartView.h"
#import "GameManager.h"

#define PART_HULL          7
#define PART_SHIELDS       8
#define PART_WEAPONS       9
#define PART_NAVIGATION    10
#define PART_PROPULSION    11
#define PART_SENSORS       12
#define PART_ENERGY        13

@implementation ShipPartsView

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
}

-(void) refresh:(NSMutableArray*) parts
{
    
    // Check Hull
    [_partHull setupPartID:PART_HULL];
    for(NSDictionary* part in parts)
    {
        if([[part objectForKey:@"part_id"] integerValue]==PART_HULL)
            [_partHull refresh:[[part objectForKey:@"item_id"] integerValue]];
    }
    
    // Check Shields
    [_partShields setupPartID:PART_SHIELDS];
    for(NSDictionary* part in parts)
    {
        if([[part objectForKey:@"part_id"] integerValue]==PART_SHIELDS)
            [_partShields refresh:[[part objectForKey:@"item_id"] integerValue]];
    }
    
    // Check Weapons
    [_partWeapons setupPartID:PART_WEAPONS];
    for(NSDictionary* part in parts)
    {
        if([[part objectForKey:@"part_id"] integerValue]==PART_WEAPONS)
            [_partWeapons refresh:[[part objectForKey:@"item_id"] integerValue]];
    }
    
    // Check Navigation
    [_partNavigation setupPartID:PART_NAVIGATION];
    for(NSDictionary* part in parts)
    {
        if([[part objectForKey:@"part_id"] integerValue]==PART_NAVIGATION)
            [_partNavigation refresh:[[part objectForKey:@"item_id"] integerValue]];
    }
    
    // Check Propulsion
    [_partPropulsion setupPartID:PART_PROPULSION];
    for(NSDictionary* part in parts)
    {
        if([[part objectForKey:@"part_id"] integerValue]==PART_PROPULSION)
            [_partPropulsion refresh:[[part objectForKey:@"item_id"] integerValue]];
    }
    
    // Check Sensors
    [_partSensors setupPartID:PART_SENSORS];
    for(NSDictionary* part in parts)
    {
        if([[part objectForKey:@"part_id"] integerValue]==PART_SENSORS)
            [_partSensors refresh:[[part objectForKey:@"item_id"] integerValue]];
    }
    
    // Check Energy
    [_partEnergy setupPartID:PART_ENERGY];
    for(NSDictionary* part in parts)
    {
        if([[part objectForKey:@"part_id"] integerValue]==PART_ENERGY)
            [_partEnergy refresh:[[part objectForKey:@"item_id"] integerValue]];
    }
    
}

@end


