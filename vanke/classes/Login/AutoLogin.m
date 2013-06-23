//
//  AutoLogin.m
//  vanke
//
//  Created by pig on 13-6-10.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "AutoLogin.h"
#import "VankeAPI.h"
#import "AFJSONRequestOperation.h"
#import "UserSessionManager.h"
#import "VankeConfig.h"

@implementation AutoLogin

@synthesize delegate = _delegate;
@synthesize username = _username;
@synthesize password = _password;

-(void)doAutoLogin{
    
    NSLog(@"doAutoLogin...");
    
    if (!_username || !_password) {
        return;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(autoLoginStart)]) {
        [_delegate autoLoginStart];
    }
    
    NSString *loginUrl = [VankeAPI getLoginUrl:_username password:_password];
    NSURL *url = [NSURL URLWithString:loginUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"App.net Global Stream: %@", JSON);
        NSDictionary *dicResult = JSON;
        NSString *status = [dicResult objectForKey:@"status"];
        NSLog(@"status: %@", status);
        if ([status isEqual:@"0"]) {
            NSLog(@"dicResult:%@",dicResult);
            NSString *tempmemberid = [dicResult objectForKey:@"memberID"];
            [UserSessionManager GetInstance].currentRunUser.userid = tempmemberid;
            [UserSessionManager GetInstance].currentRunUser.communityid = [[dicResult objectForKey:@"communityID"] intValue];
            
//            [self doGetMemberInfo:tempmemberid];
            
            if (_delegate && [_delegate respondsToSelector:@selector(autoLoginSuccess)]) {
                [_delegate autoLoginSuccess];
            }
            
        } else {
            NSString *msg = [dicResult objectForKey:@"msg"];
            if (_delegate && [_delegate respondsToSelector:@selector(autoLoginFailed:)]) {
                [_delegate autoLoginFailed:msg];
            }
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"failure: %@", error);
        
        if (_delegate && [_delegate respondsToSelector:@selector(autoLoginFailed:)]) {
            [_delegate autoLoginFailed:@"网络异常,请重试"];
        }
        
    }];
    [operation start];
    
}

//同步事件
-(void)doGetMemberInfo:(NSString *)memberid{
    
    //搞个事件来同步下
    NSCondition *itlock = [[NSCondition alloc] init];
    
    NSString *memberUrl = [VankeAPI getGetMemberUrl:memberid];
    NSLog(@"memberUrl:%@",memberUrl);
    NSURL *url = [NSURL URLWithString:memberUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"App.net Global Stream: %@", JSON);
        NSDictionary *dicResult = JSON;
        NSString *status = [dicResult objectForKey:@"status"];
        NSLog(@"status: %@", status);
        if ([status isEqual:@"0"]) {
            
            NSString *imgpath = [dicResult objectForKey:@"imgPath"];
            NSDictionary *dicEnt = [dicResult objectForKey:@"ent"];
            RunUser *runner = [RunUser initWithNSDictionary:dicEnt];
            runner.headImg = [NSString stringWithFormat:@"%@%@%@", VANKE_DOMAINBase, imgpath, runner.headImg];
            [UserSessionManager GetInstance].currentRunUser = runner;
            NSLog(@"headImg: %@", runner.headImg);
            
        }
        
        [itlock lock];
        [itlock signal];//设置事件,下面那个等待就可以收到事件返回了
        [itlock unlock];
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"failure: %@", error);
        
        [itlock lock];
        [itlock signal];//失败也要设置事件,不然下面一直死等了
        [itlock unlock];
        
    }];
    [operation start];
    
    //启动AFNETWORKING之后就等待事件
    [itlock lock];
    [itlock wait];
    [itlock unlock];
    
}

@end
