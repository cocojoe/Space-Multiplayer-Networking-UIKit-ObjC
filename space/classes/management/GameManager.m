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

// Building View (Popup)
#import "BuildingBuildView.h"

// Master View (ZUUReval)

@implementation GameManager

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
        _authDict             = [[NSMutableDictionary alloc] init];
        _playerDict           = [[NSMutableDictionary alloc] init];
        _partsDict            = [[NSMutableDictionary alloc] init];
        _planetDict           = [[NSMutableDictionary alloc] init];
        _inventoryDict        = [[NSMutableDictionary alloc] init];
        _planetsDict          = [[NSMutableDictionary alloc] init];

        _researchAllowedDict  = [[NSMutableDictionary alloc] init];
        
        // Data Store
        _masterItemList             = [[NSMutableArray alloc] init];
        _masterPartList             = [[NSMutableArray alloc] init];
        _masterGroupList            = [[NSMutableArray alloc] init];
        _masterBuildingList         = [[NSMutableArray alloc] init];
        _masterResearchList         = [[NSMutableArray alloc] init];
        _masterBuildingGrouplist    = [[NSMutableArray alloc] init];
        
        // Authorisation
        _eAuthenticationState = eAuthenticationNone;
        
        // Device UUID
        [self setDeviceUUID:[self getDeviceID]];
        
        // Preferences Reset
        _planetID = 0;
        
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
-(void) authLock
{
    // Auth In Progress (Queue Additional Requests)
    _eAuthenticationState = eAuthenticationInProgress;
    [_requestSuspendQueue setSuspended:YES];
}
-(void) loginStart
{
    [self authLock];

    UIViewController *topController = self.view; // Root/Master Controller
    
    // Find Currently Presented Controller (Includes Modals)
    while (topController.presentedViewController) {
           topController = topController.presentedViewController;
    }
    
    // Already In Login Controller? If So SKIP
    if([topController isKindOfClass:[LoginViewController class]])
        return;
    
    // Created Login Controller
    LoginViewController* loginViewController = [[LoginViewController alloc] init];
    [topController presentViewController:loginViewController animated:NO completion:^(){}];
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
        
        CCLOG(@"_authDict: %@",_authDict); // Handy For Grabbing Token (Testing)
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
    
    if([self shouldUseCache:_playerDict setBlock:actionBlock])
        return;

    
    [self addQueue:[NSBlockOperation blockOperationWithBlock:^{
        
        [self makeRequest:URI_PLAYER setPostDictionary:nil setBlock:^(NSDictionary *jsonDict) {
            // Store Player Information
            [_playerDict setDictionary:jsonDict];
            
            actionBlock(_playerDict);
        } setBlockFail:nil];
        
    }]];
    
}

#pragma mark Parts
-(void) refreshParts:(ResponseBlock) actionBlock
{
    
    if([self shouldUseCache:_partsDict setBlock:actionBlock])
        return;
    
    
    [self addQueue:[NSBlockOperation blockOperationWithBlock:^{
        
        [self makeRequest:URI_PARTS setPostDictionary:nil setBlock:^(NSDictionary *jsonDict) {
            // Store Player Information
            [_partsDict setDictionary:jsonDict];
            
            actionBlock(jsonDict);
        } setBlockFail:nil];
        
    }]];
    
}

#pragma mark Master Lists
-(void) retrieveMaster:(BasicBlock) actionBlock setErrorBlock:(BasicBlock) errorBlock
{
    
    [self addQueue:[NSBlockOperation blockOperationWithBlock:^{
        
        [self makeRequest:URI_MASTER_DATA setPostDictionary:nil setBlock:^(NSDictionary *jsonDict) {
            
            // Split Master Data
            [_masterBuildingList setArray:[jsonDict objectForKey:@"buildings"]];
            [_masterBuildingGrouplist setArray:[jsonDict objectForKey:@"building_groups"]];
            [_masterResearchList setArray:[jsonDict objectForKey:@"research"]];
            [_masterGroupList setArray:[jsonDict objectForKey:@"inventory_groups"]];
            [_masterItemList setArray:[jsonDict objectForKey:@"inventory_items"]];
            [_masterPartList setArray:[jsonDict objectForKey:@"parts"]];
            
            actionBlock();
        } setBlockFail:^(){errorBlock();}];
        
    }]];
    
}

