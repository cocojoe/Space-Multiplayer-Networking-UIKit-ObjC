//
//  GameManager.m
//  littlekeepers
//
//  Created by Martin Walsh on 13/09/2012.
//  Copyright (c) 2012 Pedro LTD. All rights reserved.
//

#import "GameManager.h"

// Data Retrieval
#import "AFJSONRequestOperation.h"

// Device Identifier
#import "UIDevice+IdentifierAddition.h"

// Pull To Refresh
#import "PullToRefreshView.h"

// Activity View
#import "DejalActivityView.h"

@implementation GameManager

@synthesize deviceUUID = _deviceUUID;
@synthesize view = _view;

+(GameManager *)sharedInstance
{
    static GameManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[GameManager alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

-(id)init
{
	if((self = [super init])){
        
        // Initialise NSOperation Queue
        _requestQueue        = [[NSOperationQueue alloc] init];
        _requestSuspendQueue = [[NSOperationQueue alloc] init];
        [_requestQueue setMaxConcurrentOperationCount:1]; // Concurrent Requests
        [_requestSuspendQueue setMaxConcurrentOperationCount:2]; // Concurrent Requests
        
        // API Data Object
        _authDict       = [[NSMutableDictionary alloc] init];
        _playerDict     = [[NSMutableDictionary alloc] init];
        _inventoryDict  = [[NSMutableDictionary alloc] init];
        
        // Authorisation
        _eAuthenticationState = eAuthenticationNone;
        _countdown            = HOST_RETRY;
        
        // Device UUID
        [self setDeviceUUID:[self getDeviceID]];
        
	}
	
	return self;
}

#pragma mark Queue Handling
-(void) addQueue:(NSBlockOperation*) operationBlock
{
    // Add Request to NSOperationQueue
    // Check Authentication
    if(_eAuthenticationState==eAuthenticationInProgress)
    {   // Add Secondary Queue
        [_requestSuspendQueue addOperation:operationBlock];
    } else {
        [_requestQueue addOperation:operationBlock];
    }
}

#pragma mark Device Indentity
-(NSString*) getDeviceID
{
     //return [[UIDevice currentDevice] uniqueGlobalDeviceIdentifier];
    return @"15fd7ce896302ec559fb3932bca2b19d";
}

#pragma mark Public API Methods
-(void) authenticate
{
    
    // Progress Indicator (Add If Not Present)
    if(![DejalActivityView currentActivityView]) {
        [DejalBezelActivityView activityViewForView:_view.view withLabel:[NSString stringWithFormat:@"Connecting..."] width:200];
    } else {
        [DejalBezelActivityView currentActivityView].activityLabel.text = [NSString stringWithFormat:@"Connecting..."];
    }
    
    // Create DATA Dictionary
    NSDictionary *postDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                              APP_ID      , @"app_id",
                              APP_SECRET  , @"app_secret",
                              @"ios"      , @"platform",
                              _deviceUUID , @"uid",
                              nil];
    
    
    [self makeRequest:URI_AUTH setPostDictionary:postDict setBlock:^(NSDictionary *jsonDict){
        
        // Store Authentication Information
        _authDict = [jsonDict objectForKey:@"session"];
        
        // Dismiss Bezel / Flag Authenticated / Resume Secondary Queue
        [DejalBezelActivityView removeViewAnimated:YES];
        _eAuthenticationState = eAuthenticationOK;
        [_requestSuspendQueue setSuspended:NO]; // Release Pending Requests
        
        CCLOG(@"_authDict: %@",_authDict);
        
    } setBlockFail:^{
        // Authentication Failure
        _eAuthenticationState = eAuthenticationNone;
        [DejalBezelActivityView currentActivityView].activityLabel.text = [NSString stringWithFormat:@"Connection Problem\nWill try again."];
        [self performSelector:@selector(countDown) withObject:nil afterDelay:HOST_RETRY];
    }];
    
    // Auth In Progress (Queue Additional Requests)
    _eAuthenticationState = eAuthenticationInProgress;
    [_requestSuspendQueue setSuspended:YES];
}


-(void) refreshPlayer:(ResponseBlock) actionBlock
{
    
    // Check Existing Time
    if([_playerDict objectForKey:@"time"])
    {
        // Check Last Update
        if(([[_playerDict objectForKey:@"time"] doubleValue]+API_CACHE_TIME)>[[NSDate date] timeIntervalSince1970])
        {
            actionBlock(_playerDict);
            return;
        }
    }
    
    [self addQueue:[NSBlockOperation blockOperationWithBlock:^{
        
        [self makeRequest:URI_PLAYER setPostDictionary:nil setBlock:^(NSDictionary *jsonDict) {
            // Store Player Information
            [_playerDict setDictionary:jsonDict];
            CCLOG(@"_playerDict: %@",_playerDict);
            
            actionBlock(_playerDict);
        } setBlockFail:nil];
        
    }]];
    
}

-(void) refreshInventory:(ResponseBlock) actionBlock
{
    
    // Check Existing Time
    if([_inventoryDict objectForKey:@"time"])
    {
        // Check Last Update
        if(([[_inventoryDict objectForKey:@"time"] doubleValue]+API_CACHE_TIME)>[[NSDate date] timeIntervalSince1970])
        {
            actionBlock(_inventoryDict);
            return;
        }
    }
    
    [self addQueue:[NSBlockOperation blockOperationWithBlock:^{
        
        [self makeRequest:URI_INVENTORY setPostDictionary:nil setBlock:^(NSDictionary *jsonDict) {
            // Store Player Information
            [_inventoryDict setDictionary:jsonDict];
            CCLOG(@"_inventoryDict: %@",_inventoryDict);
            
            actionBlock(_inventoryDict);
        } setBlockFail:nil];
        
    }]];
    
}

#pragma mark Connection Retry
-(void) countDown
{
    _countdown--;
    [DejalBezelActivityView currentActivityView].activityLabel.text = [NSString stringWithFormat:@"Retry in %d seconds",_countdown];
    
    // Next Auth Attempt
    if(_countdown<=0)
    {
        _countdown  = HOST_RETRY;
        [self performSelector:@selector(authenticate) withObject:nil];
    } else {
        [self performSelector:@selector(countDown) withObject:nil afterDelay:1];
    }
}

#pragma mark Internal API Methods
// @todo General Connectivity Flagging
-(void) makeRequest:(NSString*) URI setPostDictionary:(NSDictionary*) postDict setBlock:(ResponseBlock) responseBlock setBlockFail:(BasicBlock) failBlock
{
    // Request URL
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:(@"%@%@"),HOST_NAME,URI]];
    
    // Add Authentication Data
    NSMutableDictionary *completeDict = [[NSMutableDictionary alloc] init];
    [completeDict addEntriesFromDictionary:postDict];
    
    // If Authenticated / Add Data
    if(_eAuthenticationState==eAuthenticationOK)
    {
        [completeDict addEntriesFromDictionary:_authDict];
    }
    
    // Create JSON (From Post Dictionary) 
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:completeDict
                                                       options:NSJSONWritingPrettyPrinted error:nil];
    
    // Convert UTF-8 String
    NSString* requestString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    // Create Request Data 
    NSData *requestData = [NSData dataWithBytes: [requestString UTF8String] length: [requestString length]];
    
    // Create URL Request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    // Params
    [request setHTTPMethod: @"POST"];
    [request setHTTPBody: requestData];
    [request setTimeoutInterval:HOST_TIMEOUT];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        if([[JSON valueForKey:@"success"] intValue]!=1)
        {

            if([[JSON objectForKey:@"error_code"] integerValue]==1)
            { // Soft Issue (ReAuthentication Required)
                CCLOG(@"Re-Authentication Required: Invalid Session");
                [self authenticate];
                
                // ReQueue Failed Request
                [self addQueue:[NSBlockOperation blockOperationWithBlock:^{
                    [self makeRequest:URI setPostDictionary:postDict setBlock:responseBlock setBlockFail:failBlock];
                }]];
            } else {
              // UnKnown Issue
                [self apiError:[NSString stringWithFormat:@"API Error: %@",[JSON objectForKey:@"error_description"]]];
            }
        } else {
            //CCLOG(@"Response Success:%@",JSON);
            responseBlock(JSON);
        }
        
        [self cancelRefresh]; // Just In Case
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        // Execture Fail Block (Optional Custom Handler)
        if(failBlock)
        {
            failBlock(); 
        } else {
            [self apiError:@"Server Busy\nPlease try again..."];
        }
    }];
    
    
    [operation start];
    
}

// General API Error Handler
-(void) apiError:(NSString*) errorDescription
{
    ALOG(@"%@",errorDescription);
    [self cancelRefresh];
}

-(void) cancelRefresh
{
    // Cancel Refresh Pull Down
    [(PullToRefreshView *)[_view.view viewWithTag:TAG_PULL] performSelector:@selector(finishedLoading) withObject:nil];
}

@end
