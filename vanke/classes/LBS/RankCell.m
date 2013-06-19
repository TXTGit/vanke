//
//  RankCell.m
//  vanke
//
//  Created by apple on 13-6-17.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "RankCell.h"

@implementation RankCell

@synthesize lblRank = _lblRank;
@synthesize headImageView = _headImageView;
@synthesize lblNickname = _lblNickname;
@synthesize lblTime = _lblTime;
@synthesize lblEnergy = _lblEnergy;
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
