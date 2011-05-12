//
//  NetworkInterface.h
//  DrinkApp
//
//  Created by Tyler Casselman on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Facebook.h"

#define kLoggedInStatusChangedNotif @"LoggedInStatusChanged"

@interface NetworkInterface : NSObject<FBSessionDelegate> {
    @private
	Facebook * facebook_;
	BOOL loggedIn_;
}
@property (nonatomic, readonly) BOOL loggedIn;
- (void)login;
- (void)logout;
- (BOOL)handleOpenURL:(NSURL *)url;
@end
