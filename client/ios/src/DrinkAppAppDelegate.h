//
//  DrinkAppAppDelegate.h
//  DrinkApp
//
//  Created by Tyler Casselman on 5/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NetworkInterface.h"
#import "Config.h"
#import "FriendsListViewController.h"
#import "DrinkCountViewController.h"
#import "PersistentStoreInterface.h"


@interface DrinkAppAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
	NetworkInterface * networkInterface_;
	Config * config_;
	PersistentStoreInterface * persistentStoreInterface_;
	
	IBOutlet FriendsListViewController * friendView_;
	IBOutlet DrinkCountViewController * drinkCountView_;
	
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, readonly) NetworkInterface * networkInterface;
@property (nonatomic, readonly) Config * config;
@end
