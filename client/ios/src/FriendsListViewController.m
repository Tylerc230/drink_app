//
//  FriendsListViewController.m
//  DrinkApp
//
//  Created by Tyler Casselman on 5/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FriendsListViewController.h"
#import "NetworkInterface.h"
#define kPlayingSectionId 0
#define kNotPlayingSectionId 1
#define kNumSections 2

@implementation FriendsListViewController
@synthesize networkInterface = networkInterface_;

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if((self = [super initWithCoder:aDecoder]))
	{
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(friendsUpdated:) name:kFriendDataLoadedNotif object:nil];		
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
#pragma notifications

- (void)friendsUpdated:(NSNotification *)notif
{
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
			NSDictionary * friend = [self.networkInterface.playingFriendInfo objectAtIndex:indexPath.row];
			cell.textLabel.text = [friend objectForKey:@"first_name"];
			break;
		}
		case kNotPlayingSectionId:
		{
			NSDictionary * friend = [self.networkInterface.fbFriendInfo objectAtIndex:indexPath.row];
			cell.textLabel.text = [friend objectForKey:@"first_name"];
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
			return self.networkInterface.playingFriendInfo.count;
		case kNotPlayingSectionId:
			return self.networkInterface.fbFriendInfo.count;
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
