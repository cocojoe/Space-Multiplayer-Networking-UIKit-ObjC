//
//  TabBarItemViewController.m
//  SimpleTabBarApp
//
//  Created by Deminem on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlayerViewController.h"
#import "GameManager.h"
#import "PlayerProfileView.h"
#import "PlayerPartsView.h"

@interface PlayerViewController ()

@end

@implementation PlayerViewController

- (id)initWithTitle:(NSString *)title {
    
    self = [super initWithNibName:@"PlayerViewController" bundle:nil];
    
    if (self) {
        // Custom initialization
        
        // Correct Size (Was Redundant To Space on iOS5)
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
        // Nav Title
        self.title = title;
        
        [self setupNotification];
       
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setupNotification];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}



#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

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
    
    // Populate Data
    [self refreshData];
    
}

// For example after a modal is dimissed (that may have refreshed player)
/*
-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self refreshData];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    BOOL shouldAutorotate = NO;
    
    if (interfaceOrientation == UIInterfaceOrientationPortrait
        || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        
        shouldAutorotate = YES;
    }
    
    return shouldAutorotate;
}

#pragma mark Notification Handling
-(void) setupNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerRefreshNotification:)
                                                 name:@"playerRefresh"
                                               object:nil];
}

- (void) playerRefreshNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"playerRefresh"])
    {
        CCLOG(@"Player Refresh Notification");
        [self refreshData];
    }
}

- (void) dealloc
{
    // If you don't remove yourself as an observer, the Notification Center
    // will continue to try and send notification objects to the deallocated
    // object.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark Pull To Refresh Delegate Methods
-(void)pullToRefreshViewShouldRefresh:(PullToRefreshView *)view {
    [self refreshData];
}

#pragma mark Data Processing
-(void) refreshData
{
    
    [[GameManager sharedInstance] refreshPlayer:^(NSDictionary *jsonDict){
        
        // Process JSON
        
        // Parent Player Dictionary
        NSDictionary *playerDict = [NSDictionary dictionaryWithDictionary:[jsonDict objectForKey:@"player"]];
        
        // Player View
        [_playerProfileView refresh:playerDict];
        
        // Parts View (We have some parts?)
        if([[playerDict objectForKey:@"parts"] count]>0) {
            [_partsProfileView refresh:[playerDict objectForKey:@"parts"]];
        } else {
            // Provide Dummy Dictionary Object (Expects Dict)
            NSDictionary *partsDict = [[NSDictionary alloc] init];
            [_partsProfileView refresh:partsDict];
        }

        // Finished
        [(PullToRefreshView *)[self.view viewWithTag:TAG_PULL] finishedLoading];
    
    }];
    
}

@end
