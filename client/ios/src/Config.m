//
//  Config.m
//  DrinkApp
//
//  Created by Tyler Casselman on 5/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Config.h"


@implementation Config
@dynamic serverBaseURL;
- (id)init
{
	if((self = [super init]))
	{
		data = [[[NSBundle mainBundle] infoDictionary] retain];
	}
	return self;
}

- (NSString *)serverBaseURL
{
	NSString * baseUrl = [data objectForKey:@"DAServerURL"];
	NSAssert(baseUrl, @"No base url specified in DrinkApp-Info.plist");
	return baseUrl;
}
 
-(void)dealloc
{
	[data release];
	[super dealloc];
}

@end
