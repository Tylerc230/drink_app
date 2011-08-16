//
//  NetworkInterface.h
//  DrinkApp
//
//  Created by Tyler Casselman on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreData/CoreData.h"
#import "Facebook.h"
#import "RESTInterface.h"
#import "PersistentStoreInterface.h"

//Notifications
#define kLoggedInStatusChangedNotif @"LoggedInStatusChanged"

//Keys
#define kLoggedInStatus @"LoggedInStatus"

@class DrinkAppAppDelegate;

@interface NetworkInterface : NSObject<FBSessionDelegate, FBRequestDelegate> {
    @private
	Facebook * facebook_;
	RESTInterface * restInterface_;
	PersistentStoreInterface * persistentStoreInterface_;
	BOOL loggedIn_;
}
@property (nonatomic, readonly) BOOL loggedIn;


- (id)initWithBaseUrl:(NSString *)baseURL andPersistentStore:(PersistentStoreInterface*)persistentStoreInterface;
- (void)login;
- (void)logout;
- (void)cheersFriend:(long long)fbid;
- (void)checkInWithId:(int)itemId count:(int)count;

- (BOOL)handleOpenURL:(NSURL *)url;
@end
