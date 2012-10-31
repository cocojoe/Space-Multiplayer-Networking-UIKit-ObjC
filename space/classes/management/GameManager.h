//
//  GameManager.h
//  littlekeepers
//
//  Created by Martin Walsh on 13/09/2012.
//  Copyright (c) 2012 Pedro LTD. All rights reserved.
//

#import <TapkuLibrary/TapkuLibrary.h>

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
#define TAG_PULL                        800
#define TAG_POPUP_GREY                  900
#define TAG_POPUP                       901

// Preferences
#define DEFAULT_SPEED                   60.0f
#define DEFAULT_QUEUE_VIEW_REFRESH      1.0f

// API Credentials
#define APP_ID          (@"67542423701777489896990453036662")
#define APP_SECRET      (@"ynTQL9cuckeX6FQ2wMFwJIVe70xLGd25qLL2LOnNZrBVWiOjUjFtSryPhWrO0kKh")

// REQUESTS
#define HOST_NAME       (@"http://darkmatter.andyburton.co.uk")
#define HOST_TIMEOUT    8
#define HOST_RETRY      5

// API
#define URI_AUTH                        (@"/api/auth/")
#define URI_PLAYER                      (@"/api/player/")
#define URI_PARTS                       (@"/api/player/parts")

#define URI_INVENTORY                   (@"/api/player/inventory")
#define URI_INVENTORY_REMOVE_PART       (@"/api/player/inventory/remove")
#define URI_INVENTORY_ATTACH_PART       (@"/api/player/inventory/attach")
#define URI_INVENTORY_ITEM_MASTER       (@"/api/inventory/item/")
#define URI_INVENTORY_GROUP_MASTER      (@"/api/inventory/group/")

#define URI_PART_MASTER                 (@"/api/part/")
#define URI_PLAYER_PLANETS              (@"/api/player/planets")
#define URI_PLANET                      (@"/api/planet/index")
#define URI_MASTER_BUILDING             (@"/api/building/")
#define URI_BUILDING_ALLOWED            (@"/api/player/buildings")

#define URI_BUILDING_ADD                (@"/api/planet/build")

// API Research
#define URI_MASTER_RESEARCH             (@"/api/research/")

// Errors
#define ERROR_WARNING                   1000

// Simple Caching / Request Spam
#define API_CACHE_TIME  30

enum eAuthenticationState {
    eAuthenticationNone,
    eAuthenticationInProgress,
    eAuthenticationOK
};

@class MasterViewController;

@interface GameManager : NSObject
{
    // API Data Caching
    NSMutableDictionary* _authDict;
    NSMutableDictionary* _playerDict;
    NSMutableDictionary* _partsDict;
    NSMutableDictionary* _inventoryDict;
    NSMutableDictionary* _planetsDict;
    
    // Planet Available
    NSMutableDictionary* _buildingsAllowedDict;
    NSMutableDictionary* _researchAllowedDict;
    
    // Queues (API Communication)
    NSOperationQueue *_requestQueue;
    NSOperationQueue *_requestSuspendQueue;
    
}

@property (nonatomic) NSString* deviceUUID;
@property (weak, nonatomic) UIViewController *view;
@property (nonatomic, readwrite) enum eAuthenticationState eAuthenticationState;

// Cache Stores (So Can Clear 'Cache' Publically)
@property (nonatomic) NSMutableDictionary* planetDict;

// Data Stores
@property (nonatomic) NSMutableArray* masterItemList;
@property (nonatomic) NSMutableArray* masterPartList;
@property (nonatomic) NSMutableArray* masterGroupList;
@property (nonatomic) NSMutableArray* masterBuildingList;
@property (nonatomic) NSMutableArray* masterResearchList;

// Preferences (Helpers)
@property (nonatomic, readwrite) int planetID;
-(void) setPlanet:(int) planet;

// Alerts
@property (retain,nonatomic) TKProgressAlertView *alertView;

// Singleton Instance
+(GameManager *)sharedInstance;

#pragma mark Queue Handling
-(void) addQueue:(NSBlockOperation*) operationBlock;

#pragma mark Device Indentity
-(NSString*) getDeviceID;

#pragma mark Authentication
-(void) loginStart;
-(void) loginComplete;
-(void) authenticate:(BasicBlock) successBlock setErrorBlock:(BasicBlock) errorBlock;

#pragma mark Player
-(void) refreshPlayer:(ResponseBlock) actionBlock;

#pragma mark Parts
-(void) refreshParts:(ResponseBlock) actionBlock;

#pragma mark Master Lists
-(void) retrieveMasterItem:(BasicBlock) actionBlock setErrorBlock:(BasicBlock) errorBlock;
-(void) retrieveMasterPart:(BasicBlock) actionBlock setErrorBlock:(BasicBlock) errorBlock;
-(void) retrieveMasterGroup:(BasicBlock) actionBlock setErrorBlock:(BasicBlock) errorBlock;
-(void) retrieveMasterBuilding:(BasicBlock) actionBlock setErrorBlock:(BasicBlock) errorBlock;
-(void) retrieveMasterResearch:(BasicBlock) actionBlock setErrorBlock:(BasicBlock) errorBlock;

#pragma mark Inventory
-(void) refreshInventory:(ResponseBlock) actionBlock;

#pragma mark Inventory Part Management
-(void) clearPart:(int)partID setBlock:(ResponseBlock) actionBlock;
-(void) setPart:(int)partID setItem:(int)itemID setBlock:(ResponseBlock) actionBlock;

#pragma mark Planets
-(void) refreshPlanets:(ResponseBlock) actionBlock;
-(void) refreshPlanet:(ResponseBlock) actionBlock;

#pragma mark Buildings
-(void) refreshBuildingsAllowed:(ResponseBlock) actionBlock;
-(void) addBuilding:(int)buildingID setAmount:(int)amount setPlanet:(int)planetID setBlock:(ResponseBlock) actionBlock setBlockFail:(BasicBlock) failBlock;

#pragma mark Notifications
-(void) createNotification:(double) time setMessage:(NSString*) message;

#pragma mark General Helpers
-(NSDictionary*) getBuilding:(int) building_id;

@end
