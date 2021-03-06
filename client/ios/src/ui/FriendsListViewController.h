//
//  FriendsListViewController.h
//  DrinkApp
//
//  Created by Tyler Casselman on 5/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkInterface.h"

@interface FriendsListViewController : UIViewController {
    IBOutlet UITableView * tableView_;
	IBOutlet UIBarButtonItem * loginButton_;
	NetworkInterface * networkInterface_;
	PersistentStoreInterface * persistentStoreInterface_;
	NSArray * friends_;
    NSArray * playingFriends_;
	
}
@property (nonatomic, retain) NetworkInterface * networkInterface;
@property (nonatomic, retain) PersistentStoreInterface * persistentStoreInterface;

- (IBAction)login:(id)sender;
@end
