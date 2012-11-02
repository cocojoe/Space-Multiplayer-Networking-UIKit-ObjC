//
//  PlanetResearchViewController.m
//  space
//
//  Created by Martin Walsh on 31/10/2012.
//  Copyright (c) 2012 Pedro LTD. All rights reserved.
//

#import "PlanetResearchViewController.h"
#import "GameManager.h"

@interface PlanetResearchViewController ()

@end

@implementation PlanetResearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"PlanetResearchTitleKey", @"");
        [self registerNotification];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupPullRefresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark View Controller Helpers
- (void) dealloc
{
    // UnRegister Notification Handling
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


// Setup Pull Refresh
-(void) setupPullRefresh
{
    // Assign Pull to View -> Scroll View
    _pull = [[PullToRefreshView alloc] initWithScrollView:_mainScrollView];
    [_pull setDelegate:self];
    [_mainScrollView addSubview:_pull];
    
    // Manually Set Size (No Auto Layout)
    _mainScrollView.contentSize=self.view.frame.size;

}

#pragma mark Data Processing
-(void) refreshData
{

    [[GameManager sharedInstance] refreshPlanet:^(NSDictionary *jsonDict){
        
    }];
    
}

// Disable Landscape Rotation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    BOOL shouldAutorotate = NO;
    
    if (interfaceOrientation == UIInterfaceOrientationPortrait
        || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        
        shouldAutorotate = YES;
    }
    
    return shouldAutorotate;
}

#pragma mark Notification Handling
-(void) registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(finishedLoading:)
                                                 name:@"cancelPullDown"
                                               object:nil];
}

-(void) finishedLoading:(NSNotification *) notification
{
    [_pull finishedLoading];
}

#pragma mark PullToRefreshViewDelegate
-(void)pullToRefreshViewShouldRefresh:(PullToRefreshView *)view {
    [self refreshData];
}

@end
