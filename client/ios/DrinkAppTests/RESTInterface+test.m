//
//  RESTInterface.m
//  DrinkApp
//
//  Created by Tyler Casselman on 7/27/11.
//  Copyright 2011 DrinkApp. All rights reserved.
//

#import "RESTInterface+test.h"
#import "ASIFormDataRequest.h"
@implementation RESTInterface (test)

- (void)invokeAction_dummy:(ResourceAction)action onController:(NSString *)controller data:(NSDictionary *)data target:(id)target callback:(SEL)callback
{
	if([controller isEqualToString:@"user_sessions"])
	{
		ASIFormDataRequest * request = [[ASIFormDataRequest alloc] init];
		
		NSString * dataPath = [[NSBundle mainBundle] pathForResource:@"dummy_login" ofType:@"json"];
		request.rawResponseData = [NSData dataWithContentsOfFile:dataPath];
		[target performSelector:callback withObject:request];
		[request release];
	}
}


@end
