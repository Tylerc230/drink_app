//
//  DrinkCountViewController.h
//  DrinkApp
//
//  Created by Tyler Casselman on 6/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkInterface.h"

@interface DrinkCountViewController : UIViewController {
    NetworkInterface * networkInterface_;
	PersistentStoreInterface * persistentStoreInterface_;
}
@property (nonatomic, retain) NetworkInterface * networkInterface;
@property (nonatomic, retain) PersistentStoreInterface * persistentStoreInterface;
- (IBAction)checkin:(UIButton *)sender;

@end
