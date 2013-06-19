//
//  RunInfoOfWeek.h
//  vanke
//
//  Created by pig on 13-6-18.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RunInfoOfWeek : NSObject

@property (nonatomic, assign) long totalID;
@property (nonatomic, assign) long memberID;
@property (nonatomic, assign) float mileage;
@property (nonatomic, assign) long minute;
@property (nonatomic, assign) float speed;
@property (nonatomic, assign) float calorie;
@property (nonatomic, assign) float energy;
@property (nonatomic, assign) int runTimes;
@property (nonatomic, retain) NSString *beginTime;
@property (nonatomic, retain) NSString *endTime;

+(RunInfoOfWeek *)initWithNSDictionary:(NSDictionary *)dict;

@end
