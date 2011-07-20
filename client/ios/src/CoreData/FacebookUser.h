//
//  FacebookUser.h
//  DrinkApp
//
//  Created by Tyler Casselman on 6/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface FacebookUser : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * fbid;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * imgURL;
@property (nonatomic, retain) NSNumber * isAppUser;

@end
