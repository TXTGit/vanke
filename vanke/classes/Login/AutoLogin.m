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
            
            [self doGetMemberInfo:[tempmemberid longLongValue]];
            
            if (_delegate && [_delegate respondsToSelector:@selector(autoLoginSuccess)]) {
                [_delegate autoLoginSuccess];
            }
            
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"failure: %@", error);
        
        if (_delegate && [_delegate respondsToSelector:@selector(autoLoginFailed)]) {
            [_delegate autoLoginFailed];
        }
        
    }];
    [operation start];
    
}

-(void)doGetMemberInfo:(long)memberid{
    
    NSString *memberUrl = [VankeAPI getGetMemberUrl:[NSString stringWithFormat:@"%ld", memberid]];
    NSLog(@"memberUrl:%@",memberUrl);
    NSURL *url = [NSURL URLWithString:memberUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"App.net Global Stream: %@", JSON);
        NSDictionary *dicResult = JSON;
        NSString *status = [dicResult objectForKey:@"status"];
        NSLog(@"status: %@", status);
        if ([status isEqual:@"0"]) {
            
            NSDictionary *dicEnt = [dicResult objectForKey:@"ent"];
            RunUser *runner = [RunUser initWithNSDictionary:dicEnt];
            [UserSessionManager GetInstance].currentRunUser = runner;
            
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"failure: %@", error);
    }];
    [operation start];
    
}

@end
