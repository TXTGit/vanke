//
//  FriendInfo.m
//  vanke
//
//  Created by pig on 13-6-12.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "FriendInfo.h"

@implementation FriendInfo

@synthesize relID = _relID;
@synthesize fromMemberID = _fromMemberID;
@synthesize toMemberID = _toMemberID;
@synthesize fanTime = _fanTime;
@synthesize fromNickName = _fromNickName;
@synthesize fromLoginTime = _fromLoginTime;
@synthesize toNickName = _toNickName;
@synthesize toLoginTime = _toLoginTime;

+(FriendInfo *)initWithNSDictionary:(NSDictionary *)dict{
    
    FriendInfo *friendInfo = nil;
    
    @try {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            friendInfo = [[FriendInfo alloc] init];
            friendInfo.relID = [[dict objectForKey:@"relID"] longValue];
            friendInfo.fromMemberID = [[dict objectForKey:@"fromMemberID"] longValue];
            friendInfo.toMemberID = [[dict objectForKey:@"toMemberID"] longValue];
            friendInfo.fanTime = [dict objectForKey:@"fanTime"];
            friendInfo.fromNickName = [dict objectForKey:@"fromNickName"];
            friendInfo.fromLoginTime = [dict objectForKey:@"fromLoginTime"];
            friendInfo.toNickName = [dict objectForKey:@"toNickName"];
            friendInfo.toLoginTime = [dict objectForKey:@"toLoginTime"];
            
        }
    }
    @catch (NSException *exception) {
        NSLog(@"parser FriendInfo failed...please check");
    }
    
    return friendInfo;
}

@end
