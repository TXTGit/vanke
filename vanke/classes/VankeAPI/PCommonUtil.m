//
//  PCommonUtil.m
//  vanke
//
//  Created by pig on 13-6-11.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "PCommonUtil.h"
#import <CommonCrypto/CommonDigest.h>
#import "GTMBase64.h"
#import "VankeConfig.h"

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

@implementation PCommonUtil

+(NSString *)md5Encode:(NSString *)str{
    @try {
        if(str && [str isKindOfClass:[NSString class]]){
            const char *cStr = [str UTF8String];
            unsigned char result[16];
            CC_MD5(cStr, strlen(cStr), result);
            
            return [NSString stringWithFormat:
                    @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                    result[0], result[1], result[2], result[3],
                    result[4], result[5], result[6], result[7],
                    result[8], result[9], result[10], result[11],
                    result[12], result[13], result[14], result[15]
                    ];
        }
    }
    @catch (NSException *exception) {
        //NSLog(@"PCommonUtil md5 encode error...please check: %@", str);
    }
    
    return str;
}

+(NSString *)encodeBase64:(NSString *)str{
    if (str && [str isKindOfClass:[NSString class]]) {
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        return [[NSString alloc] initWithData:[GTMBase64 encodeData:data] encoding:NSUTF8StringEncoding];
    }
    return str;
}

+(NSString *)decodeBase64:(NSString *)str{
    if (str && [str isKindOfClass:[NSString class]]) {
        return [[NSString alloc] initWithData:[GTMBase64 decodeString:str] encoding:NSUTF8StringEncoding];
    }
    return str;
}

/*
 * 已知体重,距离,计算卡路里消耗
 * 跑步热量（kcal）＝体重（kg）×距离（公里）×1.036
 *
 * 例如：体重60公斤的人，长跑8公里，那么消耗的热量＝60×8×1.036＝497.28 kcal(千卡)
 */
+(double)calcCalorie:(double)tWeight distance:(double)tDistance{
    return tWeight * tDistance * 1.036;
}

+(NSString *)encodeUrlParameter:(NSString *)param{
    if (param) {
        return (NSString *)
        CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                  (__bridge CFStringRef)param,
                                                                  NULL,
                                                                  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                  kCFStringEncodingUTF8));;
    }
    
    return param;
}



