//
//  NetworkInterface.h
//  DrinkApp
//
//  Created by Tyler Casselman on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Facebook.h"

@interface NetworkInterface : NSObject<FBSessionDelegate> {
    @private
	Facebook * facebook_;
}
- (void)login;
- (void)logout;
- (BOOL)handleOpenURL:(NSURL *)url;
@end
