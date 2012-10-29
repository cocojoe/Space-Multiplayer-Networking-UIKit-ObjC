//
//  BuildingListView.h
//  space
//
//  Created by Martin Walsh on 29/10/2012.
//  Copyright (c) 2012 Pedro LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface BuildingListView : UIView
{
    NSMutableArray* _viewArray;
}

-(void) refresh:(NSMutableArray*) buildingDict;

@end