#pragma mark Inventory
-(void) refreshInventory:(ResponseBlock) actionBlock
{
    
    if([self shouldUseCache:_inventoryDict setBlock:actionBlock])
        return;
    
    [self addQueue:[NSBlockOperation blockOperationWithBlock:^{
        
        [self makeRequest:URI_INVENTORY setPostDictionary:nil setBlock:^(NSDictionary *jsonDict) {
            // Cache Information
            [_inventoryDict setDictionary:jsonDict];
            actionBlock(jsonDict);
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
            // Clear Player Cache / Inventory Cache
            [_partsDict removeAllObjects];
            [_inventoryDict removeAllObjects];
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
            // Clear Player Cache / Inventory Cache
            [_partsDict removeAllObjects];
            [_inventoryDict removeAllObjects];
            actionBlock(nil);
        } setBlockFail:nil];
        
    }]];
    
}

#pragma mark Planets
-(void) refreshPlanets:(ResponseBlock) actionBlock
{
    
    if([self shouldUseCache:_planetsDict setBlock:actionBlock])
        return;
    
    [self addQueue:[NSBlockOperation blockOperationWithBlock:^{
        
        [self makeRequest:URI_PLAYER_PLANETS setPostDictionary:nil setBlock:^(NSDictionary *jsonDict) {
            
            // Cache Information
            [_planetsDict setDictionary:jsonDict];
            
            actionBlock(jsonDict);
        } setBlockFail:nil];
        
    }]];
    
}

-(void) refreshPlanet:(ResponseBlock) actionBlock
{
    
    // Check A Planet Currently Selected 
    if(!_planetID)
        return;
    
    if([self shouldUseCache:_planetDict setBlock:actionBlock])
        return;
    
    // Create DATA Dictionary
    NSDictionary *postDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                              [NSNumber numberWithInt:_planetID], @"planet_id",
                              nil];
    
    [self addQueue:[NSBlockOperation blockOperationWithBlock:^{
        
        [self makeRequest:URI_PLANET setPostDictionary:postDict setBlock:^(NSDictionary *jsonDict) {
            
            // Cache Information
            [_planetDict setDictionary:jsonDict];
            
            actionBlock(jsonDict);
        } setBlockFail:nil];
        
    }]];
    
}

#pragma mark Buildings
-(void) addBuilding:(int)buildingID setAmount:(int)amount setPlanet:(int)planetID setBlock:(ResponseBlock) actionBlock setBlockFail:(BasicBlock) failBlock
{
    // Create DATA Dictionary
    NSDictionary *postDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                              [NSNumber numberWithInt:buildingID], @"building_id",
                              [NSNumber numberWithInt:planetID]  , @"planet_id",
                              [NSNumber numberWithInt:amount]    , @"amount",
                              nil];
    
    [self addQueue:[NSBlockOperation blockOperationWithBlock:^{
        
        [self makeRequest:URI_BUILDING_ADD setPostDictionary:postDict setBlock:^(NSDictionary *jsonDict) {
            // Clear Planet Cache
            [_planetDict removeAllObjects];
            actionBlock(jsonDict);
        } setBlockFail:failBlock];
        
    }]];

}

#pragma mark Research
-(void) addResearch:(int)researchID setPlanet:(int)planetID setBlock:(ResponseBlock) actionBlock setBlockFail:(BasicBlock) failBlock
{
    // Create DATA Dictionary
    NSDictionary *postDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                              [NSNumber numberWithInt:researchID], @"research_id",
                              [NSNumber numberWithInt:planetID]  , @"planet_id",

                              nil];
    
    [self addQueue:[NSBlockOperation blockOperationWithBlock:^{
        
        [self makeRequest:URI_RESEARCH_ADD setPostDictionary:postDict setBlock:^(NSDictionary *jsonDict) {
            // Clear Planet Cache
            [_planetDict removeAllObjects];
            actionBlock(jsonDict);
        } setBlockFail:failBlock];
        
    }]];
}

