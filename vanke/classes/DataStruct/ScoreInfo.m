//
//  ScoreInfo.m
//  vanke
//
//  Created by pig on 13-7-2.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "ScoreInfo.h"

@implementation ScoreInfo

@synthesize scoreID = _scoreID;
@synthesize memberID = _memberID;
@synthesize mileage = _mileage;
@synthesize score = _score;
@synthesize scoreTime = _scoreTime;

+(ScoreInfo *)initWithNSDictionary:(NSDictionary *)dict{
    
    ScoreInfo *scoreinfo = nil;
    
    @try {
        if (dict && [dict isKindOfClass:[NSDictionary class]]) {
            
            scoreinfo = [[ScoreInfo alloc] init];
            scoreinfo.scoreID = [[dict objectForKey:@"scoreID"] longValue];
            scoreinfo.memberID = [[dict objectForKey:@"memberID"] longLongValue];
            scoreinfo.mileage = [[dict objectForKey:@"mileage"] floatValue];
            scoreinfo.score = [[dict objectForKey:@"score"] intValue];
            scoreinfo.scoreTime = [dict objectForKey:@"scoreTime"];
            
        }
    }
    @catch (NSException *exception) {
        NSLog(@"parser ScoreInfo failed...please check");
    }
    
    return scoreinfo;
}

@end
