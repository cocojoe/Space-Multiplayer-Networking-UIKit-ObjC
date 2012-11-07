//
//  PlanetTableCell.h
//  space
//
//  Created by Martin Walsh on 25/10/2012.
//  Copyright (c) 2012 Pedro LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface PlanetTableCell : UITableViewCell

@property (nonatomic) IBOutlet UILabel* planetName;
@property (nonatomic) IBOutlet UILabel* planetScore;
@property (nonatomic) IBOutlet UILabel* planetSystem;

-(void) refresh:(NSDictionary*) planetDict;

@end
