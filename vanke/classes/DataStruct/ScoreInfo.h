//
//  ScoreInfo.h
//  vanke
//
//  Created by pig on 13-7-2.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScoreInfo : NSObject

@property (nonatomic, assign) long scoreID;
@property (nonatomic, assign) long long memberID;
@property (nonatomic, assign) float mileage;
@property (nonatomic, assign) int score;
@property (nonatomic, retain) NSString *scoreTime;

+(ScoreInfo *)initWithNSDictionary:(NSDictionary *)dict;

@end