+(NSString *)decodeUrlParameter:(NSString *)param{
    if (param) {
        return [param stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    return param;
}

//制作图片遮罩(注意：需要有一张原图是带alpha通道的图片，和一个不带alpha通道的遮罩图)
+(UIImage *)maskImage:(UIImage *)baseImage withImage:(UIImage *)theMaskImage
{
    UIGraphicsBeginImageContext(baseImage.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, baseImage.size.width, baseImage.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    CGImageRef maskRef = theMaskImage.CGImage;
    CGImageRef maskImage = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                             CGImageGetHeight(maskRef),
                                             CGImageGetBitsPerComponent(maskRef),
                                             CGImageGetBitsPerPixel(maskRef),
                                             CGImageGetBytesPerRow(maskRef),
                                             CGImageGetDataProvider(maskRef), NULL, false);
    
    CGImageRef masked = CGImageCreateWithMask([baseImage CGImage], maskImage);
    CGImageRelease(maskImage);//避免泄漏
    CGContextDrawImage(ctx, area, masked);
    CGImageRelease(masked);//避免泄漏
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return newImage;
}

//获取带有alpha通道的扇形进度圆圈
+(UIImage *)getCircleProcessImageWithAlpha:(CGSize)imageSize progress:(float)progress{
    
    float width = imageSize.width;
    float height = imageSize.height;
    UIGraphicsBeginImageContext(imageSize);
    
    CGPoint centerPoint = CGPointMake(height / 2, width / 2);
    CGFloat radius = MIN(height, width) / 2;
    
    CGFloat radians = DEGREES_2_RADIANS((progress*359.9)-90);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [[UIColor redColor] setFill];
    CGMutablePathRef progressPath = CGPathCreateMutable();
    CGPathMoveToPoint(progressPath, NULL, centerPoint.x, centerPoint.y);
    CGPathAddArc(progressPath, NULL, centerPoint.x, centerPoint.y, radius, DEGREES_2_RADIANS(270), radians, NO);
    CGPathCloseSubpath(progressPath);
    CGContextAddPath(context, progressPath);
    CGContextFillPath(context);
    CGPathRelease(progressPath);
    
    UIImage *pressedColorImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return pressedColorImg;
}

//获取不含有alpha通道的扇形进度圆圈
+(UIImage *)getCircleProcessImageWithNoneAlpha:(CGSize)imageSize progress:(float)progress{
    
    float width = imageSize.width;
    float height = imageSize.height;
    
    //圆心
    CGPoint centerPoint = CGPointMake(height / 2, width / 2);
    //半径
    CGFloat radius = MIN(height, width) / 2;
    //扇形开始角度
    CGFloat radians = DEGREES_2_RADIANS((360-progress*359.9)-270);
    
    //申请内存空间
    GLubyte * spriteData = (GLubyte *) calloc(width * height, sizeof(GLubyte));
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapContext = CGBitmapContextCreate(spriteData, width, height, 8, width, colorSpace, kCGImageAlphaNone);
    CGContextSetFillColorSpace(bitmapContext, colorSpace);
    
    //绘制全部底色
    CGRect rectAll = CGRectMake(0, 0, width, height);
    CGContextSetFillColorWithColor(bitmapContext, [UIColor blackColor].CGColor);
    CGContextFillRect(bitmapContext, rectAll);
    
    CGContextSetFillColorWithColor(bitmapContext, [UIColor whiteColor].CGColor);
    CGContextMoveToPoint(bitmapContext, centerPoint.x, centerPoint.y);
    CGContextAddArc(bitmapContext, centerPoint.x, centerPoint.y, radius, DEGREES_2_RADIANS(90), radians, 0);
    CGContextClosePath(bitmapContext);
    CGContextFillPath(bitmapContext);
    
    //
    //    CGMutablePathRef progressPath = CGPathCreateMutable();
    //    CGPathMoveToPoint(progressPath, NULL, centerPoint.x, centerPoint.y);
    //    CGPathAddArc(progressPath, NULL, centerPoint.x, centerPoint.y, radius, DEGREES_2_RADIANS(270), radians, NO);
    //    CGPathCloseSubpath(progressPath);
    //    CGContextAddPath(bitmapContext, progressPath);
    //    CGContextFillPath(bitmapContext);
    //    CGPathRelease(progressPath);
    //
    
    CGImageRef processImageRef = CGBitmapContextCreateImage(bitmapContext);
    UIImage *processImage = [UIImage imageWithCGImage:processImageRef];
    
    return processImage;
}

+(NSString *)formatDate:(NSDate *)tempDate formatter:(NSString *)formatter{
    
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-DD"];
    if (formatter) {
        [dateformatter setDateFormat:formatter];
    }
    
    NSString *strTime = [dateformatter stringFromDate:tempDate];
    
    return strTime;
}

+(NSString *)formatTime:(long)timeTnterval formatter:(NSString *)formatter{
    
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-DD"];
    if (formatter) {
        [dateformatter setDateFormat:formatter];
    }
    
    NSDate *tempDate = [NSDate dateWithTimeIntervalSince1970:timeTnterval];
    NSString *strTime = [dateformatter stringFromDate:tempDate];
    
    return strTime;
}

+(double)rad:(double)d{
    
    return d * (M_PI / 180.0);
}


+(double)getDistanceByLatitude1:(double)lat1 longitude1:(double)lng1 latitude2:(double)lat2 longitude2:(double)lng2{
    
    double distance = 0;
    
    if (fabs(lat1 - lat2) < 0.00001 || fabs(lng1 - lng2) < 0.00001) {
        return distance;
    }
    
    double radLat1 = [PCommonUtil rad:lat1];
    double radLat2 = [PCommonUtil rad:lat2];
    double a = radLat1 = radLat2;
    double b = [PCommonUtil rad:lng1] - [PCommonUtil rad:lng2];
    distance = 2 * asin(sqrt(pow(sin(a/2), 2) + cos(radLat1) * cos(radLat2) * pow(sin(b/2), 2)));
    distance = distance * EARTH_RADIUS;
    distance = round(distance * 10000) / 10000;
    distance = distance / 1000;         //km -> m
    
    return distance;
}


+(double)calcDistance:(double)lat1 longitude1:(double)lng1 latitude2:(double)lat2 longitude2:(double)lng2{
    
    double runDistance = 0;
    
//    NSLog(@"%0.02f",round(3.321*100)/100);//result 3.21
    
//    lat1 = round(lat1 * 100000) / 100000;
//    lng1 = round(lng1 * 100000) / 100000;
//    lat2 = round(lat2 * 100000) / 100000;
//    lng2 = round(lng2 * 100000) / 100000;
    
    lat1 = round(lat1 * 100000) / 100000;
    lng1 = round(lng1 * 100000) / 100000;
    lat2 = round(lat2 * 100000) / 100000;
    lng2 = round(lng2 * 100000) / 100000;
    
    NSLog(@"-----------calc start----------");
    NSLog(@"%.6f", lat1);
    NSLog(@"%.6f", lng1);
    NSLog(@"%.6f", lat2);
    NSLog(@"%.6f", lng2);
    NSLog(@"-----------calc start----------");
    
    if (fabs(lat1 - lat2) < 0.00001 || fabs(lng1 - lng2) < 0.00001) {
        return runDistance;
    }
    
    double dd = M_PI/180;
    double x1 = lat1 * dd;
    double y1 = lng1 * dd;
    
    double x2 = lat2 * dd;
    double y2 = lng2 * dd;
    
    double R = 6371004;
    
    
    runDistance = (2*R*asin(sqrt(2-2*cos(x1)*cos(x2)*cos(y1-y2) - 2*sin(x1)*sin(x2))/2));
    runDistance = (runDistance < 0) ? (-runDistance) : runDistance;
    
    return runDistance;
}


/*
static double DEF_PI = 3.14159265359; // PI
static double DEF_2PI= 6.28318530712; // 2*PI
static double DEF_PI180= 0.01745329252; // PI/180.0
static double DEF_R =6370693.5; // radius of earth
+(double)calcDistance:(double)lat1 longitude1:(double)lon1 latitude2:(double)lat2 longitude2:(double)lon2{
    double ew1, ns1, ew2, ns2;
    double dx, dy, dew;
    double distance;
    // 角度转换为弧度
    ew1 = lon1 * DEF_PI180;
    ns1 = lat1 * DEF_PI180;
    ew2 = lon2 * DEF_PI180;
    ns2 = lat2 * DEF_PI180;
    // 经度差
    dew = ew1 - ew2;
    // 若跨东经和西经180 度，进行调整
    if (dew > DEF_PI)
        dew = DEF_2PI - dew;
    else if (dew < -DEF_PI)
        dew = DEF_2PI + dew;
    dx = DEF_R * cos(ns1) * dew; // 东西方向长度(在纬度圈上的投影长度)
    dy = DEF_R * (ns1 - ns2); // 南北方向长度(在经度圈上的投影长度)
    // 勾股定理求斜边长
    distance = sqrt(dx * dx + dy * dy);
    return distance;
}
*/

/*手机号码验证 MODIFIED BY HELENSONG*/
+(BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
}

/*身份证号码验证 MODIFIED BY HELENSONG*/
+(BOOL) isValidateIdentityCard:(NSString *)IdCard
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *IdCardRegex = @"(^\\d{15}$)|(^\\d{17}([0-9]|X|x)$)";
    NSPredicate *IdCardTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",IdCardRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [IdCardTest evaluateWithObject:IdCard];
}

+(NSString *)getSystemVersion
{
    return [[UIDevice currentDevice] systemVersion];
}

+(id)checkDataIsNull:(id)data{
    
    if (data == nil || [NSNull null] == data || [data isEqual:@"null"]) {
        return nil;
    }
    
    return data;
}

+(int)getWeekFromTime:(NSString *)strTime{
    
    int weekday = 0;
    
    if (strTime && strTime.length > 10) {
        
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *tempDate = [strTime substringToIndex:10];
        NSLog(@"tempDate: %@", tempDate);
        NSDate *tempdate = [formatter dateFromString:tempDate];
        NSDateComponents *comps = [calendar components:unitFlags fromDate:tempdate];
        weekday = comps.weekday;//从周日开始计算
    }
    
    NSLog(@"weekday: %d", weekday);
    
    return weekday;
}

#pragma mark 获取头像完整URL
+(NSString*)getHeadImgUrl:(NSString*)headImg
{
    return [NSString stringWithFormat:@"%@%@%@", VANKE_DOMAINBase, @"/upload/head/", headImg];
}

#pragma mark 判断是否IPhone5
+ (BOOL)isIPhone5
{
    if(iPhone5){
        //***具体操作
        return YES;
    }else{
        //***具体操作
        return NO;
    }
}

@end
