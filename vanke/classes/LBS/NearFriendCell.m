//
//  NearFriendCell.m
//  vanke
//
//  Created by pig on 13-6-13.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "NearFriendCell.h"

@implementation NearFriendCell

@synthesize headImageView = _headImageView;
@synthesize lblNickname = _lblNickname;
@synthesize lblNearDistance = _lblNearDistance;
@synthesize isFriendImageView = _isFriendImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
