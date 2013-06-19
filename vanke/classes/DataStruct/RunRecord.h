//
//  RunRecord.h
//  vanke
//
//  Created by pig on 13-6-11.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RunRecord : NSObject


@property (nonatomic, retain) NSString *oldLatitude;
@property (nonatomic, retain) NSString *oldLongitude;
@property (nonatomic, retain) NSString *nowLatitude;
@property (nonatomic, retain) NSString *nowLongitude;

@property (nonatomic, assign) long dataCreateTime;          //跑步时间戳
@property (nonatomic, assign) long runingOneTimeId;         //本地记录的当次跑步runid

@property (nonatomic, assign) float calorie;
@property (nonatomic, assign) float energy;
@property (nonatomic, retain) NSMutableArray *locationList;
@property (nonatomic, assign) long memberID;
@property (nonatomic, assign) float mileage;
@property (nonatomic, assign) long minute;
@property (nonatomic, assign) long runId;
@property (nonatomic, retain) NSString *runTime;
@property (nonatomic, assign) float speed;

@property (nonatomic, assign) double secondOfRunning;       //跑步秒数，用于计算速度

+(RunRecord *)initWithNSDictionary:(NSDictionary *)dict;

@end
