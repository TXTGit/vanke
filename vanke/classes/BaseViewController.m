//
//  BaseViewController.m
//  vanke
//
//  Created by user on 13-7-26.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "BaseViewController.h"
#import "ChatlistViewController.h"
#import "NoticeViewController.h"
#import "IndexViewController.h"
#import "SettingViewController.h"
#import "AppDelegate.h"
#import "UIImage+PImageCategory.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

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
	// Do any additional setup after loading the view.
    float height = [UIScreen mainScreen].bounds.size.height - 20;
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
        if ([UserSessionManager GetInstance].unreadMessageCount > 0 || [UserSessionManager GetInstance].inviteMessageCount > 0) {
            _menuOfHeadView.redDotImageView.hidden = NO;
        } else {
            _menuOfHeadView.redDotImageView.hidden = YES;
        }
        
        CGRect menuframe = _menuOfHeadView.frame;
        _menuOfHeadView.frame = CGRectMake(menuframe.origin.x, menuframe.origin.y, menuframe.size.width, 210);
        
        [_menuOfCustomWindow show];
        
    } completion:^(BOOL finished) {
//        NSString *menuName = [NSString stringWithFormat:@"%@",[self class]];
//        NSString *FirstMenu = [[NSUserDefaults standardUserDefaults] objectForKey:menuName];
//        if (!FirstMenu || [FirstMenu isEqualToString:@""]) {
            [_menuOfCustomWindow setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6]];
            UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
            [imgView setImage:[UIImage imageWithName:@"menu_descriptioin"]];
            [_menuOfCustomWindow addSubview:imgView];
//            [[NSUserDefaults standardUserDefaults] setObject:@"done" forKey:menuName];
//        }
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
    
    NSLog(@"touchChatAction...");
    if (![self.class isSubclassOfClass:[IndexViewController class]]) {
        UIViewController *controller = [self.navigationController.viewControllers objectAtIndex:1];
        if ([controller.class isSubclassOfClass:IndexViewController.class]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}

-(void)touchChatAction:(id)sender{
    
    NSLog(@"touchChatAction...");
    
    //    ChatViewController *chatViewController = [[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil];
    //    [chatViewController setChatType:chatTypeDefault];
    //    [self.navigationController pushViewController:chatViewController animated:YES];
    if (![self.class isSubclassOfClass:ChatlistViewController.class]) {
        ChatlistViewController *chatListViewController = [[ChatlistViewController alloc]initWithNibName:@"ChatlistViewController" bundle:nil];
        [self.navigationController pushViewController:chatListViewController animated:YES];
    }
}

-(void)touchNoticeAction:(id)sender{
    
    NSLog(@"touchNoticeAction...");
    if (![self.class isSubclassOfClass:NoticeViewController.class]) {
        NoticeViewController *noticeViewController = [[NoticeViewController alloc] initWithNibName:@"NoticeViewController" bundle:nil];
        [self.navigationController pushViewController:noticeViewController animated:YES];
    }
}

-(void)touchSettingAction:(id)sender{
    
    NSLog(@"touchSettingAction...");
    if (![self.class isSubclassOfClass:SettingViewController.class]) {
        NSString *memberid = [UserSessionManager GetInstance].currentRunUser.userid;
        SettingViewController *settingViewController = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
        [settingViewController setMemberid:[memberid longLongValue]];
        [self.navigationController pushViewController:settingViewController animated:YES];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //更新未读提醒
    [[NSNotificationCenter defaultCenter] postNotificationName:UpdateUnreadMessageCount object:nil userInfo:nil];
    [[AppDelegate App] getUnreadList];
    //更新头像
    [[NSNotificationCenter defaultCenter] postNotificationName:UpdateHeadImg object:nil userInfo:nil];
}

@end
