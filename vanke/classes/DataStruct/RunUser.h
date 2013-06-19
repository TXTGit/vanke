//
//  RunUser.h
//  vanke
//
//  Created by pig on 13-6-11.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RunUser : NSObject

@property (nonatomic, retain) NSString *userid;                     //用户标志id
@property (nonatomic, assign) float tall;                           //身高
@property (nonatomic, assign) float weight;                         //体重
@property (nonatomic, retain) NSString *area;                       //社区
@property (nonatomic, retain) NSString *address;                    //地址
@property (nonatomic, retain) NSString *tel;                        //电话

@property (nonatomic, retain) NSString *nickname;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *fullname;
@property (nonatomic, retain) NSString *idcard;
@property (nonatomic, assign) int communityid;                      //当前绑定社区id
@property (nonatomic, assign) long score;
@property (nonatomic, retain) NSString *birthday;
@property (nonatomic, retain) NSString *headImg;

+(RunUser *)initWithNSDictionary:(NSDictionary *)dict;

@end
