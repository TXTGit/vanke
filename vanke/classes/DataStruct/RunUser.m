//
//  RunUser.m
//  vanke
//
//  Created by pig on 13-6-11.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "RunUser.h"
#import "PCommonUtil.h"

@implementation RunUser

@synthesize userid = _userid;
@synthesize tall = _tall;
@synthesize weight = _weight;
@synthesize area = _area;
@synthesize address = _address;
@synthesize tel = _tel;

@synthesize nickname = _nickname;
@synthesize password = _password;
@synthesize fullname = _fullname;
@synthesize idcard = _idcard;
@synthesize communityid = _communityid;
@synthesize score = _score;
@synthesize birthday = _birthday;
@synthesize headImg = _headImg;

@synthesize mobile = _mobile;

+(RunUser *)initWithNSDictionary:(NSDictionary *)dict{
    
    RunUser *runner = nil;
    
    @try {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            
            runner = [[RunUser alloc] init];
            runner.userid = [dict objectForKey:@"memberID"];
            runner.nickname = [dict objectForKey:@"nickName"];
            runner.password = [dict objectForKey:@"password"];
            runner.fullname = [dict objectForKey:@"fullName"];
            runner.idcard = [dict objectForKey:@"idCard"];
            runner.tel = [dict objectForKey:@"mobile"];
            runner.communityid = [[dict objectForKey:@"communityID"] intValue];
            runner.headImg = [dict objectForKey:@"headImg"];
            runner.address = [dict objectForKey:@"address"];
            runner.birthday = [dict objectForKey:@"birthday"];
            if ([PCommonUtil checkDataIsNull:[dict objectForKey:@"weight"]]) {
                runner.weight = [[dict objectForKey:@"weight"] floatValue];
            }
            if ([PCommonUtil checkDataIsNull:[dict objectForKey:@"height"]]) {
                runner.tall = [[dict objectForKey:@"height"] floatValue];
            }
            if ([PCommonUtil checkDataIsNull:[dict objectForKey:@"score"]]) {
                runner.score = [[dict objectForKey:@"score"] longValue];
            }
            runner.mobile = [dict objectForKey:@"mobile"];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"parser RunUser failed...pease check");
    }
    
    return runner;
}

@end
