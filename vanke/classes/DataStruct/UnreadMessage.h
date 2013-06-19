//
//  UnreadMessage.h
//  vanke
//
//  Created by apple on 13-6-17.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UnreadMessage : NSObject

@property (nonatomic, assign) long unreadID;
@property (nonatomic, assign) long memberID;
@property (nonatomic, assign) long fromMemberID;
@property (nonatomic, retain) NSString *lastMsgText;
@property (nonatomic, assign) int msgCount;
@property (nonatomic, retain) NSString *sendTime;
@property (nonatomic, retain) NSString *fromNickName;
@property (nonatomic, retain) NSString *fromHeadImg;
@property (nonatomic, retain) NSString *fromLoginTime;

//未读消息
+(UnreadMessage *)initWithNSDictionary:(NSDictionary *)dict;

@end
