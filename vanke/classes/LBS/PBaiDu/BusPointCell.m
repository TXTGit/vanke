//
//  BusPointCell.m
//  vanke
//
//  Created by pig on 13-6-15.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "BusPointCell.h"

@implementation BusPointCell

@synthesize btnUserTip = _btnUserTip;
@synthesize lblNickName = _lblNickName;
@synthesize lblDistance = _lblDistance;
@synthesize lblLoginTime = _lblLoginTime;

@synthesize nearFriend = _nearFriend;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
