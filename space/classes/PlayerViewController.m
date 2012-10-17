//
//  TabBarItemViewController.m
//  SimpleTabBarApp
//
//  Created by Deminem on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlayerViewController.h"
#import "GameManager.h"

@interface PlayerViewController ()

@end

@implementation PlayerViewController

- (id)initWithTitle:(NSString *)title {
    
    self = [super initWithNibName:@"PlayerViewController" bundle:nil];
    
    if (self) {
        // Custom initialization
        
        // Correct Size (Was Redundant To Space on iOS5)
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
        self.title = title;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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

#pragma mark Pull To Refresh Delegate Methods
-(void)pullToRefreshViewShouldRefresh:(PullToRefreshView *)view {
    [self refreshData];
}

#pragma mark Data Processing
-(void) refreshData
{
    
    [[GameManager sharedInstance] refreshPlayer:^(NSDictionary *jsonDict){
        
        // Process JSON
        
        // Format Time > Date
        /*
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[jsonDict objectForKey:@"time"] doubleValue]];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy'-'MM'-'dd HH':'mm':'ss"];
        _labelServerTime.text = [dateFormat stringFromDate:date];
        */
        
        // Parent Player Dictionary
        NSDictionary *playerDict = [NSDictionary dictionaryWithDictionary:[jsonDict objectForKey:@"player"]];
        
        // Currency Child Dictionary
        NSDictionary *currencyDict = [NSDictionary dictionaryWithDictionary:[playerDict objectForKey:@"currency"]];
 
        // IB Outlets
        // Profile Details
        _labelPlayerName.text = [playerDict objectForKey:@"name"];
        
        // Number Formatted
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        
        // Cash
        NSNumber* cash = [NSNumber numberWithInt:[[currencyDict objectForKey:@"cash"] integerValue]];
        _labelPlayerCurrencyCash.text = [formatter stringFromNumber:cash];
        
        // Premium
        NSNumber* premium = [NSNumber numberWithInt:[[currencyDict objectForKey:@"premium"] integerValue]];
        _labelPlayerCurrencyPremium.text = [formatter stringFromNumber:premium];
        
        // Score
        NSNumber* score = [NSNumber numberWithInt:[[playerDict objectForKey:@"score"] integerValue]];
        _labelPlayerScore.text = [formatter stringFromNumber:score];
        
        // Complete Pull To Refresh
        [(PullToRefreshView *)[self.view viewWithTag:TAG_PULL] finishedLoading];
    }];
    
}

@end
