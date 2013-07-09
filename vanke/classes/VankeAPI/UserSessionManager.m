//
//  UserSessionManager.m
//  vanke
//
//  Created by pig on 13-6-11.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "UserSessionManager.h"

@implementation UserSessionManager

@synthesize currentRunUser = _currentRunUser;
@synthesize isLoggedIn = _isLoggedIn;

+(UserSessionManager *)GetInstance{
    
    static UserSessionManager *instance = nil;
    @synchronized(self){
        if (nil == instance) {
            instance = [[self alloc] init];
            instance.currentRunUser = [[RunUser alloc] init];
        }
    }
    return instance;
}

+(void)CleanInstance{
    [self GetInstance].currentRunUser = [[RunUser alloc] init];;
}

@end
