//
//  NetworkInterface.h
//  DrinkApp
//
//  Created by Tyler Casselman on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Facebook.h"
#import "RESTInterface.h"

#define kLoggedInStatusChangedNotif @"LoggedInStatusChanged"
#define kLoggedInStatus @"LoggedInStatus"
#define kFBID @"FBID"
#define kFirstName @"FirstName"
#define kLastName @"LastName"
#define kPicURL @"picURL"

@interface NetworkInterface : NSObject<FBSessionDelegate, FBRequestDelegate> {
    @private
	Facebook * facebook_;
	RESTInterface * restInterface_;
	BOOL loggedIn_;
}
@property (nonatomic, readonly) BOOL loggedIn;
@property (nonatomic, readonly) long long fbId;


- (id)initWithBaseUrl:(NSString *)baseURL;
- (void)login;
- (void)logout;
- (void)checkInWithId:(int)itemId count:(int)count;
- (void)getFriends;

- (BOOL)handleOpenURL:(NSURL *)url;
@end
