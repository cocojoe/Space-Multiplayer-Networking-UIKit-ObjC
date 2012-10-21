//
//  PartView.h
//  space
//
//  Created by Martin Walsh on 19/10/2012.
//  Copyright (c) 2012 Pedro LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface PartView : UIView
{
    UITapGestureRecognizer* _tap;
}

// Player Part
@property (nonatomic) IBOutlet UILabel *labelName;
@property (nonatomic) IBOutlet UILabel *labelDescription;
@property (nonatomic) IBOutlet UIImageView *imagePart;

// Additional Reference Inventory Selection
@property (nonatomic,readwrite) uint partID;
@property (nonatomic,readwrite) bool equipped;
@property (nonatomic) NSString* searchText;

-(void) refresh:(NSDictionary*) itemDict setPartID:(int) partID;

@end
