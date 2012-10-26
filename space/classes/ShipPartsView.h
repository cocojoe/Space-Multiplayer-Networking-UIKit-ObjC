//
//  ShipPartsView.h
//  space
//
//  Created by Martin Walsh on 26/10/2012.
//  Copyright (c) 2012 Pedro LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class PartView;

@interface ShipPartsView : UIView

@property (nonatomic) IBOutlet PartView* partHull;
@property (nonatomic) IBOutlet PartView* partShields;
@property (nonatomic) IBOutlet PartView* partWeapons;
@property (nonatomic) IBOutlet PartView* partNavigation;
@property (nonatomic) IBOutlet PartView* partPropulsion;
@property (nonatomic) IBOutlet PartView* partSensors;
@property (nonatomic) IBOutlet PartView* partEnergy;

-(void) refresh:(NSMutableArray*) parts;

@end
