//
//  InventoryCell.h
//  space
//
//  Created by Martin Walsh on 18/10/2012.
//  Copyright (c) 2012 Pedro LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InventoryCell : UITableViewCell

@property (nonatomic) IBOutlet UILabel* labelName;
@property (nonatomic) IBOutlet UILabel* labelDescription;
@property (nonatomic) IBOutlet UILabel* labelGroup;
@property (nonatomic) IBOutlet UILabel* labelAmount;
@property (nonatomic) IBOutlet UIImageView* imageIcon;


@end
