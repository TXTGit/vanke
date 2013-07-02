//
//  ScoreCell.m
//  vanke
//
//  Created by pig on 13-7-2.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "ScoreCell.h"

@implementation ScoreCell

@synthesize lblTime = _lblTime;
@synthesize lblDistance = _lblDistance;
@synthesize lblScore = _lblScore;

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
