//
//  FriendCell.m
//  vanke
//
//  Created by pig on 13-6-12.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "FriendCell.h"
#import "PCommonUtil.h"

@implementation FriendCell

@synthesize headImageView = _headImageView;
@synthesize lblNickname = _lblNickname;
@synthesize lblTime = _lblTime;
@synthesize btnChat = _btnChat;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self.lblTime setFont:MainFont(12.0f)];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
