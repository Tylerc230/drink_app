//
//  RESTInterface.m
//  DrinkApp
//
//  Created by Tyler Casselman on 5/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RESTInterface.h"
#import "ASIFormDataRequest.h"
@interface RESTInterface ()

@end

@implementation RESTInterface
@synthesize baseURL = baseURL_;
- (id)initWithBaseURL:(NSString *)baseURL
{
	if((self = [super init]))
	{
		self.baseURL = baseURL;
	}
	return self;
}

- (void)invokeAction:(ResourceAction)action onController:(NSString *)controller data:(NSDictionary *)data
{
	NSString * urlStr = [NSString stringWithFormat:@"%@/%@", self.baseURL, controller];
	NSURL * url = [NSURL URLWithString:urlStr];
	ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:url];
	for (NSString * key in data) {
		[request setPostValue:[data objectForKey:key] forKey:key];		
	}

	request.delegate = self;
	[request startAsynchronous];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	
}

@end
