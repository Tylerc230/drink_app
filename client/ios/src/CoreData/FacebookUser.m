//
//  FacebookUser.m
//  DrinkApp
//
//  Created by Tyler Casselman on 6/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "FacebookUser.h"


@implementation FacebookUser
@dynamic fullName;
@dynamic fbid;
@dynamic firstName;
@dynamic lastName;
@dynamic imgURL;
@dynamic isAppUser;

- (NSString *)fullName
{
	return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

@end
