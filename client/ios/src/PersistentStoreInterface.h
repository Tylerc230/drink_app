//
//  PersistentStoreInterface.h
//  DrinkApp
//
//  Created by Tyler Casselman on 8/4/11.
//  Copyright 2011 DrinkApp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataInterface.h"

//notifications
#define kFriendDataLoadedNotif @"FriendDataLoaded"

//keys
#define kFBAccessTokenKey @"AccessTokenKey"
#define kFBExpirationDate @"ExpirationDate"

@interface PersistentStoreInterface : NSObject
{
	@public
	CoreDataInterface * coreDataInterface_;
}
@property (nonatomic, readonly) long long fbId;

- (NSArray *)getFriends;
- (NSArray *)drinksWithNameLike:(NSString *)searchString;
- (NSArray *)drinksWithTagsLike:(NSString *)searchString;
- (void)saveUserData:(long long)fbid
		   firstName:(NSString*)firstName
			lastName:(NSString *)lastName
			  picURL:(NSString *)picURL
		 accessToken:(NSString*)accessToken
	  expirationDate:(NSDate *)expirationDate;
- (void)saveFriends:(NSArray *)friends;
- (void)saveDrinks:(NSArray *)data;
- (void)removeFriends;
- (void)removeUserData;
- (void)removeDrinks;
- (NSSet *)createTags:(NSArray *)tags;
@end
