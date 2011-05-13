//
//  FirstViewController.h
//  DrinkApp
//
//  Created by Tyler Casselman on 5/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrinkAppAppDelegate.h"

@interface FirstViewController : UIViewController {
	DrinkAppAppDelegate * appDelegate_;
	IBOutlet UIButton * logginButton_;
	IBOutlet UIButton * getFriendsButton_;
}
- (IBAction)fbLogin:(id)sender;
- (IBAction)getFriends:(id)sender;


@end
