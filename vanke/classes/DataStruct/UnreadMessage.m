//
//  UnreadMessage.m
//  vanke
//
//  Created by apple on 13-6-17.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "UnreadMessage.h"

@implementation UnreadMessage

@synthesize unreadID = _unreadID;
@synthesize memberID = _memberID;
@synthesize fromMemberID = _fromMemberID;
@synthesize lastMsgText = _lastMsgText;
@synthesize msgCount = _msgCount;
@synthesize sendTime = _sendTime;
@synthesize fromNickName = _fromNickName;
@synthesize fromHeadImg = _fromHeadImg;
@synthesize fromLoginTime = _fromLoginTime;

+(UnreadMessage *)initWithNSDictionary:(NSDictionary *)dict{
    
    UnreadMessage *unreadMessage = nil;
    
    @try {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            unreadMessage = [[UnreadMessage alloc] init];
            unreadMessage.unreadID = [[dict objectForKey:@"unreadID"] longValue];
            unreadMessage.memberID = [[dict objectForKey:@"memberID"] longValue];
            unreadMessage.fromMemberID = [[dict objectForKey:@"fromMemberID"] longValue];
            unreadMessage.lastMsgText = [dict objectForKey:@"lastMsgText"];
            unreadMessage.msgCount = [[dict objectForKey:@"msgCount"] intValue];
            unreadMessage.sendTime = [dict objectForKey:@"sendTime"];
            unreadMessage.fromNickName = [dict objectForKey:@"fromNickName"];
            unreadMessage.fromHeadImg = [dict objectForKey:@"fromHeadImg"];
            unreadMessage.fromLoginTime = [dict objectForKey:@"fromLoginTime"];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"parser UnreadMessage failed...please check");
    }
    
    return unreadMessage;
}

@end
