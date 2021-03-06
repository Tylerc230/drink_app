//
//  DrinkAppAppDelegate.m
//  DrinkApp
//
//  Created by Tyler Casselman on 5/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DrinkAppAppDelegate.h"
@interface DrinkAppAppDelegate ()

@end
@implementation DrinkAppAppDelegate


@synthesize window=_window;

@synthesize tabBarController=_tabBarController, networkInterface = networkInterface_, config = config_;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// Override point for customization after application launch.
	// Add the tab bar controller's current view as a subview of the window
	self.window.rootViewController = self.tabBarController;
	[self.window makeKeyAndVisible];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusChanged:) name:kLoggedInStatusChangedNotif object:nil];
	config_ = [[Config alloc] init];
	persistentStoreInterface_ = [[PersistentStoreInterface alloc] init];
	networkInterface_ = [[NetworkInterface alloc] initWithBaseUrl:self.config.serverBaseURL andPersistentStore:persistentStoreInterface_];
	
	friendView_.networkInterface = networkInterface_;
	friendView_.persistentStoreInterface = persistentStoreInterface_;
	
	drinkCountView_.networkInterface = networkInterface_;
	drinkCountView_.persistentStoreInterface = persistentStoreInterface_;

    return YES;
}

- (BOOL) application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
	return [self.networkInterface handleOpenURL:url];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
	/*
	 Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	 Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	 */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	/*
	 Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	 If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	 */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	/*
	 Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	 */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	/*
	 Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	 */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	/*
	 Called when the application is about to terminate.
	 Save data if appropriate.
	 See also applicationDidEnterBackground:.
	 */
}

- (void)dealloc
{
	[config_ release], config_ = nil;
	[networkInterface_ release], networkInterface_ = nil;
	[_window release];
	[_tabBarController release];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

#pragma Notification callback
- (void)statusChanged:(NSNotification *)notification
{
	NSDictionary * userInfo = [notification userInfo];
	BOOL loggedIn = [[userInfo objectForKey:kLoggedInStatus] boolValue];
	NSLog(@"Logged In %d", loggedIn);
}




@end
