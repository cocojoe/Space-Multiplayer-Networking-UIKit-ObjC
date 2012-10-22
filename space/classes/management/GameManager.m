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

// Login View
#import "LoginViewController.h"

// UI Kit Find Parent Controller
#import "UIView+FindUIViewController.h"


// Master View (ZUUReval)

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
        
        // Data Store
        _masterItemList  = [[NSMutableArray alloc] init];
        _masterPartList  = [[NSMutableArray alloc] init];
        _masterGroupList = [[NSMutableArray alloc] init];
        
        // Authorisation
        _eAuthenticationState = eAuthenticationNone;
        
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


#pragma mark Authentication
-(void) loginStart
{
    CCLOG(@"Launch Login Controller");
    
    // Auth In Progress (Queue Additional Requests)
    _eAuthenticationState = eAuthenticationInProgress;
    [_requestSuspendQueue setSuspended:YES];

    // Present Loader
    LoginViewController* loginViewController = [[LoginViewController alloc] init];
    
    // Grab Top Most Controller 
    UIViewController* TopController = [[[[[UIApplication sharedApplication] keyWindow] subviews] lastObject] firstAvailableUIViewController];
    [TopController presentModalViewController:loginViewController animated:YES];
}

-(void) loginComplete
{
    [_requestSuspendQueue setSuspended:NO]; // Release Pending Requests
}
     
-(void) authenticate:(BasicBlock) successBlock setErrorBlock:(BasicBlock) errorBlock
{
    
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
        _eAuthenticationState = eAuthenticationOK;
        
        CCLOG(@"_authDict: %@",_authDict);
        successBlock();
        
    } setBlockFail:^{
        
        // Authentication Failure
        _eAuthenticationState = eAuthenticationNone;
        errorBlock();
    }];
}

#pragma mark Player 
-(void) refreshPlayer:(ResponseBlock) actionBlock
{
    
    /*
    // Check Existing Time
    if([_playerDict objectForKey:@"time"])
    {
        // Check Last Update
        if(([[_playerDict objectForKey:@"time"] doubleValue]+API_CACHE_TIME)>[[NSDate date] timeIntervalSince1970])
        {
            CCLOG(@"Player No Cache");
            actionBlock(_playerDict);
            return;
        }
    }
    */
    
    [self addQueue:[NSBlockOperation blockOperationWithBlock:^{
        
        [self makeRequest:URI_PLAYER setPostDictionary:nil setBlock:^(NSDictionary *jsonDict) {
            // Store Player Information
            [_playerDict setDictionary:jsonDict];
            
            actionBlock(_playerDict);
        } setBlockFail:nil];
        
    }]];
    
}

#pragma mark Master Lists
-(void) retrieveMasterItem:(BasicBlock) actionBlock
{
    
    [self addQueue:[NSBlockOperation blockOperationWithBlock:^{
        
        [self makeRequest:URI_INVENTORY_ITEM_MASTER setPostDictionary:nil setBlock:^(NSDictionary *jsonDict) {
            
            // Store Master List
            [_masterItemList setArray:[jsonDict objectForKey:@"items"]];
            CCLOG(@"Master Item List Retrieved, %d Items", [_masterItemList count]);
            actionBlock();
        } setBlockFail:nil];
        
    }]];
    
}

-(void) retrieveMasterPart:(BasicBlock) actionBlock
{
    
    [self addQueue:[NSBlockOperation blockOperationWithBlock:^{
        
        [self makeRequest:URI_PART_MASTER setPostDictionary:nil setBlock:^(NSDictionary *jsonDict) {
            
            // Store Master List
            [_masterPartList setArray:[jsonDict objectForKey:@"parts"]];
            CCLOG(@"Master Part List Retrieved, %d Items", [_masterPartList count]);
            actionBlock();
        } setBlockFail:nil];
        
    }]];
    
}

-(void) retrieveMasterGroup:(BasicBlock) actionBlock
{
    
    [self addQueue:[NSBlockOperation blockOperationWithBlock:^{
        
        [self makeRequest:URI_INVENTORY_GROUP_MASTER setPostDictionary:nil setBlock:^(NSDictionary *jsonDict) {
            
            // Store Master List
            [_masterGroupList setArray:[jsonDict objectForKey:@"groups"]];
            CCLOG(@"Master Group List Retrieved, %d Items", [_masterGroupList count]);
            actionBlock();
        } setBlockFail:nil];
        
    }]];
    
}

#pragma mark Inventory
-(void) refreshInventory:(ResponseBlock) actionBlock
{
    
    /*
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
     */
    
    [self addQueue:[NSBlockOperation blockOperationWithBlock:^{
        
        [self makeRequest:URI_INVENTORY setPostDictionary:nil setBlock:^(NSDictionary *jsonDict) {
            // Store Player Information
            [_inventoryDict setDictionary:jsonDict];
            //CCLOG(@"_inventoryDict: %@",_inventoryDict);
            
            actionBlock(_inventoryDict);
        } setBlockFail:nil];
        
    }]];
    
}


#pragma mark Inventory Part Management
-(void) clearPart:(int)partID setBlock:(ResponseBlock) actionBlock {
    
    // Create DATA Dictionary
    NSDictionary *postDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                              [NSNumber numberWithInt:partID], @"part_id",
                              nil];
    
    [self addQueue:[NSBlockOperation blockOperationWithBlock:^{
        
        [self makeRequest:URI_INVENTORY_REMOVE_PART setPostDictionary:postDict setBlock:^(NSDictionary *jsonDict) {
            actionBlock(nil);
        } setBlockFail:nil];
        
    }]];

}

-(void) setPart:(int)partID setItem:(int)itemID setBlock:(ResponseBlock) actionBlock {
    
    // Create DATA Dictionary
    NSDictionary *postDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                              [NSNumber numberWithInt:partID], @"part_id",
                              [NSNumber numberWithInt:itemID], @"item_id",
                              nil];
    
    [self addQueue:[NSBlockOperation blockOperationWithBlock:^{
        
        [self makeRequest:URI_INVENTORY_ATTACH_PART setPostDictionary:postDict setBlock:^(NSDictionary *jsonDict) {
            actionBlock(nil);
        } setBlockFail:nil];
        
    }]];
    
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
    
    // Auto Add Authentication Dictionary
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
    
    //CCLOG(@"REQUEST POST: %@",completeDict);
    
    // Params
    [request setHTTPMethod: @"POST"];
    [request setHTTPBody: requestData];
    [request setTimeoutInterval:HOST_TIMEOUT];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        if([[JSON valueForKey:@"success"] intValue]!=1)
        {

            if([[JSON objectForKey:@"error_code"] integerValue]==1)
            {
                // Soft Issue (ReAuthentication Required)
                CCLOG(@"Re-Authentication Required: Invalid Session");
                [self loginStart];
                
                // ReQueue Failed Request
                [self addQueue:[NSBlockOperation blockOperationWithBlock:^{
                    [self makeRequest:URI setPostDictionary:postDict setBlock:responseBlock setBlockFail:failBlock];
                }]];

            } else {
                // UnKnown Issue
                [self apiError:[NSString stringWithFormat:@"API Error: %@",[JSON objectForKey:@"error_description"]]];
            }
        } else {
            // Success
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


#pragma mark Error Handling
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
