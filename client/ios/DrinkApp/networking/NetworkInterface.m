//
//  NetworkInterface.m
//  DrinkApp
//
//  Created by Tyler Casselman on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NetworkInterface.h"
#import "JSON.h"

#define kFBAppId @"165584076834065"
#define kFBAccessTokenKey @"AccessTokenKey"
#define kFBExpirationDate @"ExpirationDate"

@interface NetworkInterface ()
- (void)postStatusChange;
- (void)saveUserData:(long long)fbid
		   firstName:(NSString*)firstName
			lastName:(NSString *)lastName
			  picURL:(NSString *)picURL
		 accessToken:(NSString*)accessToken
	  expirationDate:(NSDate *)expirationDate;
@property (nonatomic, readonly) Facebook * facebook;
@property (nonatomic, readonly) RESTInterface * restInterface;
@end

@implementation NetworkInterface
@synthesize loggedIn = loggedIn_;
@synthesize restInterface = restInterface_;
@dynamic fbId;

- (id)initWithBaseUrl:(NSString *)baseURL
{
	if((self = [super init]))
	{
		facebook_ = [[Facebook alloc] initWithAppId:kFBAppId];
		restInterface_ = [[RESTInterface alloc] initWithBaseURL:baseURL];
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

- (void)checkInWithId:(int)itemId count:(int)count
{
	NSDictionary * data = [NSDictionary dictionaryWithObjectsAndKeys:
						   [NSNumber numberWithLongLong:self.fbId], @"user_id", 
						   [NSNumber numberWithInt:itemId], @"item_id",
						   [NSNumber numberWithInt:count], @"count",
						   nil];
	[self.restInterface invokeAction:RACreate onController:@"checkins" data:data target:nil callback:nil];
}

- (void)createSession
{
	NSDictionary * payload = [NSDictionary dictionaryWithObjectsAndKeys:self.facebook.accessToken, @"token", nil];
	[self.restInterface invokeAction:RACreate onController:@"user_sessions" data:payload target:self callback:@selector(onConnect:)];
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
	[self checkInWithId:3 count:5];
}

/* Posts a 'status changed' notification to update the ui after login*/
- (void)postStatusChange
{
	NSDictionary * status = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:self.loggedIn], kLoggedInStatus, nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:kLoggedInStatusChangedNotif object:self userInfo:status];
	
}

- (void)saveUserData:(long long)fbid
		   firstName:(NSString*)firstName
			lastName:(NSString *)lastName
			  picURL:(NSString *)picURL
		 accessToken:(NSString*)accessToken
	  expirationDate:(NSDate *)expirationDate
{
	NSUserDefaults * def = [NSUserDefaults standardUserDefaults];
	[def setValue:[NSNumber numberWithLongLong:fbid] forKey:kFBID];
	[def setValue:firstName forKey:kFirstName];
	[def setValue:lastName forKey:kLastName];
	[def setValue:picURL forKey:kPicURL];
	[def setValue:accessToken forKey:kFBAccessTokenKey];
	[def setValue:expirationDate forKey:kFBExpirationDate];
	[def synchronize];
	
}

- (void)saveFriends:(NSArray *)friends
{
	
}

- (void)removeUserData
{
	NSUserDefaults * def = [NSUserDefaults standardUserDefaults];
	[def removeObjectForKey:kFBID];
	[def removeObjectForKey:kFirstName];
	[def removeObjectForKey:kLastName];
	[def removeObjectForKey:kFBAccessTokenKey];
	[def removeObjectForKey:kFBExpirationDate];
	[def synchronize];	
}
#pragma mark - 
#pragma user info

- (long long)fbId
{
	NSUserDefaults * def = [NSUserDefaults standardUserDefaults];
	return [[def objectForKey:kFBID] longLongValue];
}
#pragma mark -
#pragma Server responses
- (void)onConnect:(ASIFormDataRequest *)request
{
	NSDictionary * data = [[request responseString] JSONValue];
	NSDictionary * me = [[data objectForKey:@"me"] objectAtIndex:0];
	NSArray * friends = [data objectForKey:@"friends"];
	long long fbid = [[me objectForKey:@"uid"] longLongValue];
	NSString * firstName  = [me objectForKey:@"first_name"];
	NSString * lastName = [me objectForKey:@"last_name"];
	NSString * picURL = [me objectForKey:@"pic_square"];
	[self saveUserData:fbid firstName:firstName lastName:lastName picURL:picURL accessToken:self.facebook.accessToken expirationDate:self.facebook.expirationDate];
	[self saveFriends:friends];
}

#pragma FBSessionDelegate methods
- (void)fbDidLogin
{
	[self createSession];
}

- (void)fbDidNotLogin:(BOOL)cancelled
{
	[self removeUserData];
	loggedIn_ = NO;
	[self postStatusChange];
}

- (void)fbDidLogout
{
	[self removeUserData];
	loggedIn_ = NO;
	[self postStatusChange];
}


@end
