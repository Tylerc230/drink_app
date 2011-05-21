//
//  RESTInterface.m
//  DrinkApp
//
//  Created by Tyler Casselman on 5/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RESTInterface.h"
#import "JSON.h"
@interface RESTInterface ()

@end

@implementation RESTInterface
@synthesize baseURL = baseURL_;
- (id)initWithBaseURL:(NSString *)baseURL
{
	if((self = [super init]))
	{
		self.baseURL = baseURL;
		activeRequests_ = [[NSMutableDictionary alloc] initWithCapacity:10];
	}
	return self;
}

- (void)dealloc
{
	self.baseURL = nil;
	[activeRequests_ release];
	[super dealloc];
}


- (void)invokeAction:(ResourceAction)action onController:(NSString *)controller data:(NSDictionary *)data target:(id)target callback:(SEL)callback
{
	NSString * urlStr = [NSString stringWithFormat:@"%@/%@", self.baseURL, controller];
	NSURL * url = [NSURL URLWithString:urlStr];
	ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:url];
	request.delegate = target;
	request.didFinishSelector = callback;
	for (NSString * key in data) {
		[request setPostValue:[data objectForKey:key] forKey:key];		
	}
	[request startAsynchronous];
}

@end
