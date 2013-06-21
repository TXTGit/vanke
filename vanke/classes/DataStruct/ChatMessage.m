//
//  ChatMessage.m
//  vanke
//
//  Created by pig on 13-6-13.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "ChatMessage.h"

@implementation ChatMessage

@synthesize msgID = _msgID;
@synthesize fromMemberID = _fromMemberID;
@synthesize toMemberID = _toMemberID;
@synthesize msgText = _msgText;
@synthesize isReceive = _isReceive;
@synthesize sendTime = _sendTime;
@synthesize receiveTime = _receiveTime;
@synthesize inviteID = _inviteID;

+(ChatMessage *)initWithNSDictionary:(NSDictionary *)dict{
    
    ChatMessage *chatmessage = nil;
    
    @try {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            chatmessage = [[ChatMessage alloc] init];
            chatmessage.msgID = [[dict objectForKey:@"msgID"] longValue];
            chatmessage.fromMemberID = [[dict objectForKey:@"fromMemberID"] longValue];
            chatmessage.toMemberID = [[dict objectForKey:@"toMemberID"] longValue];
            chatmessage.msgText = [dict objectForKey:@"msgText"];
            chatmessage.isReceive = [[dict objectForKey:@"isReceive"] intValue];
            chatmessage.sendTime = [dict objectForKey:@"sendTime"];
            chatmessage.receiveTime = [dict objectForKey:@"receiveTime"];
            chatmessage.inviteID = [dict objectForKey:@"inviteID"];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"parser ChatMessage failed...please check");
    }
    
    return chatmessage;
}

@end
