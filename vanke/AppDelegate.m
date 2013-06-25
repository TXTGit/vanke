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

@implementation AppDelegate

@synthesize window = _window;
@synthesize navController = _navController;

@synthesize mapManager = _mapManager;

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
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma something
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    
    if ([[url absoluteString] hasPrefix:@"wx"]) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    
    return YES;
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    if ([[url absoluteString] hasPrefix:@"wx"]) {
        return [WXApi handleOpenURL:url delegate:self];
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

@end
