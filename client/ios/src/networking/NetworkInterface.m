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
#define kFBAccessTokenKey @"AccessTokenKey"
#define kFBExpirationDate @"ExpirationDate"

@interface NetworkInterface ()
- (void)createSession;
- (void)postStatusChange;
- (void)saveUserData:(long long)fbid
		   firstName:(NSString*)firstName
			lastName:(NSString *)lastName
			  picURL:(NSString *)picURL
		 accessToken:(NSString*)accessToken
	  expirationDate:(NSDate *)expirationDate;
- (void)saveFriends:(NSArray *)friends;
- (void)saveDrinks:(NSArray *)data;
- (void)removeDrinks;
- (NSSet *)createTags:(NSArray *)tags;
@property (nonatomic, readonly) Facebook * facebook;
@property (nonatomic, readonly) RESTInterface * restInterface;
@end

@implementation NetworkInterface
@synthesize loggedIn = loggedIn_;
@synthesize restInterface = restInterface_;
@dynamic fbId;

- (id)initWithBaseUrl:(NSString *)baseURL andCoreData:(CoreDataInterface*)coreDataInterface
{
	if((self = [super init]))
	{
		coreDataInterface_ = [coreDataInterface retain];
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
	[coreDataInterface_ release], coreDataInterface_ = nil;
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

//update our servers with auth token and get initial data
- (void)createSession
{
	NSDictionary * payload = [NSDictionary dictionaryWithObjectsAndKeys:self.facebook.accessToken, @"token", nil];
	[self.restInterface invokeAction:RACreate onController:@"user_sessions" data:payload target:self callback:@selector(onConnect:)];
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
	[self saveDrinks:[data objectForKey:@"drinks"]];
	[self saveUserData:fbid firstName:firstName lastName:lastName picURL:picURL accessToken:self.facebook.accessToken expirationDate:self.facebook.expirationDate];
	[self saveFriends:friends];
	loggedIn_ = YES;
	[self postStatusChange];

	
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

- (NSArray *)getFriends
{
	return [coreDataInterface_ fetchType:@"FacebookUser" withPredicate:nil];
}

/* Posts a 'status changed' notification to update the ui after login*/
- (void)postStatusChange
{
	NSDictionary * status = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:self.loggedIn], kLoggedInStatus, nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:kLoggedInStatusChangedNotif object:self userInfo:status];
	
}
/*
 * Save data about ourself to the persistent store for offline play
 */
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

- (void)saveFriends:(NSArray *)friends
{	
	for (NSDictionary * friend in friends) {
		FacebookUser * fbUser = (FacebookUser *)[coreDataInterface_ createObjectOfType:@"FacebookUser"];
		fbUser.fbid = [friend objectForKey:@"fb_id"];
		fbUser.firstName = [friend objectForKey:@"first_name"];
		fbUser.lastName = [friend objectForKey:@"last_name"];
		fbUser.isAppUser = [friend objectForKey:@"app_user"];

		
	}
	[coreDataInterface_ saveContext];
	[[NSNotificationCenter defaultCenter] postNotificationName:kFriendDataLoadedNotif object:self userInfo:nil];
}

- (void)saveDrinks:(NSArray *)data
{
	[self removeDrinks];
	for (NSDictionary * drinkDict in data) {
		Drink * drink = (Drink*)[coreDataInterface_ createObjectOfType:@"Drink"];
		drink.name = [drinkDict objectForKey:@"name"];
		NSArray * tagNames = [[drinkDict objectForKey:@"tags"] componentsSeparatedByString:@","];
		drink.tags = [self createTags:tagNames];
	}
	[coreDataInterface_ saveContext];

}

- (NSSet *)createTags:(NSArray *)tagNames
{
	NSMutableSet * tags = [[NSMutableSet alloc] initWithCapacity:tagNames.count];
	for (NSString * tagName in tagNames)
	{
		tagName = [tagName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		Tag * tag = nil;
		NSArray * possibleTags = [coreDataInterface_ fetchType:@"Tag" withPredicate:[NSString stringWithFormat:@"tagName == '%@'", tagName]];
		if(possibleTags.count == 0)
		{
			tag = [coreDataInterface_ createObjectOfType:@"Tag"];
			tag.tagName = tagName;
		}else{
			tag = [possibleTags objectAtIndex:0];
		}
		[tags addObject:tag];
	}
	return tags;
}

- (void)removeFriends
{
	[coreDataInterface_ removeAllObjectsOfType:@"FacebookUser"];
}

- (void)removeDrinks
{
	[coreDataInterface_ removeAllObjectsOfType:@"Drink"];
}

#pragma mark - 
#pragma user info

- (long long)fbId
{
	NSUserDefaults * def = [NSUserDefaults standardUserDefaults];
	return [[def objectForKey:kFBID] longLongValue];
}

#pragma FBSessionDelegate methods
- (void)fbDidLogin
{
	[self createSession];
}

- (void)fbDidNotLogin:(BOOL)cancelled
{
	[self removeUserData];
	[self removeFriends];
	loggedIn_ = NO;
	[self postStatusChange];
}

- (void)fbDidLogout
{
	[self removeUserData];
	[self removeFriends];
	loggedIn_ = NO;
	[self postStatusChange];
}


@end
