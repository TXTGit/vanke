//
//  AppDelegate.m
//  vanke
//
//  Created by pig on 13-6-9.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import "UncaughtExceptionHandler.h"

#import "GuideViewController.h"
#import "LoginViewController.h"
#import "IndexViewController.h"
#import "RunUser.h"
#import "UserSessionManager.h"

#import "GTMBase64.h"
#import "AFJSONRequestOperation.h"
#import "AFHTTPClient.h"
#import "VankeAPI.h"

#import "SinaWeibo.h"

#import "PCommonUtil.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize navController = _navController;

@synthesize mapManager = _mapManager;

@synthesize sinaweibo = _sinaweibo;
@synthesize getUnreadTimer = _getUnreadTimer;

//for crash
-(void)installUncaughtExceptionHandler
{
    InstallUncaughtExceptionHandler();
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self installUncaughtExceptionHandler];//
    
    // 要使用百度地图，请先启动BaiduMapManager
	_mapManager = [[BMKMapManager alloc]init];
	BOOL ret = [_mapManager start:@"1764C71C5E5FA438E1E27811032D2E160A93C1B2" generalDelegate:self];
	if (!ret) {
		NSLog(@"manager start failed!");
	}
    
    //向微信注册
    [WXApi registerApp:@"wxc7007d32a0ef5d89"];
    
    //这种方式后台，可以连续播放非网络请求歌曲。遇到网络请求歌曲就废，需要后台申请task
    /*
     * AudioSessionInitialize用于处理中断处理，
     * AVAudioSession主要调用setCategory和setActive方法来进行设置，
     * AVAudioSessionCategoryPlayback一般用于支持后台播放
     */
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *setCategoryError = nil;
    [session setCategory:AVAudioSessionCategoryPlayback error:&setCategoryError];
    NSError *activationError = nil;
    [session setActive:YES error:&activationError];
    
    //首次打开APP 创建缓存文件夹
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"firstLaunch"]==nil) {
        [[NSFileManager defaultManager] createDirectoryAtPath:pathInCacheDirectory(@"com.vanke") withIntermediateDirectories:YES attributes:nil error:nil];
        [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithBool:YES] forKey:@"firstLaunch"];
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    //增加标识，用于判断是否是第一次启动应用...
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"FirstLaunch"]) {
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FirstLaunch"];
        
        GuideViewController *guideViewController = [[GuideViewController alloc] initWithNibName:@"GuideViewController" bundle:nil];
        self.navController = [[UINavigationController alloc] initWithRootViewController:guideViewController];
        
    }else {
        
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"AutoLogin"]) {
            
            RunUser *runner = [[RunUser alloc] init];
            runner.weight = 60.0f;
            [UserSessionManager GetInstance].currentRunUser = runner;
            [UserSessionManager GetInstance].isLoggedIn = NO;
            
        }
        
        if ([UserSessionManager GetInstance].isLoggedIn) {
            
            IndexViewController *indexViewController = [[IndexViewController alloc] initWithNibName:@"IndexViewController" bundle:nil];
            self.navController = [[UINavigationController alloc] initWithRootViewController:indexViewController];
            
        } else {
            
            LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
            self.navController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
            
        }
        
    }
    
    [self.navController.navigationBar setHidden:YES];
    self.window.rootViewController = self.navController;
    [self.window addSubview:self.navController.view];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    NSLog(@"applicationDidEnterBackground...");
    
    [application beginReceivingRemoteControlEvents];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    NSLog(@"applicationDidBecomeActive...");
    [_sinaweibo applicationDidBecomeActive];
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)timerStart{
    
    [self timerStop];
    _getUnreadTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(getUnreadList) userInfo:nil repeats:YES];
    
}

-(void)timerStop{
    
    @synchronized(self){
        if (_getUnreadTimer != nil) {
            if ([_getUnreadTimer isValid]) {
                [_getUnreadTimer invalidate];
            }
            _getUnreadTimer = nil;
        }
    }
    
}

-(void)getUnreadList{
    
    NSString *memberid = [UserSessionManager GetInstance].currentRunUser.userid;
    NSString *unreadListUrl = [VankeAPI getUnreadList:memberid];
    NSLog(@"unreadListUrl:%@",unreadListUrl);
    NSURL *url = [NSURL URLWithString:unreadListUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"App.net Global Stream: %@", JSON);
        NSDictionary *dicResult = JSON;
        NSString *status = [dicResult objectForKey:@"status"];
        NSLog(@"status: %@", status);
        if ([status isEqual:@"0"]) {
            
            NSArray *datalist = [dicResult objectForKey:@"list"];
            int datalistCount = [datalist count];
            [UserSessionManager GetInstance].unreadMessageCount = datalistCount;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:UpdateUnreadMessageCount object:nil userInfo:nil];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"failure: %@", error);
        
    }];
    [operation start];
    
}

#pragma something
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    
    if ([[url absoluteString] hasPrefix:@"wx"]) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    
    if ([[url absoluteString] hasPrefix:@"sinaweibosso"]) {
        return [_sinaweibo handleOpenURL:url];
    }
    
    return YES;
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    if ([[url absoluteString] hasPrefix:@"wx"]) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    
    if ([[url absoluteString] hasPrefix:@"sinaweibosso"]) {
        return [_sinaweibo handleOpenURL:url];
    }
    
    return YES;
}

#pragma weixin
-(void)onReq:(BaseReq *)req{
    //onReq是微信终端向第三方程序发起请求，要求第三方程序响应。第三方程序响应完后必须调用sendRsp返回。在调用sendRsp返回时，会切回到微信终端程序界面。
    if ([req isKindOfClass:[GetMessageFromWXReq class]]) {
        //
    } else if ([req isKindOfClass:[ShowMessageFromWXReq class]]) {
        //
    }
    
}

-(void)onResp:(BaseResp *)resp{
    //如果第三方程序向微信发送了sendReq的请求，那么onResp会被回调。sendReq请求调用后，会切到微信终端程序界面。
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        NSLog(@"resp.errCode: %d, resp.description: %@", resp.errCode, resp.description);
    }
}


+(AppDelegate*)App
{
    return (AppDelegate *)[[UIApplication sharedApplication]delegate];
}

@end
