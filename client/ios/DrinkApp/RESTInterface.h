//
//  RESTInterface.h
//  DrinkApp
//
//  Created by Tyler Casselman on 5/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
typedef enum
{
	RACreate,
	RAShow,
	RAUpdate,
	RADestroy
}ResourceAction;
@interface RESTInterface : NSObject {
    NSString *		baseURL_;
	NSMutableDictionary *	activeRequests_;
}
@property (nonatomic, retain) NSString * baseURL;


- (id)initWithBaseURL:(NSString *)baseURL;
- (void)invokeAction:(ResourceAction)action onController:(NSString *)controller data:(NSDictionary *)data target:(id)target callback:(SEL)callback;
@end

