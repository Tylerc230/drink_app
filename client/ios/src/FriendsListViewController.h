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
	NetworkInterface * networkInterface_;
}
@property (nonatomic, retain) NetworkInterface * networkInterface;


@end
