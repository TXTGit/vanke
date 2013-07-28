//
//  NoticeDetailViewController.m
//  vanke
//
//  Created by user on 13-7-29.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "NoticeDetailViewController.h"
#import "UIImage+PImageCategory.h"
#import "VankeAPI.h"
#import "AFJSONRequestOperation.h"

@interface NoticeDetailViewController ()

@end

@implementation NoticeDetailViewController
@synthesize navView = _navView;
@synthesize newsInfo = _newsInfo;

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
    
    self.webView.scrollView.bounces = NO;
    
    //nav bar
    _navView = [[PCustomNavigationBarView alloc] initWithTitle:@"活动通知" bgImageView:@"index_nav_bg"];
    [self.view addSubview:_navView];
    
    UIImage *indexBack = [UIImage imageWithName:@"main_back" type:@"png"];
    [_navView.leftButton setBackgroundImage:indexBack forState:UIControlStateNormal];
    [_navView.leftButton setHidden:NO];
    [_navView.leftButton addTarget:self action:@selector(doBack) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *headImg = [UserSessionManager GetInstance].currentRunUser.headImg;
    if (headImg && ![headImg isEqualToString:@""]) {
        NSURL *headUrl = [NSURL URLWithString:headImg];
        [_navView.rightButton setImageURL:headUrl];
    }else{
        UIImage *indexHeadBg = [UIImage imageWithName:@"main_head" type:@"png"];
        [_navView.rightButton setBackgroundImage:indexHeadBg forState:UIControlStateNormal];
    }
    [_navView.rightButton setHidden:NO];
    [_navView.rightButton addTarget:self action:@selector(touchMenuAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self initData];
}

-(void)initData
{
    NSString *getActivitysListUrl = [VankeAPI getNewsUrl:[NSString stringWithFormat:@"%d",_newsInfo.newsID]];
    NSLog(@"getActivitysListUrl: %@", getActivitysListUrl);
    
    NSURL *url = [NSURL URLWithString:getActivitysListUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSLog(@"getActivitysListUrl success: %@", JSON);
        
        NSDictionary *dicResult = JSON;
        NSString *status = [dicResult objectForKey:@"status"];
        NSLog(@"status: %@", status);
        if ([status isEqual:@"0"]) {
            NSDictionary *dicEnt = [dicResult objectForKey:@"ent"];
            NewsInfo *newsInfo = [NewsInfo initWithNSDictionary:dicEnt];
            self.lblTitle.text = newsInfo.title;
            [self.webView loadHTMLString:newsInfo.newsText baseURL:url];
            [self.webView sizeToFit];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        NSLog(@"getUnreadDataFromServerByHttp failure: %@", error);
        
    }];
    [operation start];
}

-(void)doBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setLblTitle:nil];
    [self setWebView:nil];
    [super viewDidUnload];
}
@end
