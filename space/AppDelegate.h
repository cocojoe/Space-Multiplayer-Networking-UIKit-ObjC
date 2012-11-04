//
//  AppDelegate.h
//  space
//
//  Created by Martin Walsh on 09/10/2012.
//  Copyright (c) 2012 Pedro LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MasterViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSString* _lastNotification;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MasterViewController *viewController;

@end
