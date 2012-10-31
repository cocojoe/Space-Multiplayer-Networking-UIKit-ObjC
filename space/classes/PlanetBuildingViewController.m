//
//  PlanetBuildingViewController.m
//  space
//
//  Created by Martin Walsh on 26/10/2012.
//  Copyright (c) 2012 Pedro LTD. All rights reserved.
//

#import "PlanetBuildingViewController.h"
#import "BuildingSelectionTableViewController.h"

#import "GameManager.h"
#import "BuildingListView.h"
#import "BuildingQueueView.h"

@interface PlanetBuildingViewController ()

@end

@implementation PlanetBuildingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"BuildingOverviewTitleKey", @"");
        [self setupNotification];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
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
    
    // Setup Timer
    _refreshTimer = [NSTimer scheduledTimerWithTimeInterval:DEFAULT_QUEUE_VIEW_REFRESH target:self selector:@selector(refreshData) userInfo:nil repeats:YES];
    
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

#pragma mark Notification Handling
-(void) setupNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:@"cancelPullDown"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:@"buildingRefresh"
                                               object:nil];
}

- (void) handleNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"buildingRefresh"])
    {
        [self refreshData];
    } else if ([[notification name] isEqualToString:@"cancelPullDown"])
    {
        // Cancel Refresh
        [(PullToRefreshView *)[self.view viewWithTag:TAG_PULL] performSelector:@selector(finishedLoading) withObject:nil];
    }
}

- (void) dealloc
{
    // If you don't remove yourself as an observer, the Notification Center
    // will continue to try and send notification objects to the deallocated
    // object.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_refreshTimer invalidate];
}


#pragma mark Pull To Refresh Delegate Methods
-(void)pullToRefreshViewShouldRefresh:(PullToRefreshView *)view {
    [self refreshData];
}

#pragma mark Data Processing
-(void) refreshData
{
    if(![[GameManager sharedInstance] planetID])
        return;
    
    [[GameManager sharedInstance] refreshPlanet:^(NSDictionary *jsonDict){
        
        // Parent Player Dictionary
        NSDictionary *planetDict   = [NSDictionary dictionaryWithDictionary:[jsonDict objectForKey:@"planet"]];
 
        // Sub View Listing(s)
        [_buildingQueueView setupQueue:[[planetDict objectForKey:@"queues"] objectForKey:@"building"]];
        [_buildingListView refresh:[planetDict objectForKey:@"buildings"]];
        
        /*
        // Push List Frame Down
        CGRect frameList  = [_buildingListView frame];
        CGRect frameQueue = [_buildingQueueView frame];
        frameList.origin.y = frameQueue.size.height + 20.0f;
        [_buildingListView setFrame:frameList];
        
        [self.view setNeedsLayout];
        
        // Set Size (No Auto Layout)
        CGSize scrollSize = _mainScrollView.contentSize;
        scrollSize.height-=frameList.size.height+frameQueue.size.height;
        _mainScrollView.contentSize=frameList.size;
        */
        
        int buildingRows = [[planetDict objectForKey:@"buildings"] count];
        CGSize content = _mainScrollView.contentSize;
        //content.height*=buildingRows*40;
        _mainScrollView.contentSize = content;
        
    }];
    
}

#pragma mark Navigation Extras
-(void) showBuildingList;
{
    // Create Building Selection Modal
    BuildingSelectionTableViewController* selectionViewController = [[BuildingSelectionTableViewController alloc] initWithNibName:@"BuildingSelectionTableViewController" bundle:nil];
    
    // Add Navigation (For Bar Control)
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:selectionViewController];
    
    // Push Inventory Selection View
    UIViewController* viewController = [[GameManager sharedInstance] view];
    [viewController presentModalViewController:navigation animated:YES];
}

@end
