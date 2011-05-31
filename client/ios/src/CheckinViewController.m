//
//  CheckinViewController.m
//  DrinkApp
//
//  Created by Tyler Casselman on 5/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CheckinViewController.h"

@interface CheckinViewController ()
- (void)setLoggedIn:(BOOL)loggedIn;
@end

@implementation CheckinViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if((self = [super initWithCoder:aDecoder]))
	{
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusChanged:) name:kLoggedInStatusChangedNotif object:nil];
	}
	return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
	appDelegate_ = (DrinkAppAppDelegate*)[UIApplication sharedApplication].delegate;
	[self setLoggedIn:appDelegate_.networkInterface.loggedIn];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)fbLogin:(id)sender
{
	if(appDelegate_.networkInterface.loggedIn)
		[appDelegate_.networkInterface logout];
	else
		[appDelegate_.networkInterface login];
}

- (IBAction)getFriends:(id)sender
{
	[appDelegate_.networkInterface getFriends];
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload
{
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (void)setLoggedIn:(BOOL)loggedIn
{
	if(loggedIn)
	{
		NSNumber * fbid = [[NSUserDefaults standardUserDefaults] objectForKey:kFBID];
		NSString * firstName = [[NSUserDefaults standardUserDefaults] objectForKey:kFirstName];
		NSString * lastName = [[NSUserDefaults standardUserDefaults] objectForKey:kLastName];
		userInfo_.text = [NSString stringWithFormat:@"id: %@\n %@ %@", fbid, firstName, lastName];
		[logginButton_ setTitle:@"logout" forState:UIControlStateNormal];
		getFriendsButton_.enabled = YES;
	}else{
		[logginButton_ setTitle:@"login" forState:UIControlStateNormal];
		userInfo_.text = @"Please log in";
		getFriendsButton_.enabled = NO;
	}
	
}


#pragma Notification callback
- (void)statusChanged:(NSNotification *)notification
{
	NSDictionary * userInfo = [notification userInfo];
	BOOL loggedIn = [[userInfo objectForKey:kLoggedInStatus] boolValue];
	[self setLoggedIn:loggedIn];
}

@end
