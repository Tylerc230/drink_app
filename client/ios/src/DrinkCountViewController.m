//
//  DrinkCountViewController.m
//  DrinkApp
//
//  Created by Tyler Casselman on 6/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DrinkCountViewController.h"
#import "DrinkSelectionViewController.h"

@implementation DrinkCountViewController
@synthesize networkInterface = networkInterface_;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
	self.networkInterface = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma IBActions
- (IBAction)checkin:(UIButton *)sender
{
	int numDrinks = sender.tag;
	DrinkSelectionViewController * selectionView = [[DrinkSelectionViewController alloc] initWithNumDrinks:numDrinks];
	selectionView.networkInterface = self.networkInterface;
	[self.navigationController pushViewController:selectionView animated:YES];
	[selectionView release];
}


@end
