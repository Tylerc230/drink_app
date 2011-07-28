//
//  TestHelpers.m
//  DrinkApp
//
//  Created by Tyler Casselman on 7/27/11.
//  Copyright 2011 DrinkApp. All rights reserved.
//

#import "TestHelpers.h"
#import <objc/runtime.h>
#import <objc/message.h>
@implementation TestHelpers

+ (void)swizzleMethod:(SEL)orgSel forMethod:(SEL)altSel inClass:(Class)c
{
	NSLog(@"swizzling %@ instance methods: %@ -> %@", NSStringFromClass(c), 
		  NSStringFromSelector(orgSel), NSStringFromSelector(altSel));
	
	Method origMethod = class_getInstanceMethod(c, orgSel);
	Method newMethod = class_getInstanceMethod(c, altSel);
	
	// check if method is inherited        from superclass
	if(class_addMethod(c, orgSel, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)))
		class_replaceMethod(c, altSel, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
	
	// exchange un-subclassed method
	else
		method_exchangeImplementations(origMethod, newMethod);
	/*
	Method orgMethod = class_getInstanceMethod(c, orgSel);
	Method altMethod = class_getInstanceMethod(c, altSel);
	c = object_getClass(c);
	
    if(class_addMethod(c, orgSel, method_getImplementation(altMethod), method_getTypeEncoding(altMethod)))
        class_replaceMethod(c, altSel, method_getImplementation(orgMethod), method_getTypeEncoding(orgMethod));
    else
        method_exchangeImplementations(orgMethod, altMethod);
	 */
}
@end
