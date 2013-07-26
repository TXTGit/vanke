//
//  RunRecordCell.m
//  vanke
//
//  Created by pig on 13-6-11.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "RunRecordCell.h"

@implementation RunRecordCell

@synthesize lblCreateTime = _lblCreateTime;
@synthesize lblRunDistance = _lblRunDistance;
@synthesize lblCalorie = _lblCalorie;
@synthesize lblSpead = _lblSpead;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initFont];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark 初始化字体
-(void)initFont
{
    [self.lblRunDistance setFont:MainFont(24.0f)];
    [self.lblCalorie setFont:MainFont(15.0f)];
    [self.lblCreateTime setFont:MainFont(14.0f)];
    [self.lblSpead setFont:MainFont(15.0f)];
}

@end
