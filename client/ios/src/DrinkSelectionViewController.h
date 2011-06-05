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
}
@property (nonatomic, retain) NetworkInterface * networkInterface;

- (id)initWithNumDrinks:(int)numDrinks;
@end
