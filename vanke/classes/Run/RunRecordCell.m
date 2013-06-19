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
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
