//
//  RankInfo.h
//  vanke
//
//  Created by apple on 13-6-17.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RankInfo : NSObject

@property (nonatomic, assign) long totalID;
@property (nonatomic, assign) long memberID;
@property (nonatomic, assign) float mileage;
@property (nonatomic, assign) float minute;
@property (nonatomic, assign) float speed;
@property (nonatomic, assign) float calorie;
@property (nonatomic, assign) float energy;
@property (nonatomic, assign) int runTimes;
@property (nonatomic, retain) NSString *beginTime;
@property (nonatomic, retain) NSString *endTime;
@property (nonatomic, assign) float rank;

//排名信息
+(RankInfo *)initWithNSDictionary:(NSDictionary *)dict;

@end
