//
//  UserSessionManager.h
//  vanke
//
//  Created by pig on 13-6-11.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RunUser.h"

@interface UserSessionManager : NSObject

@property (nonatomic, retain) RunUser *currentRunUser;
@property (nonatomic, assign) BOOL isLoggedIn;

+(UserSessionManager *)GetInstance;

@end
