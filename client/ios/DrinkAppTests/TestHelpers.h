//
//  TestHelpers.h
//  DrinkApp
//
//  Created by Tyler Casselman on 7/27/11.
//  Copyright 2011 DrinkApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestHelpers : NSObject
+ (void)swizzleMethod:(SEL)method1 forMethod:(SEL)method2 inClass:(Class)class;
@end
