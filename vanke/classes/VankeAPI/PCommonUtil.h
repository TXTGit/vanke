//
//  PCommonUtil.h
//  vanke
//
//  Created by pig on 13-6-11.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DEGREES_2_RADIANS(x) (0.0174532925 * (x))

#define EARTH_RADIUS 6378.137   //地球半径km

#define UpdateUnreadMessageCount @"UpdateUnreadMessageCount"

#define MainFont(s) [UIFont fontWithName:@"Bebas" size:s]

@interface PCommonUtil : NSObject

+(NSString *)md5Encode:(NSString *)str;
+(NSString *)encodeBase64:(NSString *)str;
+(NSString *)decodeBase64:(NSString *)str;

/*
 * 已知体重,距离,计算卡路里消耗
 * 跑步热量（kcal）＝体重（kg）×距离（公里）×1.036
 *
 * 例如：体重60公斤的人，长跑8公里，那么消耗的热量＝60×8×1.036＝497.28 kcal(千卡) 
 */
+(double)calcCalorie:(double)tWeight distance:(double)tDistance;

+(NSString *)encodeUrlParameter:(NSString *)param;
+(NSString *)decodeUrlParameter:(NSString *)param;

+(UIImage *)maskImage:(UIImage *)baseImage withImage:(UIImage *)theMaskImage;
+(UIImage *)getCircleProcessImageWithAlpha:(CGSize)imageSize progress:(float)progress;
+(UIImage *)getCircleProcessImageWithNoneAlpha:(CGSize)imageSize progress:(float)progress;

+(NSString *)formatDate:(NSDate *)tempDate formatter:(NSString *)formatter;
+(NSString *)formatTime:(long)timeTnterval formatter:(NSString *)formatter;

+(double)rad:(double)d;
+(double)getDistanceByLatitude1:(double)lat1 longitude1:(double)lng1 latitude2:(double)lat2 longitude2:(double)lng2;

+(double)calcDistance:(double)lat1 longitude1:(double)lng1 latitude2:(double)lat2 longitude2:(double)lng2;

+(BOOL) isValidateMobile:(NSString *)mobile;
+(BOOL) isValidateIdentityCard:(NSString *)IdCard;

+(NSString *)getSystemVersion;

+(id)checkDataIsNull:(id)data;

+(int)getWeekFromTime:(NSString *)strTime;

+(NSString*)getHeadImgUrl:(NSString*)headImg;
//判断是否Iphone5
+ (BOOL)isIPhone5;

//合并图片
+(UIImage *)mergerImage:(UIImage *)firstImage secodImage:(UIImage *)secondImage;

@end
