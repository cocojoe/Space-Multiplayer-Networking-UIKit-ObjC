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

#define PLANET_BUILDING_VIEW_SPACER     5.0f

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
            
            // Set Content Size (No Auto Layout)
            _mainScrollView.contentSize=self.view.frame.size;
        }
    }
    
    // Set up Pull to Refresh code
    PullToRefreshView *pull = [[PullToRefreshView alloc] initWithScrollView:_mainScrollView];
    [pull setDelegate:self];
    pull.tag = TAG_PULL;
    [_mainScrollView addSubview:pull];
    
    // Store Original List View Frame
    originalListFrame = [_buildingListView frame];
    
    // Populate Segment
    [self setupSegment];
    
    // Setup Timer
    _refreshTimer = [NSTimer scheduledTimerWithTimeInterval:DEFAULT_QUEUE_VIEW_REFRESH target:self selector:@selector(refreshQueue) userInfo:nil repeats:YES];
    
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

#pragma mark Queue Timer Processor
-(void) refreshQueue
{
    // Refresh Queue View
    [_buildingQueueView updateQueue];
}

#pragma mark Data Processing
-(void) refreshData
{
 
    [[GameManager sharedInstance] refreshPlanet:^(NSDictionary *jsonDict){
        
        // Parent Planrt Dictionary
        NSDictionary *planetDict   = [NSDictionary dictionaryWithDictionary:[jsonDict objectForKey:@"planet"]];
 
        // Sub View Listing(s)
        [_buildingQueueView setupQueue:[[planetDict objectForKey:@"queues"] objectForKey:@"building"]];
        
        [_buildingListView refresh:[planetDict objectForKey:@"buildings"]];
        
        // Push List Down (From Queue)
        CGRect newFrame    = [_buildingListView frame];
        newFrame.origin.y  = originalListFrame.origin.y + _buildingQueueView.frame.size.height+PLANET_BUILDING_VIEW_SPACER;
        [_buildingListView setFrame:newFrame];
        
        // Adjust Content Size
        CGSize contentSize  = _mainScrollView.contentSize;
        contentSize.height  = originalListFrame.origin.y+ _buildingListView.frame.size.height+_buildingQueueView.frame.size.height+(PLANET_BUILDING_VIEW_SPACER*2.0f); // 2 Views + Padding
        _mainScrollView.contentSize=contentSize;
        
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

#pragma mark Segment 
- (IBAction)segmentSwitch:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    
    // Switch
    NSString *segmentName = [segmentedControl titleForSegmentAtIndex:selectedSegment];
    [_buildingListView setGroupFilter:segmentName];
    [self refreshData];
}

-(void) setupSegment
{
    
    int index = 0;
    // Clear 'Display' Segments
    [_segmentGroup removeAllSegments];
    
    for(NSDictionary* buildingGroupDict in [[GameManager sharedInstance] masterBuildingGrouplist])
    {
        
        // Create Parent Categories
        if([buildingGroupDict objectForKey:@"parent_id"]==[NSNull null])
        {
            [_segmentGroup insertSegmentWithTitle:[buildingGroupDict objectForKey:@"name"] atIndex:index animated:NO];
            index++;
        }
    }
    
    _segmentGroup.selectedSegmentIndex = 0; // Default
    [_buildingListView setGroupFilter:[_segmentGroup titleForSegmentAtIndex:_segmentGroup.selectedSegmentIndex]];
}

@end
