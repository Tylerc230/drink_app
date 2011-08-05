//
//  PersistentStoreInterface.m
//  DrinkApp
//
//  Created by Tyler Casselman on 8/4/11.
//  Copyright 2011 DrinkApp. All rights reserved.
//

#import "PersistentStoreInterface.h"
#import "FacebookUser.h"
#import "Drink.h"
#import "Tag.h"

#define kFBID @"FBID"
#define kFirstName @"FirstName"
#define kLastName @"LastName"
#define kPicURL @"picURL"

@implementation PersistentStoreInterface
@dynamic fbId;
- (id)init
{
    self = [super init];
    if (self) {
        coreDataInterface_ = [[CoreDataInterface alloc] init];
    }
    
    return self;
}

- (NSArray *)getFriends
{
	return [coreDataInterface_ fetchType:@"FacebookUser" withPredicate:nil];
}

- (NSArray *)drinksWithTagsLike:(NSString *)searchString
{
	NSArray * tags = [coreDataInterface_ fetchType:@"Tag" withPredicate:[NSString stringWithFormat:@"tagName beginswith '%@'", searchString]];
	NSMutableSet * drinks = [[NSMutableSet alloc] initWithCapacity:tags.count * 5];
	for (Tag * tag in tags) {
		[drinks addObjectsFromArray:[tag.drinks allObjects]];
	}
	return [drinks allObjects];
}

- (NSArray *)drinksWithNameLike:(NSString *)searchString
{
	return [coreDataInterface_ fetchType:@"Drink" withPredicate:[NSString stringWithFormat:@"name beginswith '%@'", searchString]];	
}

#pragma mark - 
#pragma user info

- (long long)fbId
{
	NSUserDefaults * def = [NSUserDefaults standardUserDefaults];
	return [[def objectForKey:kFBID] longLongValue];
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


@end
