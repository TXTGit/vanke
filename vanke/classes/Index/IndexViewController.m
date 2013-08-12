//
//  IndexViewController.m
//  vanke
//
//  Created by pig on 13-6-9.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "IndexViewController.h"
#import "UIImage+PImageCategory.h"
#import "RunViewController.h"
#import "UserSessionManager.h"
#import "VankeAPI.h"
#import "AFJSONRequestOperation.h"
#import "VankeConfig.h"
#import "NoticeViewController.h"
#import "ChatViewController.h"
#import "SettingViewController.h"
#import "ChatlistViewController.h"
#import "PCommonUtil.h"
#import "AppDelegate.h"
#import "VankeViewController.h"
#import "StoreViewController.h"

@interface IndexViewController ()

@end

@implementation IndexViewController

@synthesize mapView = _mapView;

@synthesize navView = _navView;

@synthesize menuOfHeadView = _menuOfHeadView;
@synthesize menuOfCustomWindow = _menuOfCustomWindow;

@synthesize btnIndexRun = _btnIndexRun;
@synthesize btnIndexVanke = _btnIndexVanke;
@synthesize btnIndexStore = _btnIndexStore;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    float height = [UIScreen mainScreen].bounds.size.height - 20;
    
    //nav bar
    _navView = [[PCustomNavigationBarView alloc] initWithTitle:[UserSessionManager GetInstance].currentRunUser.nickname bgImageView:@"index_nav_bg"];
    [self.view addSubview:_navView];
    
//    NSString *headImg = [UserSessionManager GetInstance].currentRunUser.headImg;
//    if (headImg && ![headImg isEqualToString:@""]) {
//        NSURL *headUrl = [NSURL URLWithString:headImg];
//        [_navView.rightButton setImageURL:headUrl];
//    }else{
//        UIImage *indexHeadBg = [UIImage imageWithName:@"main_head" type:@"png"];
//        [_navView.rightButton setBackgroundImage:indexHeadBg forState:UIControlStateNormal];
//    }
    [_navView.rightButton setHidden:NO];
    [_navView.rightButton addTarget:self action:@selector(touchMenuAction:) forControlEvents:UIControlEventTouchUpInside];
    [_navView setShowHeadImg:YES];
    
    UIImage *messageTip = [UIImage imageWithName:@"index_button_new" type:@"png"];
    [_navView.messageTipImageView setImage:messageTip];
    
    //menu of head
//    UIView *transparentByForMenu = [[UIView alloc] init];
//    transparentByForMenu.frame = CGRectMake(0, 0, 320, height);
//    UITapGestureRecognizer *tapViewForMenu = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchOutOfMenuAction:)];
//    tapViewForMenu.cancelsTouchesInView = NO;
//    [transparentByForMenu addGestureRecognizer:tapViewForMenu];
//    
//    _menuOfHeadView = [[PDropdownMenuView alloc] initDropdownMenuOfHead:CGRectMake(270, 70, 57, 210)];
//    [transparentByForMenu addSubview:_menuOfHeadView];
//    _menuOfCustomWindow = [[CustomWindow alloc] initWithView:transparentByForMenu];
//    
//    //menu of head 1
//    [_menuOfHeadView.btnMenu1 addTarget:self action:@selector(touchHomeAction:) forControlEvents:UIControlEventTouchUpInside];
//    [_menuOfHeadView.btnMenu2 addTarget:self action:@selector(touchChatAction:) forControlEvents:UIControlEventTouchUpInside];
//    [_menuOfHeadView.btnMenu3 addTarget:self action:@selector(touchNoticeAction:) forControlEvents:UIControlEventTouchUpInside];
//    [_menuOfHeadView.btnMenu4 addTarget:self action:@selector(touchSettingAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //
//    [self getUnreadDataFromServerByHttp];
    
//    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    [appdelegate timerStart];
    [[AppDelegate App] timerStart];
    
    [self doGetMemberInfo:[UserSessionManager GetInstance].currentRunUser.userid];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if ([UserSessionManager GetInstance].unreadMessageCount > 0 || [UserSessionManager GetInstance].inviteMessageCount > 0) {
        [_navView.messageTipImageView setHidden:NO];
    } else {
        [_navView.messageTipImageView setHidden:YES];
    }
    
    //百度
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    
    //baidu
    _mapView.showsUserLocation = YES;
    //更新未读提醒
