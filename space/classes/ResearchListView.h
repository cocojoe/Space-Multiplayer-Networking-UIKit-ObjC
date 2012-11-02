//
//  ResearchListView.h
//  space
//
//  Created by Martin Walsh on 02/11/2012.
//  Copyright (c) 2012 Pedro LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ResearchListView : UIView {
    NSMutableArray* _viewArray;
}

#pragma mark Data Handling
-(void) refresh:(NSMutableArray*) researchList;

@end
