//
//  NetworkInterfaceTests.m
//  DrinkApp
//
//  Created by Tyler Casselman on 7/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NetworkInterfaceTests.h"
#import "Helpers.h"
#import "TestHelpers.h"
#import "RESTInterface+test.h"
#import "Facebook+test.h"

@interface NetworkInterfaceTests ()
- (void)swizzleMethods;
- (void)clearCoreData;
@end

@implementation NetworkInterfaceTests

- (void)setUp
{
    [super setUp];
	[self swizzleMethods];
	[self clearCoreData];
	
    CoreDataInterface * coreDataInterface = [[CoreDataInterface alloc] init];
	networkInterface_ = [[NetworkInterface alloc] initWithBaseUrl:@"http://localhost" andCoreData:coreDataInterface];
	[coreDataInterface release];
}

- (void)swizzleMethods
{
	[TestHelpers swizzleMethod:@selector(invokeAction:onController:data:target:callback:)
					 forMethod:@selector(invokeAction_dummy:onController:data:target:callback:)
					   inClass:[RESTInterface class]];
	[TestHelpers swizzleMethod:@selector(authorize:delegate:)
					 forMethod:@selector(authorize_dummy:delegate:)
					   inClass:[Facebook class]];	
}

- (void)clearCoreData
{
	NSURL * sqliteFile = [[Helpers applicationDocumentsDirectory] URLByAppendingPathComponent:@"temp.sqlite"];
	NSError * error = nil;
	[[NSFileManager defaultManager] removeItemAtURL:sqliteFile error:&error];
}

- (void)tearDown
{
	[networkInterface_ release];
    [super tearDown];
}


- (void)testLogin {
    [networkInterface_ login];
	STAssertFalse(YES, @"should fail");
    
}


@end
