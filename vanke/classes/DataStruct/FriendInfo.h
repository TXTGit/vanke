//
//  FriendInfo.h
//  vanke
//
//  Created by pig on 13-6-12.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendInfo : NSObject

@property (nonatomic, assign) long relID;
@property (nonatomic, assign) long fromMemberID;
@property (nonatomic, assign) long toMemberID;
@property (nonatomic, retain) NSString *fanTime;
@property (nonatomic, retain) NSString *fromNickName;
@property (nonatomic, retain) NSString *fromLoginTime;
@property (nonatomic, retain) NSString *toNickName;
@property (nonatomic, retain) NSString *toLoginTime;
@property (nonatomic, retain) NSString *fromHeadImg;

+(FriendInfo *)initWithNSDictionary:(NSDictionary *)dict;

@end
