//
//  PlanetResearchViewController.m
//  space
//
//  Created by Martin Walsh on 31/10/2012.
//  Copyright (c) 2012 Pedro LTD. All rights reserved.
//

#import "PlanetResearchViewController.h"
#import "GameManager.h"
#import "ResearchQueueView.h"
#import "ResearchListView.h"

#define PLANET_RESEARCH_VIEW_SPACER     5.0f

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
    
    // Store Original List View Frame
    _originalListFrame = [_listView frame];
    
    [self setupPullRefresh];
    
    [self setupProgessTimer];

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
    [_refreshTimer invalidate];
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

// Timer
-(void) setupProgessTimer {
    // Setup Timer
    _refreshTimer = [NSTimer scheduledTimerWithTimeInterval:DEFAULT_QUEUE_VIEW_REFRESH target:self selector:@selector(refreshQueue) userInfo:nil repeats:YES];
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshData)
                                                 name:@"researchRefresh"
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

#pragma mark Queue Timer Processor
-(void) refreshQueue
{
    // Refresh Queue View
    [_queueView updateQueueProgress];
}

#pragma mark Data Processing
-(void) refreshData
{
    
    [[GameManager sharedInstance] refreshPlanet:^(NSDictionary *jsonDict){
        
        // Parent Planrt Dictionary
        NSDictionary *planetDict   = [NSDictionary dictionaryWithDictionary:[jsonDict objectForKey:@"planet"]];

        // Sub View Listing(s)
        [_queueView createQueue:[[planetDict objectForKey:@"queues"] objectForKey:@"research"]];
        
        [_listView refresh:[planetDict objectForKey:@"research"]];
        
        // Push List Down (From Queue)
        CGRect newFrame    = [_listView frame];
        newFrame.origin.y  = _originalListFrame.origin.y + _queueView.frame.size.height+PLANET_RESEARCH_VIEW_SPACER;
        [_listView setFrame:newFrame];
        
        // Adjust Content Size
        CGSize contentSize  = _mainScrollView.contentSize;
        contentSize.height  = _originalListFrame.origin.y + _listView.frame.size.height+_queueView.frame.size.height+(PLANET_RESEARCH_VIEW_SPACER*2.0f); // 2 Views + Padding
        _mainScrollView.contentSize=contentSize;
        
    }];
    
}

@end
