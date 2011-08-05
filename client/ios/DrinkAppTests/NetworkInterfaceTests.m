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
#import "Drink.h"

@interface NetworkInterfaceTests ()
+ (void)swizzleMethods;
- (void)clearCoreData;
@end

@implementation NetworkInterfaceTests

+(void)initialize
{
	[self swizzleMethods];
}


- (void)setUp
{
    [super setUp];
	[self clearCoreData];
	
	persistentStoreInterface_ = [[PersistentStoreInterface alloc] init];
	networkInterface_ = [[NetworkInterface alloc] initWithBaseUrl:@"http://localhost" andPersistentStore:persistentStoreInterface_];

}

+ (void)swizzleMethods
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
	[persistentStoreInterface_ release];
    [super tearDown];
}


- (void)validateCoreData:(NSString *)test count:(int)expectedCount type:(NSString*) type
{
	NSEntityDescription * entityDescription = [NSEntityDescription entityForName:type inManagedObjectContext:persistentStoreInterface_->coreDataInterface_.managedObjectContext];
	STAssertNotNil(entityDescription, @"Entity description nil");
	NSFetchRequest * request = [[[NSFetchRequest alloc] init] autorelease];
	[request setEntity:entityDescription];
	NSError * error = nil;
	NSUInteger count = [persistentStoreInterface_->coreDataInterface_.managedObjectContext countForFetchRequest:request error:&error];
	STAssertNil(error, @"Drinks fetch failed %@", error);
	STAssertTrue(count == expectedCount, @"%@. Wrong number of %@ returned %d should have been %d",test, type, count, expectedCount);
}

- (void)testLoginLogoutDrinkPersistence {
	NSString * type = @"Drink";
	[self validateCoreData:@"Initial Count" count:0 type:type];
    [networkInterface_ login];
	[self validateCoreData:@"After first Login" count:3 type:type];
	[networkInterface_ logout];
	[self validateCoreData:@"After first logout" count:3 type:type];
	[networkInterface_ login];
	[self validateCoreData:@"After second login" count:3 type:type];
	[networkInterface_ logout];
}

- (void)testLoginLogoutFriendPersistence
{
	NSString * type = @"FacebookUser";
	[self validateCoreData:@"Initial Count" count:0 type:type];
    [networkInterface_ login];
	[self validateCoreData:@"After first Login" count:60 type:type];
	[networkInterface_ logout];
	[self validateCoreData:@"After first logout" count:0 type:type];
	[networkInterface_ login];
	[self validateCoreData:@"After second login" count:60 type:type];
	[networkInterface_ logout];
	
}

- (void)testDrinkContent
{
	[networkInterface_ login];
	NSArray * drinks = [persistentStoreInterface_->coreDataInterface_ fetchType:@"Drink" withPredicate:nil];
	for (int i = 0; i < drinks.count; i++) 
	{
		Drink * drink = [drinks objectAtIndex:i];
		STAssertNotNil(drink.name, @"Drink missing name");
	}
}

- (void)testFriendContent
{
	
}
 


@end