//    [[AppDelegate App] getUnreadList];
    
    NSString *FirstIndex = [[NSUserDefaults standardUserDefaults] objectForKey:@"FirstIndex"];
    if (!FirstIndex || [FirstIndex isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"万科夺宝计划正式启动。跑步里程1公里=1能量点，系统自动累计。凭能量点兑换豪华运动装备！跑步领奖两不误！活动结束日期：2013.12.31" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [[NSUserDefaults standardUserDefaults] setObject:@"done" forKey:@"FirstIndex"];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    
    //baidu
    _mapView.showsUserLocation = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)touchMenuAction:(id)sender{
//    
//    NSLog(@"touchMenuAction...");
//    
//    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut animations:^{
//        
//        _menuOfHeadView.hidden = NO;
//        _menuOfHeadView.alpha = 1.0f;
//        _menuOfHeadView.btnMenu1.alpha = 1.0f;
//        _menuOfHeadView.btnMenu2.alpha = 1.0f;
//        _menuOfHeadView.btnMenu3.alpha = 1.0f;
//        _menuOfHeadView.btnMenu4.alpha = 1.0f;
//        if ([UserSessionManager GetInstance].unreadMessageCount > 0) {
//            _menuOfHeadView.redDotImageView.hidden = NO;
//        } else {
//            _menuOfHeadView.redDotImageView.hidden = YES;
//        }
//        
//        CGRect menuframe = _menuOfHeadView.frame;
//        _menuOfHeadView.frame = CGRectMake(menuframe.origin.x, menuframe.origin.y, menuframe.size.width, 210);
//        
//        [_menuOfCustomWindow show];
//        
//    } completion:^(BOOL finished) {
//        
//    }];
//    
//}
//
//-(void)touchOutOfMenuAction:(id)sender{
//    
//    NSLog(@"touchOutOfMenuAction...");
//    
//    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut animations:^{
//        
//        _menuOfHeadView.alpha = 0.0f;
//        _menuOfHeadView.btnMenu1.alpha = 0.0f;
//        _menuOfHeadView.btnMenu2.alpha = 0.0f;
//        _menuOfHeadView.btnMenu3.alpha = 0.0f;
//        _menuOfHeadView.btnMenu4.alpha = 0.0f;
//        CGRect menuframe = _menuOfHeadView.frame;
//        _menuOfHeadView.frame = CGRectMake(menuframe.origin.x, menuframe.origin.y, menuframe.size.width, 0);
//        
//    } completion:^(BOOL finished) {
//        
//        _menuOfCustomWindow.hidden = YES;
//        _menuOfHeadView.hidden = YES;
//        [_menuOfCustomWindow close];
//        
//    }];
//    
//}

//-(void)touchHomeAction:(id)sender{
//    
//    NSLog(@"touchHomeAction...");
//    
//}
//
//-(void)touchNoticeAction:(id)sender{
//    
//    NSLog(@"touchNoticeAction...");
//    
//    NoticeViewController *noticeViewController = [[NoticeViewController alloc] initWithNibName:@"NoticeViewController" bundle:nil];
//    [self.navigationController pushViewController:noticeViewController animated:YES];
//    
//}
//
//-(void)touchChatAction:(id)sender{
//    
//    NSLog(@"touchChatAction...");
//    
////    ChatViewController *chatViewController = [[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil];
////    [chatViewController setChatType:chatTypeDefault];
////    [self.navigationController pushViewController:chatViewController animated:YES];
//    
//    ChatlistViewController *chatListViewController = [[ChatlistViewController alloc]initWithNibName:@"ChatlistViewController" bundle:nil];
//    [self.navigationController pushViewController:chatListViewController animated:YES];
//}
//
//-(void)touchSettingAction:(id)sender{
//    
//    NSLog(@"touchSettingAction...");
//    
//    NSString *memberid = [UserSessionManager GetInstance].currentRunUser.userid;
//    SettingViewController *settingViewController = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
//    [settingViewController setMemberid:[memberid longLongValue]];
//    [self.navigationController pushViewController:settingViewController animated:YES];
//    
//}

//

-(IBAction)doIndexRun:(id)sender{
    
    RunViewController *runViewController = [[RunViewController alloc] initWithNibName:@"RunViewController" bundle:nil];
    [self.navigationController pushViewController:runViewController animated:YES];
    
}

-(IBAction)doIndexVanke:(id)sender{
    
    NSLog(@"doIndexVanke...");
    
    VankeViewController *vankeViewController = [[VankeViewController alloc] initWithNibName:@"VankeViewController" bundle:nil];
    [self.navigationController pushViewController:vankeViewController animated:YES];
    
}

-(IBAction)doIndexStore:(id)sender{
    
    NSLog(@"doIndexStore...");
    
    StoreViewController *storeViewController = [[StoreViewController alloc] initWithNibName:@"StoreViewController" bundle:nil];
    [self.navigationController pushViewController:storeViewController animated:YES];
    
}

-(void)getUnreadDataFromServerByHttp{
    
    NSString *memberid = [UserSessionManager GetInstance].currentRunUser.userid;
    NSString *getUnreadUrl = [VankeAPI getUnreadUrl:memberid];
    NSLog(@"getUnreadUrl: %@", getUnreadUrl);
    
    NSURL *url = [NSURL URLWithString:getUnreadUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60 * 30];
    [request setValue:@"wsdl2objc" forHTTPHeaderField:@"User-Agent"];
    [request setValue:url.host forHTTPHeaderField:@"Host"];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"getUnreadDataFromServerByHttp success: %@", JSON);
        NSDictionary *dicResult = JSON;
        NSString *status = [dicResult objectForKey:@"status"];
        NSLog(@"status: %@", status);
        if ([status isEqual:@"0"]) {
            
        }
        
        //3秒后继续请求
        [self performSelector:@selector(getUnreadDataFromServerByHttp) withObject:nil afterDelay:3.0];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"getUnreadDataFromServerByHttp failure: %@", error);
        
        //3秒后继续请求
        [self performSelector:@selector(getUnreadDataFromServerByHttp) withObject:nil afterDelay:3.0];
        
    }];
    [operation start];
    
}

