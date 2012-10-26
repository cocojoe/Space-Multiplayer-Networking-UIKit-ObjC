//
//  PlanetDetailView.h
//  space
//
//  Created by Martin Walsh on 25/10/2012.
//  Copyright (c) 2012 Pedro LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface PlanetDetailView : UIView

@property (nonatomic) IBOutlet UILabel* planetName;
@property (nonatomic) IBOutlet UILabel* planetSystem;

@property (nonatomic) IBOutlet UILabel* planetScore;
@property (nonatomic) IBOutlet UILabel* planetFood;
@property (nonatomic) IBOutlet UILabel* planetWorker;
@property (nonatomic) IBOutlet UILabel* planetEnergy;

@property (nonatomic) IBOutlet UILabel* planetFoodRate;
@property (nonatomic) IBOutlet UILabel* planetWorkerRate;
@property (nonatomic) IBOutlet UILabel* planetEnergyRate;

-(void) refresh:(NSDictionary*) playerDict;

@end
