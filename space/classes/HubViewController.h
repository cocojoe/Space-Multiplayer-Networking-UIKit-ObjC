//
//  HubViewController.h
//  space
//
//  Created by Martin Walsh on 09/10/2012.
//  Copyright (c) 2012 Pedro LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullToRefreshView.h"

@interface HubViewController : UIViewController <PullToRefreshViewDelegate>
{
    UIScrollView* _mainScrollView;
}

// Outlets
@property (nonatomic) IBOutlet UILabel *labelServerTime;

@end
