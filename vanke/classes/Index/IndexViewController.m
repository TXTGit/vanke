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

@interface IndexViewController ()

@end

@implementation IndexViewController

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
    
    UIImage *indexHeadBg = [UIImage imageWithName:@"main_head" type:@"png"];
    [_navView.rightButton setBackgroundImage:indexHeadBg forState:UIControlStateNormal];
    [_navView.rightButton setHidden:NO];
//    [_navView.rightButton addTarget:self action:@selector(touchMenuAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *messageTip = [UIImage imageWithName:@"index_button_new" type:@"png"];
    [_navView.messageTipImageView setImage:messageTip];
//    [_navView.messageTipImageView setHidden:NO];
    
    //menu of head
    UIView *transparentByForMenu = [[UIView alloc] init];
    transparentByForMenu.frame = CGRectMake(0, 0, 320, height);
    UITapGestureRecognizer *tapViewForMenu = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchOutOfMenuAction:)];
    tapViewForMenu.cancelsTouchesInView = NO;
    [transparentByForMenu addGestureRecognizer:tapViewForMenu];
    
    _menuOfHeadView = [[PDropdownMenuView alloc] initDropdownMenuOfHead:CGRectMake(270, 70, 57, 210)];
    [transparentByForMenu addSubview:_menuOfHeadView];
    _menuOfCustomWindow = [[CustomWindow alloc] initWithView:transparentByForMenu];
    
    //menu of head 1
    [_menuOfHeadView.btnMenu1 addTarget:self action:@selector(touchHomeAction:) forControlEvents:UIControlEventTouchUpInside];
    [_menuOfHeadView.btnMenu2 addTarget:self action:@selector(touchChatAction:) forControlEvents:UIControlEventTouchUpInside];
    [_menuOfHeadView.btnMenu3 addTarget:self action:@selector(touchNoticeAction:) forControlEvents:UIControlEventTouchUpInside];
    [_menuOfHeadView.btnMenu4 addTarget:self action:@selector(touchSettingAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //
//    [self getUnreadDataFromServerByHttp];
    
    [self doGetMemberInfo:[UserSessionManager GetInstance].currentRunUser.userid];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchMenuAction:(id)sender{
    
    NSLog(@"touchMenuAction...");
    
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut animations:^{
        
        _menuOfHeadView.hidden = NO;
        _menuOfHeadView.alpha = 1.0f;
        _menuOfHeadView.btnMenu1.alpha = 1.0f;
        _menuOfHeadView.btnMenu2.alpha = 1.0f;
        _menuOfHeadView.btnMenu3.alpha = 1.0f;
        _menuOfHeadView.btnMenu4.alpha = 1.0f;
        CGRect menuframe = _menuOfHeadView.frame;
        _menuOfHeadView.frame = CGRectMake(menuframe.origin.x, menuframe.origin.y, menuframe.size.width, 210);
        
        [_menuOfCustomWindow show];
        
    } completion:^(BOOL finished) {
        
    }];
    
}

-(void)touchOutOfMenuAction:(id)sender{
    
    NSLog(@"touchOutOfMenuAction...");
    
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut animations:^{
        
        _menuOfHeadView.alpha = 0.0f;
        _menuOfHeadView.btnMenu1.alpha = 0.0f;
        _menuOfHeadView.btnMenu2.alpha = 0.0f;
        _menuOfHeadView.btnMenu3.alpha = 0.0f;
        _menuOfHeadView.btnMenu4.alpha = 0.0f;
        CGRect menuframe = _menuOfHeadView.frame;
        _menuOfHeadView.frame = CGRectMake(menuframe.origin.x, menuframe.origin.y, menuframe.size.width, 0);
        
    } completion:^(BOOL finished) {
        
        _menuOfCustomWindow.hidden = YES;
        _menuOfHeadView.hidden = YES;
        [_menuOfCustomWindow close];
        
    }];
    
}

-(void)touchHomeAction:(id)sender{
    
    NSLog(@"touchHomeAction...");
    
}

-(void)touchNoticeAction:(id)sender{
    
    NSLog(@"touchNoticeAction...");
    
    NoticeViewController *noticeViewController = [[NoticeViewController alloc] initWithNibName:@"NoticeViewController" bundle:nil];
    [self.navigationController pushViewController:noticeViewController animated:YES];
    
}

-(void)touchChatAction:(id)sender{
    
    NSLog(@"touchChatAction...");
    
    ChatViewController *chatViewController = [[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil];
    [chatViewController setChatType:chatTypeDefault];
    [self.navigationController pushViewController:chatViewController animated:YES];
    
}

-(void)touchSettingAction:(id)sender{
    
    NSLog(@"touchSettingAction...");
    
    NSString *memberid = [UserSessionManager GetInstance].currentRunUser.userid;
    SettingViewController *settingViewController = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
    [settingViewController setMemberid:[memberid longLongValue]];
    [self.navigationController pushViewController:settingViewController animated:YES];
    
}

//

-(IBAction)doIndexRun:(id)sender{
    
    RunViewController *runViewController = [[RunViewController alloc] initWithNibName:@"RunViewController" bundle:nil];
    [self.navigationController pushViewController:runViewController animated:YES];
    
}

-(IBAction)doIndexVanke:(id)sender{
    NSLog(@"doIndexVanke...");
}

-(IBAction)doIndexStore:(id)sender{
    NSLog(@"doIndexStore...");
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
            NSDictionary *dicEnt = [dicResult objectForKey:@"ent"];
            RunUser *runner = [RunUser initWithNSDictionary:dicEnt];
            runner.headImg = [NSString stringWithFormat:@"%@%@%@", VANKE_DOMAINBase, imgpath, runner.headImg];
            [UserSessionManager GetInstance].currentRunUser = runner;
            NSLog(@"headImg: %@", runner.headImg);
            
            //show nickname
            _navView.titleLabel.text = runner.nickname;
            
        }else{
            NSString *errMsg = [dicResult objectForKey:@"msg"];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            
            // Configure for text only and offset down
            hud.mode = MBProgressHUDModeText;
            hud.labelText = errMsg;
            hud.margin = 10.f;
            hud.yOffset = 150.0f;
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:2];
        }
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"failure: %@", error);
        
    }];
    [operation start];
    
}

@end
