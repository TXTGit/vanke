//
//  TrendInfo.m
//  vanke
//
//  Created by user on 13-6-20.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "TrendInfo.h"
#import "PCommonUtil.h"

@implementation TrendInfo

@synthesize shareID = _shareID;
@synthesize memberID = _memberID;
@synthesize shareContent = _shareContent;
@synthesize shareImg = _shareImg;
@synthesize shareTime = _shareTime;
@synthesize nickName = _nickName;
@synthesize headImg = _headImg;
@synthesize loginTime = _loginTime;
@synthesize isFan = _isFan;
@synthesize minute = _minute;
@synthesize calorie = _calorie;
@synthesize mileage = _mileage;

+(TrendInfo *)initWithNSDictionary:(NSDictionary *)dict{
    
    TrendInfo *trendInfo = nil;
    
    @try {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            trendInfo = [[TrendInfo alloc] init];
            trendInfo.shareID = [[dict objectForKey:@"shareID"] longValue];
            trendInfo.memberID = [[dict objectForKey:@"memberID"] longValue];
            trendInfo.shareContent = [dict objectForKey:@"shareContent"];
            trendInfo.shareImg = [dict objectForKey:@"shareImg"];
            trendInfo.shareTime = [dict objectForKey:@"shareTime"];
            trendInfo.nickName = [dict objectForKey:@"nickName"];
            trendInfo.headImg = [dict objectForKey:@"headImg"];
            trendInfo.loginTime = [dict objectForKey:@"loginTiem"];
            trendInfo.isFan = [[dict objectForKey:@"isFan"] intValue];
            trendInfo.minute = [[dict objectForKey:@"minute"] floatValue];
            trendInfo.calorie = [[dict objectForKey:@"calorie"] floatValue];
            trendInfo.mileage = [[dict objectForKey:@"mileage"] floatValue];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"parser RankInfo failed...please check");
    }
    
    return trendInfo;
}

@end
