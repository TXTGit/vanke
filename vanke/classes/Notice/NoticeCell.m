//
//  NoticeCell.m
//  vanke
//
//  Created by pig on 13-6-27.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "NoticeCell.h"

@implementation NoticeCell

@synthesize lblTime = _lblTime;
@synthesize egoTitleImg = _egoTitleImg;
@synthesize lblSmallText = _lblSmallText;
@synthesize lblTitle = _lblTitle;

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
