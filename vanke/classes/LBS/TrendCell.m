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
        self.lblRunTime.font = MainFont(13.0f);
        self.lblCalorie.font = MainFont(13.0f);
        self.lblSpead.font = MainFont(13.0f);
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
            [self.lblTitle sizeThatFits:CGSizeMake(155, 42)];
        }
        if ([PCommonUtil checkDataIsNull:_trendInfo.shareTime]) {
            self.lblTime.text = [[_trendInfo.shareTime componentsSeparatedByString:@"T"][0] componentsSeparatedByString:@" "][0];
            NSLog(@"%@",self.lblTime.text);
        }
        if ([PCommonUtil checkDataIsNull:_trendInfo.shareImg]) {
            NSString *testImageUrl = [VankeAPI getSharePicUrl:_trendInfo.shareImg];
            NSLog(@"testImageUrl:%@",testImageUrl);
            [self.imgShare setImageURL:[NSURL URLWithString:testImageUrl]];
//            [self.imgShare setImage:[UIImage imageWithData:imageData]];
        }
        
        //run time
        long tempShowRunningTime = _trendInfo.minute * 60;
        NSString *temphh = [NSString stringWithFormat:@"%ld", tempShowRunningTime / 3600];
        if (temphh.length == 1) {
            temphh = [NSString stringWithFormat:@"0%@", temphh];
        }
        NSString *tempmm = [NSString stringWithFormat:@"%ld", (tempShowRunningTime / 60) % 60];
        if (tempmm.length == 1) {
            tempmm = [NSString stringWithFormat:@"0%@", tempmm];
        }
        NSString *tempss = [NSString stringWithFormat:@"%ld", tempShowRunningTime % 60];
        if (tempss.length == 1) {
            tempss = [NSString stringWithFormat:@"0%@", tempss];
        }
        _lblRunTime.text = [NSString stringWithFormat:@"%@:%@:%@", temphh, tempmm, tempss];
        
        //calorie
        _lblCalorie.text = [NSString stringWithFormat:@"%.2f", _trendInfo.calorie];
        
        //speed
        float secondPerMileage = (_trendInfo.mileage > 0.0001) ? _trendInfo.minute * 60 / _trendInfo.mileage : 0;
        int tempMinute = secondPerMileage / 60;
        int tempSecond = secondPerMileage - tempMinute * 60;
        
        NSString *tempspeedmm = [NSString stringWithFormat:@"%d", tempMinute];
        if (tempspeedmm.length == 1) {
            tempspeedmm = [NSString stringWithFormat:@"0%@", tempspeedmm];
        }
        NSString *tempspeedss = [NSString stringWithFormat:@"%d", tempSecond];
        if (tempspeedss.length == 1) {
            tempspeedss = [NSString stringWithFormat:@"0%@", tempspeedss];
        }
        _lblSpead.text = [NSString stringWithFormat:@"%@'%@\"", tempspeedmm, tempspeedss];
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
    cellframe.size.height = _imgBg.frame.size.height + 12;
    self.frame = cellframe;
    
}

@end