#pragma mark General Caching
-(BOOL) shouldUseCache:(NSDictionary*) checkDictionary setBlock:(ResponseBlock) actionBlock
{
    if([checkDictionary count]==0) // Empty Forces Refresh
        return NO;
    
    if([checkDictionary objectForKey:@"time"]) {
        // Check Last Update
        if(([[checkDictionary objectForKey:@"time"] doubleValue]+API_CACHE_TIME)>[[NSDate date] timeIntervalSince1970])
        {
            actionBlock(checkDictionary);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelPullDown" object:self];
            return YES;
        }
    }
    
    // Default
    return NO;
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
    
    //CCLOG(@"REQUEST URI:%@ POST: %@",URI,completeDict);
    CCLOG(@"REQUEST URI:%@",URI);
    
    // Params
    [request setHTTPMethod: @"POST"];
    [request setHTTPBody: requestData];
    [request setTimeoutInterval:HOST_TIMEOUT];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        if([[JSON valueForKey:@"success"] intValue]!=1) // Error
        {
            if([[JSON objectForKey:@"error_code"] integerValue]>=1)
            {
                // Debug API Issue
                int errorCode = [[JSON objectForKey:@"error_code"] intValue];
                CCLOG(@"API Error Code: %d, Description: %@",errorCode,[JSON objectForKey:@"error_description"]);
                CCLOG(@"Request URL:%@, POST:%@",[request URL],completeDict);
                
                if(errorCode==1)
                {
                    // Soft Issue (ReAuthentication Required)
                    CCLOG(@"Re-Authentication Required: Invalid Session");
                    _eAuthenticationState = eAuthenticationNone;
                    [self authLock];
                    
                    // Time Allowance for any Modals in Animation
                    [self performSelector:@selector(loginStart) withObject:self afterDelay:0.75f];
                    
                    // ReQueue Failed Request
                    /*
                     [self addQueue:[NSBlockOperation blockOperationWithBlock:^{
                     [self makeRequest:URI setPostDictionary:postDict setBlock:responseBlock setBlockFail:failBlock];
                     }]];
                     */
                } else if(errorCode>=ERROR_WARNING) {
 
                    [[TKAlertCenter defaultCenter] postAlertWithMessage:[JSON objectForKey:@"error_description"]];
                }
                
                // Custom Failure Handler
                if(failBlock)
                    failBlock();
            }
        } else {
            // Success
            responseBlock(JSON);
        }
        
        // Cancel Any Pulldowns (Regardless)
        [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelPullDown" object:self];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        CCLOG(@"Connection Error: %@",error);
        
        // Execture Fail Block (Optional Custom Handler)
        if(failBlock)
        {
            failBlock(); 
        } else {
            // Only if Authenticated as Non Auth will be handlded by Login Controller
            if(_eAuthenticationState==eAuthenticationOK)
                [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Please try again in a few seconds"];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelPullDown" object:self];
        
    }];
    
    
    [operation start];
    
}

// General Helpers
-(void) setPlanet:(int)planet
{
    _planetID = planet;
    [_planetDict removeAllObjects]; // Clear Cache
}

-(NSDictionary*) getBuilding:(int) building_id
{
    for(NSDictionary* item in [[GameManager sharedInstance] masterBuildingList])
    {
        // Check Master Buildings / Add
        if([[item objectForKey:@"id"] intValue]==building_id)
            return item;
    }
    
    return nil;
}

-(NSDictionary*) getResearch:(int) research_id
{
    for(NSDictionary* item in [[GameManager sharedInstance] masterResearchList])
    {
        // Check Master Buildings / Add
        if([[item objectForKey:@"id"] intValue]==research_id)
            return item;
    }
    
    return nil;
}

-(NSMutableArray*) getBuildingGroup:(NSString*) name
{
    NSMutableArray* groupList = [[NSMutableArray alloc] init];
    
    int groupID = 0;
    for(NSDictionary* groupItem in [[GameManager sharedInstance] masterBuildingGrouplist])
    {
        // Find Matching Group
        if([[groupItem objectForKey:@"name"] isEqualToString:name])
        {
            groupID = [[groupItem objectForKey:@"id"] intValue];
            [groupList addObject:[NSNumber numberWithInt:groupID]];
            break;
        }
    }
    
    // Find Children
    for(NSDictionary* groupItem in [[GameManager sharedInstance] masterBuildingGrouplist])
    {
        // Find Matching Group
        if([groupItem objectForKey:@"parent_id"]!=[NSNull null])
        {
            if([[groupItem objectForKey:@"parent_id"] intValue]==groupID)
                [groupList addObject:[NSNumber numberWithInt:[[groupItem objectForKey:@"id"] intValue]]];
        }
    }

    
    return groupList;
}

