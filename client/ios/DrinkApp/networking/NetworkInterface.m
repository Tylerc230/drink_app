//
//  NetworkInterface.m
//  DrinkApp
//
//  Created by Tyler Casselman on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NetworkInterface.h"

#define kFBAppId @"165584076834065"
#define kFBAccessTokenKey @"AccessTokenKey"
#define kFBExpirationDate @"ExpirationDate"

@interface NetworkInterface ()
- (void)postStatusChange;
@property (nonatomic, readonly) Facebook * facebook;
@end

@implementation NetworkInterface
@synthesize loggedIn = loggedIn_;

- (id)init
{
	if((self = [super init]))
	{
		facebook_ = [[Facebook alloc] initWithAppId:kFBAppId];
		NSString * accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:kFBAccessTokenKey];
		NSDate * expirationDate = [[NSUserDefaults standardUserDefaults] objectForKey:kFBExpirationDate];
		if(accessToken)
			self.facebook.accessToken = accessToken;
		if(expirationDate)
			self.facebook.expirationDate = expirationDate;
		BOOL sessionValid = [self.facebook isSessionValid];
		if (sessionValid) {
			loggedIn_ = YES;
		}else{
			loggedIn_ = NO;			
		}
		[self postStatusChange];

	}
	return self;
}
- (void)dealloc
{
	[facebook_ release], facebook_ = nil;
	[super dealloc];
}

- (void)login
{
	NSArray * permissions = [NSArray arrayWithObjects:@"offline_access", nil];
	[self.facebook authorize:permissions delegate:self];
}
- (void)logout
{
	[self.facebook logout:self];
}

- (BOOL)handleOpenURL:(NSURL *)url
{
	return [self.facebook handleOpenURL:url];
}

- (Facebook *)facebook
{
	if(facebook_ == nil)
		facebook_ = [[Facebook alloc] initWithAppId:kFBAppId];
	return facebook_;
}

- (void)getFriends
{
	[self.facebook requestWithGraphPath:@"me" andDelegate:self];
}

- (void)postStatusChange
{
	NSDictionary * status = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:self.loggedIn], kLoggedInStatus, nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:kLoggedInStatusChangedNotif object:self userInfo:status];
	
}

#pragma FBRequestDelegate methods
- (void)request:(FBRequest *)request didLoad:(id)result
{
	
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error
{
	
}

#pragma FBSessionDelegate methods
- (void)fbDidLogin
{
	[[NSUserDefaults standardUserDefaults] setValue:self.facebook.accessToken forKey:kFBAccessTokenKey];
	[[NSUserDefaults standardUserDefaults] setValue:self.facebook.expirationDate forKey:kFBExpirationDate];
	[[NSUserDefaults standardUserDefaults] synchronize];
	loggedIn_ = YES;
	[self postStatusChange];
}

- (void)fbDidNotLogin:(BOOL)cancelled
{
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:kFBAccessTokenKey];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:kFBExpirationDate];
	[[NSUserDefaults standardUserDefaults] synchronize];
	loggedIn_ = NO;
	[self postStatusChange];
}

- (void)fbDidLogout
{
	loggedIn_ = NO;
	[self postStatusChange];
}


@end
