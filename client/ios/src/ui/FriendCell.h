//
//  FriendCell.h
//  DrinkApp
//
//  Created by Tyler Casselman on 8/16/11.
//  Copyright 2011 DrinkApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Three20/Three20.h"

@interface FriendCell : UITableViewCell {
    IBOutlet TTImageView *	profileImage_;
	IBOutlet UILabel *		nameLabel_;
}

- (void)setImageURL:(NSString *)url;
- (void)setName:(NSString *)name;

@end
