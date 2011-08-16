//
//  NetworkInterface.m
//  DrinkApp
//
//  Created by Tyler Casselman on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NetworkInterface.h"
#import "JSON.h"
#import "FacebookUser.h"
#import "DrinkAppAppDelegate.h"
#import "Drink.h"
#import "Tag.h"


#define kFBAppId @"165584076834065"

@interface NetworkInterface ()
- (void)createSession;
- (void)postStatusChange;

@property (nonatomic, readonly) Facebook * facebook;
@property (nonatomic, readonly) RESTInterface * restInterface;
@end

@implementation NetworkInterface
@synthesize loggedIn = loggedIn_;
@synthesize restInterface = restInterface_;


- (id)initWithBaseUrl:(NSString *)baseURL andPersistentStore:(PersistentStoreInterface*)persistentStoreInterface
{
	if((self = [super init]))
	{
		persistentStoreInterface_ = [persistentStoreInterface retain];
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
			[self createSession];
		}else{
			loggedIn_ = NO;			
			[self postStatusChange];
		}


	}
	return self;
}
- (void)dealloc
{
	[persistentStoreInterface_ release], persistentStoreInterface_ = nil;
	[facebook_ release], facebook_ = nil;
	[super dealloc];
}
#pragma mark -
#pragma Server interface calls
//facebook login logout
- (void)login
{
	NSArray * permissions = [NSArray arrayWithObjects:@"offline_access", nil];
	[self.facebook authorize:permissions delegate:self];
}

- (void)logout
{
	[self.facebook logout:self];
}

- (void)cheersFriend:(long long)fbid
{
	NSNumber * toFbid = [NSNumber numberWithLongLong:fbid];
	NSDictionary * payload = [NSDictionary dictionaryWithObjectsAndKeys:toFbid, @"fbid", nil];
	[self.restInterface invokeAction:RACreate onController:@"cheers" data:payload target:self callback:@selector(onCheers:)];
}

//update our servers with auth token and get initial data
- (void)createSession
{
	NSDictionary * payload = [NSDictionary dictionaryWithObjectsAndKeys:self.facebook.accessToken, @"token", nil];
	[self.restInterface invokeAction:RACreate onController:@"user_sessions" data:payload target:self callback:@selector(onConnect:)];
}

- (void)checkInWithId:(int)itemId count:(int)count
{
	NSDictionary * data = [NSDictionary dictionaryWithObjectsAndKeys:
						   [NSNumber numberWithLongLong:persistentStoreInterface_.fbId], @"user_id", 
						   [NSNumber numberWithInt:itemId], @"item_id",
						   [NSNumber numberWithInt:count], @"count",
						   nil];
	[self.restInterface invokeAction:RACreate onController:@"checkins" data:data target:nil callback:nil];
}

#pragma mark -
#pragma Server responses
/*
 * callback from our initial request to the server
 * The response contains our friend data, data about ourself, and potentially drink data
 */
- (void)onConnect:(ASIFormDataRequest *)request
{
	NSDictionary * data = [[request responseString] JSONValue];
	NSDictionary * me = [data objectForKey:@"me"];
	NSArray * friends = [data objectForKey:@"friends"];
	long long fbid = [[me objectForKey:@"uid"] longLongValue];
	NSString * firstName  = [me objectForKey:@"first_name"];
	NSString * lastName = [me objectForKey:@"last_name"];
	NSString * picURL = [me objectForKey:@"pic_square"];
	[persistentStoreInterface_ saveDrinks:[data objectForKey:@"drinks"]];
	[persistentStoreInterface_ saveUserData:fbid firstName:firstName lastName:lastName picURL:picURL accessToken:self.facebook.accessToken expirationDate:self.facebook.expirationDate];
	[persistentStoreInterface_ saveFriends:friends];
	loggedIn_ = YES;
	[self postStatusChange];

	
}

- (void)onCheers:(ASIFormDataRequest *)request
{
	
}

- (void)requestFailed:(id)request
{
	UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Connection Failed" message:@"The DrinkApp server is unavailable. rails s" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
	[alertView show];

}

#pragma AlertView delegate methods

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	[alertView release];
	exit(0);
}

//facilitates single sign on
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



/* Posts a 'status changed' notification to update the ui after login*/
- (void)postStatusChange
{
	NSDictionary * status = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:self.loggedIn], kLoggedInStatus, nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:kLoggedInStatusChangedNotif object:self userInfo:status];
	
}

#pragma FBSessionDelegate methods
- (void)fbDidLogin
{
	[self createSession];
}

- (void)fbDidNotLogin:(BOOL)cancelled
{
	[persistentStoreInterface_ removeUserData];
	[persistentStoreInterface_ removeFriends];
	loggedIn_ = NO;
	[self postStatusChange];
}

- (void)fbDidLogout
{
	[persistentStoreInterface_ removeUserData];
	[persistentStoreInterface_ removeFriends];
	loggedIn_ = NO;
	[self postStatusChange];
}


@end
