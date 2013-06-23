//
//  TrendCell.m
//  vanke
//
//  Created by user on 13-6-20.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "TrendCell.h"
#import "PCommonUtil.h"
#import "VankeAPI.h"
#import "UIImage+PImageCategory.h"

@implementation TrendCell

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

-(void)updateView{
    @try {
        if ([PCommonUtil checkDataIsNull:_trendInfo.shareContent]) {
            self.lblTitle.text = _trendInfo.shareContent;
        }
        if ([PCommonUtil checkDataIsNull:_trendInfo.shareTime]) {
            self.lblTime.text = [_trendInfo.shareTime componentsSeparatedByString:@"T"][0];
        }
        if ([PCommonUtil checkDataIsNull:_trendInfo.shareImg]) {
            NSString *testImageUrl = [VankeAPI getSharePicUrl:_trendInfo.shareImg];
            NSLog(@"testImageUrl:%@",testImageUrl);
            [self.imgShare setImageURL:[NSURL URLWithString:testImageUrl]];
//            [self.imgShare setImage:[UIImage imageWithData:imageData]];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"parser TrendInfo failed...please check");
    }
    
    if (_trendInfo && [PCommonUtil checkDataIsNull:_trendInfo.shareImg]) {
        [_imgShare setHidden:NO];
    }else{
        CGRect bgFrame = self.imgBg.frame;
        bgFrame.size.height = 31;
        self.imgBg.frame = bgFrame;
        CGRect vLineFrame = self.imgVline.frame;
        vLineFrame.size.height = 55;
        self.imgVline.frame = vLineFrame;
    }
    
    CGRect cellframe = self.frame;
    cellframe.size.height = _imgBg.frame.size.height + 24;
    self.frame = cellframe;
    
}

@end
