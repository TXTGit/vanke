//
//  RunInfoOfWeek.m
//  vanke
//
//  Created by pig on 13-6-18.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "RunInfoOfWeek.h"

@implementation RunInfoOfWeek

@synthesize totalID = _totalID;
@synthesize memberID = _memberID;
@synthesize mileage = _mileage;
@synthesize minute = _minute;
@synthesize speed = _speed;
@synthesize calorie = _calorie;
@synthesize energy = _energy;
@synthesize runTimes = _runTimes;
@synthesize beginTime = _beginTime;
@synthesize endTime = _endTime;

+(RunInfoOfWeek *)initWithNSDictionary:(NSDictionary *)dict{
    
    RunInfoOfWeek *runInfoOfWeek = nil;
    
    @try {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            runInfoOfWeek = [[RunInfoOfWeek alloc] init];
            runInfoOfWeek.totalID = [[dict objectForKey:@"totalID"] longValue];
            runInfoOfWeek.memberID = [[dict objectForKey:@"memberID"] longValue];
            runInfoOfWeek.mileage = [[dict objectForKey:@"mileage"] floatValue];
            runInfoOfWeek.minute = [[dict objectForKey:@"minute"] floatValue];
            runInfoOfWeek.speed = [[dict objectForKey:@"speed"] floatValue];
            runInfoOfWeek.calorie = [[dict objectForKey:@"calorie"] floatValue];
            runInfoOfWeek.energy = [[dict objectForKey:@"energy"] floatValue];
            runInfoOfWeek.runTimes = [[dict objectForKey:@"runTimes"] intValue];
            runInfoOfWeek.beginTime = [dict objectForKey:@"beginTime"];
            runInfoOfWeek.endTime = [dict objectForKey:@"endTime"];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"parser RunInfoOfWeek failed...please check");
    }
    
    return runInfoOfWeek;
}

@end
