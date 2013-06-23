//
//  AutoLogin.h
//  vanke
//
//  Created by pig on 13-6-10.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AutoLoginDelegate <NSObject>

-(void)autoLoginStart;
-(void)autoLoginSuccess;
-(void)autoLoginFailed:(NSString *)msg;

@end

@interface AutoLogin : NSObject

@property (assign) id<AutoLoginDelegate> delegate;
@property (retain) NSString *username;
@property (retain) NSString *password;

-(void)doAutoLogin;

@end
