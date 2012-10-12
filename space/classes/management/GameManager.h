//
//  GameManager.h
//  littlekeepers
//
//  Created by Martin Walsh on 13/09/2012.
//  Copyright (c) 2012 Pedro LTD. All rights reserved.
//

// Console Logging Macro
#ifdef DEBUG
#   define CCLOG(fmt, ...) NSLog(fmt, ##__VA_ARGS__);
#else
#   define CCLOG(...)
#endif

// Alert View Logging Macro
#ifdef DEBUG_ALERT
#   define ALOG(fmt, ...)  { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Warning"] message:[NSString stringWithFormat:fmt, ##__VA_ARGS__]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show]; }
#else
#   define ALOG(...)
#endif

// Blockdef
typedef void (^ResponseBlock)       (NSDictionary *jsonDict);
typedef void (^BasicBlock)          ();

// TAGS
#define TAG_PULL        800

// API Credentials
#define APP_ID          (@"67542423701777489896990453036662")
#define APP_SECRET      (@"ynTQL9cuckeX6FQ2wMFwJIVe70xLGd25qLL2LOnNZrBVWiOjUjFtSryPhWrO0kKh")

// REQUESTS
#define HOST_NAME       (@"http://darkmatter.andyburton.co.uk")
#define HOST_TIMEOUT    8
#define HOST_RETRY      5
#define URI_AUTH        (@"/api/auth/")
#define URI_PLAYER      (@"/api/player/")

// Simple Caching / Request Spam
#define API_CACHE_TIME  10

enum eAuthenticationState {
    eAuthenticationNone,
    eAuthenticationInProgress,
    eAuthenticationOK
};

@interface GameManager : NSObject
{
    // API Data
    NSMutableDictionary* _authDict;
    NSMutableDictionary* _playerDict;
    
    // Authentication Monitoring
    enum eAuthenticationState _eAuthenticationState;
    uint    _countdown;
    
    // Queues (API Communication)
    NSOperationQueue *_requestQueue;
    NSOperationQueue *_requestSuspendQueue;
    
}

@property (nonatomic) NSString* deviceUUID;
@property (weak, nonatomic) UIViewController *view;

// Singleton Instance
+(GameManager *)sharedInstance;

#pragma mark Queue Handling
-(void) addQueue:(NSBlockOperation*) operationBlock;

#pragma mark Device Indentity
-(NSString*) getDeviceID;

#pragma mark Public API Methods
-(void) authenticate;
-(void) refreshPlayer:(ResponseBlock) actionBlock;

@end
