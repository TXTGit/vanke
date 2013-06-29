//
//  ChatMessage.m
//  vanke
//
//  Created by pig on 13-6-13.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "ChatMessage.h"
#import "PCommonUtil.h"

@implementation ChatMessage

@synthesize msgID = _msgID;
@synthesize fromMemberID = _fromMemberID;
@synthesize memberID = _memberID;
@synthesize msgText = _msgText;
@synthesize isReceive = _isReceive;
@synthesize sendTime = _sendTime;
@synthesize receiveTime = _receiveTime;
@synthesize inviteID = _inviteID;
@synthesize isRead = _isRead;
@synthesize readTime = _readTime;

+(ChatMessage *)initWithNSDictionary:(NSDictionary *)dict{
    
    ChatMessage *chatmessage = nil;
    
    @try {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            chatmessage = [[ChatMessage alloc] init];
            chatmessage.msgID = [[dict objectForKey:@"msgID"] longValue];
            chatmessage.fromMemberID = [[dict objectForKey:@"fromMemberID"] longValue];
            chatmessage.memberID = [[dict objectForKey:@"memberID"] longValue];
            chatmessage.msgText = [PCommonUtil checkDataIsNull:[dict objectForKey:@"msgText"]];
            chatmessage.isReceive = [[dict objectForKey:@"isReceive"] intValue];
            chatmessage.sendTime = [dict objectForKey:@"sendTime"];
            chatmessage.receiveTime = [dict objectForKey:@"receiveTime"];
            chatmessage.inviteID = [dict objectForKey:@"inviteID"];
            chatmessage.isRead = [[dict objectForKey:@"isRead"] intValue];
            chatmessage.readTime = [PCommonUtil checkDataIsNull:[dict objectForKey:@"readTime"]];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"parser ChatMessage failed...please check");
    }
    
    return chatmessage;
}

@end
