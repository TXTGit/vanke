//
//  NearFriend.m
//  vanke
//
//  Created by pig on 13-6-13.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "NearFriend.h"
#import "PCommonUtil.h"

@implementation NearFriend

@synthesize memberID = _memberID;
@synthesize nickName = _nickName;
@synthesize fullName = _fullName;
@synthesize headImg = _headImg;
@synthesize isFan = _isFan;
@synthesize gps = _gps;
@synthesize loginTime = _loginTime;
@synthesize distance = _distance;

+(NearFriend *)initWithNSDictionary:(NSDictionary *)dict{
    
    NearFriend *nearfriend = nil;
    
    @try {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            nearfriend = [[NearFriend alloc] init];
            nearfriend.memberID = [[dict objectForKey:@"memberID"] longValue];
            nearfriend.nickName = [dict objectForKey:@"nickName"];
            nearfriend.fullName = [dict objectForKey:@"fullName"];
            nearfriend.headImg = [dict objectForKey:@"headImg"];
            nearfriend.isFan = [[dict objectForKey:@"isFan"] boolValue];
            nearfriend.gps = [dict objectForKey:@"gps"];
            nearfriend.loginTime = [dict objectForKey:@"loginTime"];
            
            id tempdistance = [PCommonUtil checkDataIsNull:[dict objectForKey:@"distance"]];
            nearfriend.distance = (tempdistance != nil) ? [tempdistance longValue] : 0;
            
        }
    }
    @catch (NSException *exception) {
        NSLog(@"parser NearFriend failed...please check");
    }
    
    return nearfriend;
}

@end
