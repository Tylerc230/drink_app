//
//  Tag.h
//  DrinkApp
//
//  Created by Tyler Casselman on 8/4/11.
//  Copyright (c) 2011 DrinkApp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Drink;

@interface Tag : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString *tagName;
@property (nonatomic, retain) NSSet *drinks;

@end
