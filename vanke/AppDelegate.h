//
//  AppDelegate.h
//  vanke
//
//  Created by pig on 13-6-9.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import "WXApi.h"
#import "AFJSONRequestOperation.h"

@class SinaWeibo;

@interface AppDelegate : UIResponder <UIApplicationDelegate, BMKGeneralDelegate, WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (retain, nonatomic) UINavigationController *navController;

@property (nonatomic, retain) BMKMapManager* mapManager;

@property (nonatomic, retain) SinaWeibo *sinaweibo;

@property (nonatomic, retain) NSTimer *getUnreadTimer;

-(void)timerStart;
-(void)timerStop;
-(void)getUnreadList;

@end
