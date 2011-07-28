//
//  Facebook+test.m
//  DrinkApp
//
//  Created by Tyler Casselman on 7/28/11.
//  Copyright 2011 DrinkApp. All rights reserved.
//

#import "Facebook+test.h"

@implementation Facebook (test)
- (void)authorize_dummy:(NSArray *)permissions
         delegate:(id<FBSessionDelegate>)delegate {
	[delegate fbDidLogin];
}
@end
