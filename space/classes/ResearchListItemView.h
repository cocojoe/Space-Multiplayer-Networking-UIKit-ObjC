//
//  ResearchListItemView.h
//  space
//
//  Created by Martin Walsh on 02/11/2012.
//  Copyright (c) 2012 Pedro LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResearchListItemView : UIView

@property (nonatomic, readwrite) int itemID;

@property (nonatomic) IBOutlet UILabel* name;

@property (nonatomic) IBOutlet UILabel* costEnergy;
@property (nonatomic) IBOutlet UILabel* costWorkers;
@property (nonatomic) IBOutlet UILabel* costFood;
@property (nonatomic) IBOutlet UILabel* costMinerals;

#pragma mark Data Handling
-(void) refresh:(NSNumber*) itemID;

// Buttons
@property (nonatomic) IBOutlet UIButton* button;
-(IBAction) buttonPressed:(id)sender;

@end
