//
//  FriendsListViewController.m
//  DrinkApp
//
//  Created by Tyler Casselman on 5/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FriendsListViewController.h"
#import "NetworkInterface.h"
#import "FacebookUser.h"
#define kPlayingSectionId 0
#define kNotPlayingSectionId 1
#define kNumSections 2

@implementation FriendsListViewController
@synthesize networkInterface = networkInterface_, persistentStoreInterface = persistentStoreInterface_;

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if((self = [super initWithCoder:aDecoder]))
	{
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(friendsUpdated:) name:kFriendDataLoadedNotif object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionStatusChanged:) name:kLoggedInStatusChangedNotif object:nil];
	}
	return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

#pragma mark -
#pragma IBActions

- (IBAction)login:(id)sender
{
	if(networkInterface_.loggedIn)
	{
		[networkInterface_ logout];
	}else
	{
		[networkInterface_ login];
	}
}

#pragma mark -
#pragma notifications

- (void)friendsUpdated:(NSNotification *)notif
{
	playingFriends_ = [[persistentStoreInterface_ getPlayingFriends] retain];
	friends_ = [[persistentStoreInterface_ getNonPlayingFriends] retain];
	[tableView_ reloadData];
}

- (void)sessionStatusChanged:(NSNotification *)notif
{
	NSDictionary * status = [notif userInfo];
	if([[status objectForKey:kLoggedInStatus] boolValue])
	{
		loginButton_.title = @"logout";
	}else
	{
		loginButton_.title = @"login";
	}
	[tableView_ reloadData];
}

#pragma mark -
#pragma UITableViewSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return kNumSections;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	switch (section) {
		case kPlayingSectionId:
			return @"Friends Playing Game";
		case kNotPlayingSectionId:
			return @"Invite More Friends";
		default:
			break;
	}
	return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"tableviewcell"];
	if(cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tableviewcell"];
	}

	switch (indexPath.section) {
		case kPlayingSectionId:
		{
			FacebookUser * friend = [playingFriends_ objectAtIndex:indexPath.row];
			cell.textLabel.text = friend.firstName;
			break;
		}
		case kNotPlayingSectionId:
		{
			FacebookUser * friend = [friends_ objectAtIndex:indexPath.row];
			cell.textLabel.text = friend.firstName;
			break;
		}
			
		default:
			break;
	}
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	switch (section) {
		case kPlayingSectionId:
			return playingFriends_.count;
		case kNotPlayingSectionId:
			return friends_.count;
		default:
			return 0;
	}
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc
{
    [super dealloc];
	[[NSNotificationCenter defaultCenter] removeObject:self];
}

@end
