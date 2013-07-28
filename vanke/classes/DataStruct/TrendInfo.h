//
//  TrendInfo.h
//  vanke
//
//  Created by user on 13-6-20.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrendInfo : NSObject

@property (nonatomic, assign) long shareID;
@property (nonatomic, assign) long memberID;
@property (nonatomic, retain) NSString *shareContent;
@property (nonatomic, retain) NSString *shareImg;
@property (nonatomic, retain) NSString *shareTime;
@property (nonatomic, retain) NSString *nickName;
@property (nonatomic, retain) NSString *headImg;
@property (nonatomic, retain) NSString *loginTime;
@property (nonatomic, assign) int isFan;
@property (nonatomic, assign) float minute;
@property (nonatomic, assign) float calorie;
@property (nonatomic, assign) float mileage;

//排名信息
+(TrendInfo *)initWithNSDictionary:(NSDictionary *)dict;

@end