#pragma mark Notifications
-(void) createNotification:(double)time setMessage:(NSString *)message
{
   
    // Create Local Notificaiton
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
 
    
    localNotification.fireDate                   = [NSDate dateWithTimeIntervalSince1970:time];
    localNotification.alertBody                  = message;
    localNotification.soundName                  = UILocalNotificationDefaultSoundName;
    localNotification.applicationIconBadgeNumber = 1;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

-(void) createNotificationPopup:(NSString *)message
{
    [[TKAlertCenter defaultCenter] postAlertWithMessage:message image:[UIImage imageNamed:@"icon_home"]];
}

#pragma mark Popup
-(void) createPopup:(int)eType setItem:(int)itemID
{
    // Current Window
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    // Root ViewController
    UIViewController *rootViewController = window.rootViewController;
    // Root View
    UIView* masterView = rootViewController.view;
    
    // Create Grey Background (Tap to Cancel View Layer)
    UIView *dimBackgroundView = [[UIView alloc] initWithFrame:masterView.bounds];
    dimBackgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1.0f];
    dimBackgroundView.alpha = 0.0f;
    dimBackgroundView.tag = TAG_POPUP_GREY;
    [masterView addSubview:dimBackgroundView];
    
    // Issue Animation
    [UIView animateWithDuration:EFFECT_POPUP_FADE
                     animations:^{dimBackgroundView.alpha = 0.8;}
                     completion:^(BOOL finished){ }];
    
    // Add Tap (Cancel Popup)
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(dismissPopup:)];
    [dimBackgroundView addGestureRecognizer:singleFingerTap];
    
    
    
    // Setup Popup
    NSString* xib = @"";
    switch (eType) {
        case ePopupBuilding:
            xib = @"BuildingBuildView";
            break;
        case ePopupResearch:
            xib = @"ResearchActionView";
            break;
        default:
            break;
    }
    
    // Create Building Build View
    UIView *viewPopup = [[[NSBundle mainBundle] loadNibNamed:xib owner:self options:nil] objectAtIndex:0];
    [viewPopup setCenter:CGPointMake(masterView.frame.size.width*0.5f, masterView.frame.size.height*0.5f)];
    viewPopup.tag = TAG_POPUP;
    
    // Prepare For Animation Scale
    [viewPopup setTransform:CGAffineTransformMakeScale(0.01f, 0.01f)];
    [masterView addSubview:viewPopup];
    
    // Issue Animation
    [UIView animateWithDuration:EFFECT_POPUP_SCALE
                     animations:^{[viewPopup setTransform:CGAffineTransformMakeScale(1.0f, 1.0f)];}
                     completion:^(BOOL finished){ }];
    
    // Setup Popup
    [(BuildingBuildView*)viewPopup setup:itemID];
    
}

// Dismiss Popup
-(void) dismissPopup:(UITapGestureRecognizer *)recognizer {
    
    // Current Window
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    // Root ViewController
    UIViewController *rootViewController = window.rootViewController;
    // Root View
    UIView* masterView = rootViewController.view;
    
    UIView *dimBackgroundView   = [masterView viewWithTag:TAG_POPUP_GREY];
    UIView *buildingPopup       = [masterView viewWithTag:TAG_POPUP];
    
    // Remove Recognizer
    for (UIGestureRecognizer *recognizer in dimBackgroundView.gestureRecognizers) {
        [dimBackgroundView removeGestureRecognizer:recognizer];
    }
    
    // Issue Animation
    [UIView animateWithDuration:EFFECT_POPUP_FADE
                     animations:^{dimBackgroundView.alpha = 0.0;}
                     completion:^(BOOL finished){ [dimBackgroundView removeFromSuperview]; }];
    
    // Issue Animation
    [UIView animateWithDuration:EFFECT_POPUP_SCALE
                     animations:^{[buildingPopup setTransform:CGAffineTransformMakeScale(0.01f, 0.01f)];}
                     completion:^(BOOL finished){[buildingPopup removeFromSuperview]; }];

}

@end
