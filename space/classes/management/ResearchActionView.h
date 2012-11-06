//
//  ResearchActionView.h
//  space
//
//  Created by Martin Walsh on 05/11/2012.
//  Copyright (c) 2012 Pedro LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResearchActionView : UIView

@property (nonatomic) IBOutlet UILabel* name;
@property (nonatomic) IBOutlet UILabel* description;
@property (nonatomic) IBOutlet UILabel* time;

// Internal
@property (nonatomic,readwrite) int itemID;

// Interface
@property (nonatomic) IBOutlet UIButton* button;
-(IBAction) buttonPressed:(id)sender;

#pragma mark Creation
-(void) setup:(int) itemID;

@end
