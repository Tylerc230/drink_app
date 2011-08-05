//
//  DrinkSelectionViewController.h
//  DrinkApp
//
//  Created by Tyler Casselman on 6/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkInterface.h"

@interface DrinkSelectionViewController : UITableViewController {
    int numDrinks_;
	NetworkInterface * networkInterface_;
	PersistentStoreInterface * persistentStoreInterface_;
	NSArray * drinksDisplayed_;
}
@property (nonatomic, retain) NetworkInterface * networkInterface;
@property (nonatomic, retain) PersistentStoreInterface * persistentStoreInterface;

- (id)initWithNumDrinks:(int)numDrinks;
@end
