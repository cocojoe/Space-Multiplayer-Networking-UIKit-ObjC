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
#define TAG_PULL                800

#define TAG_PLAYER_VIEW         10
#define TAG_HANGAR_VIEW         20

// API Credentials
#define APP_ID          (@"67542423701777489896990453036662")
#define APP_SECRET      (@"ynTQL9cuckeX6FQ2wMFwJIVe70xLGd25qLL2LOnNZrBVWiOjUjFtSryPhWrO0kKh")

// REQUESTS
#define HOST_NAME       (@"http://darkmatter.andyburton.co.uk")
#define HOST_TIMEOUT    8
#define HOST_RETRY      5

#define URI_AUTH                        (@"/api/auth/")
#define URI_PLAYER                      (@"/api/player/")
#define URI_INVENTORY                   (@"/api/player/inventory")
#define URI_INVENTORY_REMOVE_PART       (@"/api/player/inventory/remove")
#define URI_INVENTORY_ATTACH_PART       (@"/api/player/inventory/attach")

// Simple Caching / Request Spam
#define API_CACHE_TIME  10

enum eAuthenticationState {
    eAuthenticationNone,
    eAuthenticationInProgress,
    eAuthenticationOK
};

@class MasterViewController;

@interface GameManager : NSObject
{
    // API Data
    NSMutableDictionary* _authDict;
    NSMutableDictionary* _playerDict;
    NSMutableDictionary* _inventoryDict;
    
    // Authentication Monitoring
    enum eAuthenticationState _eAuthenticationState;
    uint    _countdown;
    
    // Queues (API Communication)
    NSOperationQueue *_requestQueue;
    NSOperationQueue *_requestSuspendQueue;
    
}

@property (nonatomic) NSString* deviceUUID;
@property (weak, nonatomic) UIViewController *view;
@property (weak, nonatomic) MasterViewController *masterController;

// Singleton Instance
+(GameManager *)sharedInstance;

#pragma mark Queue Handling
-(void) addQueue:(NSBlockOperation*) operationBlock;

#pragma mark Device Indentity
-(NSString*) getDeviceID;

#pragma mark Authentication
-(void) authenticate;

#pragma mark Player
-(void) refreshPlayer:(ResponseBlock) actionBlock;

#pragma mark Inventory
-(void) refreshInventory:(ResponseBlock) actionBlock;

#pragma mark Inventory Part Management
-(void) clearPart:(int)partID setBlock:(ResponseBlock) actionBlock;
-(void) setPart:(int)partID setItem:(int)itemID setBlock:(ResponseBlock) actionBlock;
    
@end
