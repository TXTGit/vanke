//
//  RunRecord.m
//  vanke
//
//  Created by pig on 13-6-11.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "RunRecord.h"

@implementation RunRecord

@synthesize oldLatitude = _oldLatitude;
@synthesize oldLongitude = _oldLongitude;
@synthesize nowLatitude = _nowLatitude;
@synthesize nowLongitude = _nowLongitude;
@synthesize dataCreateTime = _dataCreateTime;
@synthesize runingOneTimeId = _runingOneTimeId;


@synthesize calorie = _calorie;
@synthesize energy = _energy;
@synthesize locationList = _locationList;
@synthesize memberID = _memberID;
@synthesize mileage = _mileage;
@synthesize minute = _minute;
@synthesize runId = _runId;
@synthesize runTime = _runTime;
@synthesize speed = _speed;

@synthesize secondOfRunning = _secondOfRunning;

+(RunRecord *)initWithNSDictionary:(NSDictionary *)dict{
    
    RunRecord *record = nil;
    
    @try {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            
            record = [[RunRecord alloc] init];
            record.runingOneTimeId = [[dict objectForKey:@"runID"] longValue];
            record.mileage = [[dict objectForKey:@"mileage"] floatValue];
            record.minute = [[dict objectForKey:@"minute"] floatValue];
            record.speed = [[dict objectForKey:@"speed"] floatValue];
            record.calorie = [[dict objectForKey:@"calorie"] floatValue];
            record.energy = [[dict objectForKey:@"energy"] floatValue];
            
            NSMutableArray *locationList = [[NSMutableArray alloc] init];
            NSString *line = [dict objectForKey:@"line"];
            NSArray *locations = [line componentsSeparatedByString:@";"];
            int locationCount = [locations count];
            for (int i=0; i<locationCount; i++) {
                NSString *templocation = [locations objectAtIndex:i];
                if (templocation && templocation.length > 10) {
                    [locationList addObject:templocation];
                }
            
            }
            record.locationList = locationList;
            record.runTime = [dict objectForKey:@"runTime"];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"YYYY-MM-DD"];
            NSDate *rundate = [formatter dateFromString:record.runTime];
            record.dataCreateTime = [rundate timeIntervalSince1970];
            
        }
    }
    @catch (NSException *exception) {
        NSLog(@"parser RunRecord failed...please check");
    }
    
    return record;
}

@end
