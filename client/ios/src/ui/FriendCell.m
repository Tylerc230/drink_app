//
//  FriendCell.m
//  DrinkApp
//
//  Created by Tyler Casselman on 8/16/11.
//  Copyright 2011 DrinkApp. All rights reserved.
//

#import "FriendCell.h"


@implementation FriendCell

- (void)setImageURL:(NSString *)url
{
	[profileImage_ setUrlPath:url];
}

- (void)setName:(NSString *)name
{
	nameLabel_.text = name;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [super dealloc];
}

@end
