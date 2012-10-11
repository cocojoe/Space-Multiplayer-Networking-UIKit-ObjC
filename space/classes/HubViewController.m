//
//  HubViewController.m
//  space
//
//  Created by Martin Walsh on 09/10/2012.
//  Copyright (c) 2012 Pedro LTD. All rights reserved.
//

#import "HubViewController.h"
#import "ZUUIRevealController.h"
#import "GameManager.h"

@interface HubViewController ()

@end

@implementation HubViewController

// Outlets
@synthesize labelServerTime = _labelServerTime;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/*
 * The following lines are crucial to understanding how the ZUUIRevealController works.
 *
 * In this example, the FrontViewController is contained inside of a UINavigationController.
 * And the UINavigationController is contained inside of a ZUUIRevealController. Thus the
 * following hierarchy is created:
 *
 * - ZUUIRevealController is parent of:
 * - - UINavigationController is parent of:
 * - - - FrontViewController
 *
 * If you don't want the UINavigationController in between (which is totally fine) all you need to
 * do is to adjust the if-condition below in a way to suit your needs. If the hierarchy were to look
 * like this:
 *
 * - ZUUIRevealController is parent of:
 * - - FrontViewController
 *
 * Without a UINavigationController in between, you'd need to change:
 * self.navigationController.parentViewController TO: self.parentViewController
 *
 * Note that self.navigationController is equal to self.parentViewController. Thus you could generalize
 * the code even more by calling self.parentViewController.parentViewController. In order to make
 * the code easier to understand I decided to go with self.navigationController.
 *
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = NSLocalizedString(@"HubTitleKey", @"");
	
    // ZUUIRevealConbtroller (Master)
    // Add Reveal Actions (Button / Swipe)
	if ([self.navigationController.parentViewController respondsToSelector:@selector(revealGesture:)] && [self.navigationController.parentViewController respondsToSelector:@selector(revealToggle:)])
	{
        // Swipe/Pan Gesture
		UIPanGestureRecognizer *navigationBarPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
		[self.navigationController.navigationBar addGestureRecognizer:navigationBarPanGestureRecognizer];
		
        // Left Button
		self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_menu.png"] style:UIBarButtonItemStylePlain target:self.navigationController.parentViewController action:@selector(revealToggle:)];
	}
    
    // Assign Scroll View to Member / Assign Delegate Self
    for (UIView* subView in self.view.subviews) {
        if ([subView isKindOfClass:[UIScrollView class]]) {
            _mainScrollView = (UIScrollView *)subView;
            _mainScrollView.delegate = (id) self;
            
            // Set Size (No Auto Layout)
            _mainScrollView.contentSize=self.view.frame.size;
        }
    }
    
    // Set up Pull to Refresh code
    PullToRefreshView *pull = [[PullToRefreshView alloc] initWithScrollView:_mainScrollView];
    [pull setDelegate:self];
    pull.tag = TAG_PULL;
    [_mainScrollView addSubview:pull];
    
    // Update View
    [self refresHubFeed];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    BOOL shouldAutorotate = NO;
    
    if (interfaceOrientation == UIInterfaceOrientationPortrait
        || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        
        shouldAutorotate = YES;
    }
    
    return shouldAutorotate;
}

-(void) refresHubFeed
{
   
    [[GameManager sharedInstance] refreshPlayer:^(NSDictionary *jsonDict){
        
        // Update Label
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[jsonDict objectForKey:@"time"] doubleValue]];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy'-'MM'-'dd HH':'mm':'ss"];
        _labelServerTime.text = [dateFormat stringFromDate:date];
        
        // Complete Pull To Refresh
        [(PullToRefreshView *)[self.view viewWithTag:TAG_PULL] finishedLoading];
    }];

}

#pragma mark Pull To Refresh Delegate Methods
-(void)pullToRefreshViewShouldRefresh:(PullToRefreshView *)view {
    [self refresHubFeed];
}

@end
