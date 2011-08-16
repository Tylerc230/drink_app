//
//  CoreDataInterface.h
//  DrinkApp
//
//  Created by Tyler Casselman on 7/27/11.
//  Copyright 2011 DrinkApp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreData/CoreData.h"

@interface CoreDataInterface : NSObject
{
	NSManagedObjectContext * managedObjectContext_;
}

@property (nonatomic, readonly) NSManagedObjectContext * managedObjectContext;

- (id)createObjectOfType:(NSString *)objectType;
- (NSArray *)fetchType:(NSString *) type withPredicate:(NSString *)predicate;
- (NSArray *)fetchType:(NSString *) type withPredicate:(NSString *)predicate sortOn:sort;
- (void)removeAllObjectsOfType:(NSString *)type;
- (void)saveContext;

@end

