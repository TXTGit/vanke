//
//  ChatMessage.h
//  vanke
//
//  Created by pig on 13-6-13.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatMessage : NSObject

@property (nonatomic, assign) long msgID;
@property (nonatomic, assign) long fromMemberID;
@property (nonatomic, assign) long memberID;
@property (nonatomic, retain) NSString *msgText;
@property (nonatomic, assign) int isReceive;
@property (nonatomic, retain) NSString *sendTime;
@property (nonatomic, retain) NSString *receiveTime;
@property (nonatomic, retain) NSString *inviteID;
@property (nonatomic, assign) int isRead;
@property (nonatomic, retain) NSString *readTime;

+(ChatMessage *)initWithNSDictionary:(NSDictionary *)dict;

@end