-(void)doGetMemberInfo:(NSString *)memberid{
    
    //搞个事件来同步下
    //    NSCondition *itlock = [[NSCondition alloc] init];
    
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
//            NSDictionary *dicEnt = [dicResult objectForKey:@"ent"];
            NSArray *entList = [dicResult objectForKey:@"ent"];
            if (entList && [entList count] > 0) {
                
                NSDictionary *dicEnt0 = [entList objectAtIndex:0];
                
                RunUser *runner = [RunUser initWithNSDictionary:dicEnt0];
                if (runner.headImg) {
                    runner.headImg = [NSString stringWithFormat:@"%@%@%@", VANKE_DOMAINBase, imgpath, runner.headImg];
                }
                runner.userid = [UserSessionManager GetInstance].currentRunUser.userid;
                [UserSessionManager GetInstance].currentRunUser = runner;
                NSLog(@"headImg: %@", runner.headImg);
                
                //show nickname
                _navView.titleLabel.text = runner.nickname;
                
                //show headImg
                NSString *headImg = runner.headImg;
                if (headImg && ![headImg isEqualToString:@""]) {
                    
                    //显示头像图片
                    NSURL *avatarUrl = [NSURL URLWithString:headImg];
                    [_navView.rightButton setImageURL:avatarUrl];
                    
                    /*
                    UIImage* anImage = [[EGOImageLoader sharedImageLoader] imageForURL:avatarUrl shouldLoadWithObserver:nil];
                    if (anImage) {
                        
                        
                        UIImage *srcWhiteCircle = [UIImage imageWithName:@"white_circle" type:@"png"];
                        UIImage *tempWhiteCircle = [UIImage scaleImage:srcWhiteCircle scaleToSize:anImage.size];
                        UIImage *avatarImage = [PCommonUtil mergerImage:anImage secodImage:tempWhiteCircle];
                        
                        [_navView.rightButton setImage:avatarImage forState:UIControlStateNormal];
                        
                    } else {
                        [_navView.rightButton setImageURL:avatarUrl];
                    }
                    */
                }
            }
            
        }else{
            NSString *errMsg = [dicResult objectForKey:@"msg"];
//            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
//            
//            // Configure for text only and offset down
//            hud.mode = MBProgressHUDModeText;
//            hud.labelText = errMsg;
//            hud.margin = 10.f;
//            hud.yOffset = 150.0f;
//            hud.removeFromSuperViewOnHide = YES;
//            [hud hide:YES afterDelay:2];
            [SVProgressHUD showErrorWithStatus:errMsg];
        }
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"failure: %@", error);
        
        [SVProgressHUD showErrorWithStatus:@"网络异常,请重试"];
    }];
    [operation start];
    
}

#pragma map view delegate

/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)mapViewWillStartLocatingUser:(BMKMapView *)mapView
{
	NSLog(@"start locate");
}

/**
 *用户位置更新后，会调用此函数
 *@param mapView 地图View
 *@param userLocation 新的用户位置
 */

- (void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation
{
	if (userLocation != nil) {
        
        NSString *templocation = [NSString stringWithFormat:@"%f,%f", userLocation.coordinate.latitude, userLocation.coordinate.longitude];
        NSLog(@"templocation: %@", templocation);
        
        _mapView.showsUserLocation = NO;
        
	}
	
}
/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)mapViewDidStopLocatingUser:(BMKMapView *)mapView
{
    NSLog(@"stop locate");
}
/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
}

#pragma EGOImageButtonDelegate
//- (void)imageButtonLoadedImage:(EGOImageButton*)imageButton;
//- (void)imageButtonFailedToLoadImage:(EGOImageButton*)imageButton error:(NSError*)error;

@end
