//
//  Config.h
//  DrinkApp
//
//  Created by Tyler Casselman on 5/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Config : NSObject {
	NSDictionary * data;
}

@property (nonatomic, readonly) NSString * serverBaseURL;

@end
