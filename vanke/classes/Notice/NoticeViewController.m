//
//  NoticeViewController.m
//  vanke
//
//  Created by pig on 13-6-10.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "NoticeViewController.h"
#import "UIImage+PImageCategory.h"
#import "IndexViewController.h"
#import "ChatViewController.h"
#import "SettingViewController.h"
#import "AFJSONRequestOperation.h"
#import "NewsInfo.h"

@interface NoticeViewController ()

@end

@implementation NoticeViewController

@synthesize navView = _navView;

@synthesize menuOfHeadView = _menuOfHeadView;
@synthesize menuOfCustomWindow = _menuOfCustomWindow;

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
    _navView = [[PCustomNavigationBarView alloc] initWithTitle:@"活动通知" bgImageView:@"index_nav_bg"];
    [self.view addSubview:_navView];
    
    UIImage *indexBack = [UIImage imageWithName:@"main_back" type:@"png"];
    [_navView.leftButton setBackgroundImage:indexBack forState:UIControlStateNormal];
    [_navView.leftButton setHidden:NO];
    [_navView.leftButton addTarget:self action:@selector(doBack) forControlEvents:UIControlEventTouchUpInside];
    
//    UIImage *indexHeadBg = [UIImage imageWithName:@"main_head" type:@"png"];
//    [_navView.rightButton setBackgroundImage:indexHeadBg forState:UIControlStateNormal];
//    [_navView.rightButton setHidden:NO];
//    [_navView.rightButton addTarget:self action:@selector(touchMenuAction:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIImage *messageTip = [UIImage imageWithName:@"index_button_new" type:@"png"];
//    [_navView.messageTipImageView setImage:messageTip];
//    [_navView.messageTipImageView setHidden:NO];
    
    //menu of head
    UIView *transparentByForMenu = [[UIView alloc] init];
    transparentByForMenu.frame = CGRectMake(0, 0, 320, height);
    UITapGestureRecognizer *tapViewForMenu = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchOutOfMenuAction:)];
    tapViewForMenu.cancelsTouchesInView = NO;
    [transparentByForMenu addGestureRecognizer:tapViewForMenu];
    
    NSArray *menuOfHeadNibContents = [[NSBundle mainBundle] loadNibNamed:@"MenuOfHead" owner:nil options:nil];
    _menuOfHeadView = (MenuOfHeadView *)[menuOfHeadNibContents objectAtIndex:0];
    _menuOfHeadView.frame = CGRectMake(270, 70, 57, 210);
    [transparentByForMenu addSubview:_menuOfHeadView];
    _menuOfCustomWindow = [[CustomWindow alloc] initWithView:transparentByForMenu];
    
    //menu of head 1
    [_menuOfHeadView.btnMenu1 addTarget:self action:@selector(touchHomeAction:) forControlEvents:UIControlEventTouchUpInside];
    [_menuOfHeadView.btnMenu2 addTarget:self action:@selector(touchNoticeAction:) forControlEvents:UIControlEventTouchUpInside];
    [_menuOfHeadView.btnMenu3 addTarget:self action:@selector(touchChatAction:) forControlEvents:UIControlEventTouchUpInside];
    [_menuOfHeadView.btnMenu4 addTarget:self action:@selector(touchSettingAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)doBack{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)touchMenuAction:(id)sender{
    
    NSLog(@"touchMenuAction...");
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    
    _menuOfHeadView.hidden = NO;
    _menuOfHeadView.alpha = 1.0f;
    CGRect menuframe = _menuOfHeadView.frame;
    _menuOfHeadView.frame = CGRectMake(menuframe.origin.x, menuframe.origin.y, menuframe.size.width, 210);
    
    [_menuOfCustomWindow show];
    
    [UIView commitAnimations];
    
}

-(void)touchOutOfMenuAction:(id)sender{
    
    NSLog(@"touchOutOfMenuAction...");
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    
    _menuOfHeadView.alpha = 0.0f;
    CGRect menuframe = _menuOfHeadView.frame;
    _menuOfHeadView.frame = CGRectMake(menuframe.origin.x, menuframe.origin.y, menuframe.size.width, 0);
    
    [UIView setAnimationDidStopSelector:@selector(hiddenMenuAfterAnimation)];
    [UIView commitAnimations];
    
}

-(void)hiddenMenuAfterAnimation{
    _menuOfCustomWindow.hidden = YES;
    _menuOfHeadView.hidden = YES;
    [_menuOfCustomWindow close];
}

-(void)touchHomeAction:(id)sender{
    
    [self doBack];
    
}

-(void)touchNoticeAction:(id)sender{
    
    NSLog(@"touchNoticeAction...");
    
    NoticeViewController *noticeViewController = [[NoticeViewController alloc] initWithNibName:@"NoticeViewController" bundle:nil];
    [self.navigationController pushViewController:noticeViewController animated:YES];
    
}

-(void)touchChatAction:(id)sender{
    
    NSLog(@"touchChatAction...");
    
    ChatViewController *chatViewController = [[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil];
    [self.navigationController pushViewController:chatViewController animated:YES];
    
}

-(void)touchSettingAction:(id)sender{
    
    NSLog(@"touchSettingAction...");
    
    SettingViewController *settingViewController = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
    [self.navigationController pushViewController:settingViewController animated:YES];
    
}

@end
