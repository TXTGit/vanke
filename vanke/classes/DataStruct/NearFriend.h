//
//  NearFriend.h
//  vanke
//
//  Created by pig on 13-6-13.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NearFriend : NSObject

@property (nonatomic, assign) long memberID;
@property (nonatomic, retain) NSString *nickName;
@property (nonatomic, retain) NSString *fullName;
@property (nonatomic, retain) NSString *headImg;
@property (nonatomic, assign) BOOL isFan;
@property (nonatomic, retain) NSString *gps;
@property (nonatomic, retain) NSString *loginTime;
@property (nonatomic, assign) long distance;

+(NearFriend *)initWithNSDictionary:(NSDictionary *)dict;

@end
