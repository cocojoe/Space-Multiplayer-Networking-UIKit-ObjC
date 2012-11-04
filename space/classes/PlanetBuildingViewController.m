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
    
    [self setupPullRefresh];
    
    // Store Original List View Frame
    _originalListFrame = [_buildingListView frame];
    
    // Populate Segment Switch
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
        [_pull finishedLoading];
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
        newFrame.origin.y  = _originalListFrame.origin.y + _buildingQueueView.frame.size.height+PLANET_BUILDING_VIEW_SPACER;
        [_buildingListView setFrame:newFrame];
        
        // Adjust Content Size
        CGSize contentSize  = _mainScrollView.contentSize;
        contentSize.height  = _originalListFrame.origin.y+ _buildingListView.frame.size.height+_buildingQueueView.frame.size.height+(PLANET_BUILDING_VIEW_SPACER*2.0f); // 2 Views + Padding
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
            [_segmentGroup insertSegmentWithTitle:[buildingGroupDict objectForKey:@"name"] atIndex:index animated:YES];
            index++;
        }
    }
}

- (IBAction)segmentSwitch:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    
    // Segment Name
    NSString *segmentName = [segmentedControl titleForSegmentAtIndex:selectedSegment];
    
    // Hieriachy Reset
    if([segmentName isEqualToString:@"<<"])
    {
        [self setupSegment];
        // Set View Filter Name / Refresh
        [_buildingListView setGroupFilter:@""];
        [self refreshData];
        return;
    }
    
    // Get Relevant Groups (Parent+Children)
    NSMutableArray* buildingGroup = [[GameManager sharedInstance] getBuildingGroup:segmentName];
    
    // Has children?
    if([buildingGroup count]<=1)
    {
        // Set View Filter Name / Refresh
        [_buildingListView setGroupFilter:segmentName];
        [self refreshData];
        return;
    }

    // Clear Segments
    int index = 0;
    [segmentedControl removeAllSegments];
    
    // Loop Through List
    for(NSNumber* groupID in buildingGroup)
    {
        
        for(NSDictionary* buildingGroupDict in [[GameManager sharedInstance] masterBuildingGrouplist])
        {
            
            // Create Parent Categories
            if([[buildingGroupDict objectForKey:@"id"] intValue]==[groupID intValue])
            {
                if([[buildingGroupDict objectForKey:@"name"] isEqualToString:segmentName])
                {
                     [_segmentGroup insertSegmentWithTitle:@"<<" atIndex:index animated:YES];
                } else {
                    [_segmentGroup insertSegmentWithTitle:[buildingGroupDict objectForKey:@"name"] atIndex:index animated:YES];
                }
                index++;
            }
        }
    }

    // Set View Filter Name / Refresh
    [_buildingListView setGroupFilter:segmentName];
    [self refreshData];
}

@end
