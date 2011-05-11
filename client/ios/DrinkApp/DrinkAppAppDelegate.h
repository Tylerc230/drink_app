//
//  DrinkAppAppDelegate.h
//  DrinkApp
//
//  Created by Tyler Casselman on 5/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkInterface.h"
@interface DrinkAppAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
	NetworkInterface * networkInterface_;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@property (nonatomic, readonly) NetworkInterface * networkInterface;

@end
