//
//  NetworkInterface.m
//  DrinkApp
//
//  Created by Tyler Casselman on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NetworkInterface.h"

#define kFBAppId @"165584076834065"
@interface NetworkInterface ()
@property (nonatomic, readonly) Facebook * facebook;
@end

@implementation NetworkInterface

- (id)init
{
	if((self = [super init]))
	{
		facebook_ = [[Facebook alloc] initWithAppId:kFBAppId];
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
	NSArray * permissions = [NSArray arrayWithObjects:@"read_stream", @"offline_access", nil];
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

#pragma FBSessionDelegate methods
- (void)fbDidLogin
{
	
}

- (void)fbDidNotLogin:(BOOL)cancelled
{
	
}

- (void)fbDidLogout
{
	
}


@end
