//
//  BuildingListItemView.m
//  space
//
//  Created by Martin Walsh on 29/10/2012.
//  Copyright (c) 2012 Pedro LTD. All rights reserved.
//

#import "BuildingListItemView.h"
#import "BuildingBuildView.h"
#import "GameManager.h"
#import "UILabel+formatHelpers.h"

@implementation BuildingListItemView

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
    self.layer.borderColor = [UIColor colorWithRed:6/255.0f green:50/255.0f blue:65/255.0f alpha:1.0f].CGColor;
    self.layer.borderWidth = 2.0f;
}

-(void) refresh:(NSDictionary*) buildingDict
{
    
    // Modify Button
    UIImage *buttonImage = [[UIImage imageNamed:@"blueButton"]
                            resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
    [_button setBackgroundImage:buttonImage forState:UIControlStateNormal];
   
    // Number Formatter
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    int value = 0;
    int qty   = 0;
    
    // Lookup Building
    for(NSDictionary* buildingDetail in [[GameManager sharedInstance] masterBuildingList])
    {
        // Check Master Buildings / Add
        if([[buildingDetail objectForKey:@"id"] integerValue]==[[buildingDict objectForKey:@"building_id"] integerValue])
        {
            // Internal
            _buildingID = [[buildingDict objectForKey:@"building_id"] intValue];
            
            // Basics
            [_buildingName setText:[buildingDetail objectForKey:@"name"]];
            
            // Amount (QTY)
            qty = [[buildingDict objectForKey:@"amount"] intValue];
            _buildingAmount.text  = [NSString stringWithFormat:@"x%@",[formatter stringFromNumber:[NSNumber numberWithInt:qty]]];
            
            // Incomes
            NSDictionary* incomeDict = [buildingDetail objectForKey:@"income"];
            
            // Food
            value = [[incomeDict objectForKey:@"food"] intValue];
            value*=qty;
            [_buildingFood setTextRate:[NSNumber numberWithInt:value]];
            
            // Workers
            value = [[incomeDict objectForKey:@"workers"] intValue];
            value*=qty;
            [_buildingWorkers setTextRate:[NSNumber numberWithInt:value]];
            
            // Energy
            value = [[incomeDict objectForKey:@"energy"] intValue];
            value*=qty;
            [_buildingEnergy setTextRate:[NSNumber numberWithInt:value]];
            
            // Minerals
            value = [[incomeDict objectForKey:@"minerals"] intValue];
            value*=qty;
            [_buildingMinerals setTextRate:[NSNumber numberWithInt:value]];
          
        }
    }
}

// Button Pressed
-(IBAction) buttonPressed:(id)sender
{
    //UIButton *button = (UIButton *) sender;
    [self createBuildingPopup];
}

#pragma mark Building Popup
-(void) createBuildingPopup
{
    // Lookup Building
    NSDictionary* buildingDict;
    
    for(NSDictionary* buildingDetail in [[GameManager sharedInstance] masterBuildingList])
    {
        // Check Master Buildings / Add
        if([[buildingDetail objectForKey:@"id"] integerValue]==_buildingID)
        {
            buildingDict = [NSDictionary dictionaryWithDictionary:buildingDetail];
        }
    }
    // Current Window
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    // Root ViewController
    UIViewController *rootViewController = window.rootViewController;
    // Root View
    UIView* masterView = rootViewController.view;
    
    // Create Grey Background
    UIView *dimBackgroundView = [[UIView alloc] initWithFrame:masterView.bounds];
    dimBackgroundView.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.7f];
    dimBackgroundView.tag = TAG_POPUP_GREY;
    [masterView addSubview:dimBackgroundView];
    
    // Add Tap (Cancel Popup)
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(dismissBuildingPopUp:)];
    [dimBackgroundView addGestureRecognizer:singleFingerTap];
    
    // Create Building Build View
    BuildingBuildView *buildingPopup = [[[NSBundle mainBundle] loadNibNamed:@"BuildingBuildView" owner:self options:nil] objectAtIndex:0];
    [buildingPopup setCenter:CGPointMake(masterView.frame.size.width*0.5f, masterView.frame.size.height*0.5f)];
    buildingPopup.tag = TAG_POPUP;
    [masterView addSubview:buildingPopup];
    
    // Setup Popup
    [buildingPopup setup:buildingDict];
    
}

// Dismiss Popup
- (void)dismissBuildingPopUp:(UITapGestureRecognizer *)recognizer {
    
    // Current Window
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    // Root ViewController
    UIViewController *rootViewController = window.rootViewController;
    // Root View
    UIView* masterView = rootViewController.view;
    
    UIView *dimBackgroundView   = [masterView viewWithTag:TAG_POPUP_GREY];
    UIView *buildingPopup       = [masterView viewWithTag:TAG_POPUP];
    
    // Remove Recognizer
    for (UIGestureRecognizer *recognizer in dimBackgroundView.gestureRecognizers) {
        [dimBackgroundView removeGestureRecognizer:recognizer];
    }
    
    [dimBackgroundView removeFromSuperview];
    [buildingPopup removeFromSuperview];
}


@end
