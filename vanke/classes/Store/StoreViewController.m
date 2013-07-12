//
//  StoreViewController.m
//  vanke
//
//  Created by apple on 13-7-12.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "StoreViewController.h"
#import "UIImage+PImageCategory.h"
#import "VankeConfig.h"

@interface StoreViewController ()

@end

@implementation StoreViewController

@synthesize navView = _navView;
@synthesize storeWebView = _storeWebView;
@synthesize indicatorView = _indicatorView;

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
    _navView = [[PCustomNavigationBarView alloc] initWithTitle:@"万客会" bgImageView:@"index_nav_bg"];
    [self.view addSubview:_navView];
    
    UIImage *indexBack = [UIImage imageWithName:@"main_back" type:@"png"];
    [_navView.leftButton setBackgroundImage:indexBack forState:UIControlStateNormal];
    [_navView.leftButton setHidden:NO];
    [_navView.leftButton addTarget:self action:@selector(doBack) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.view.frame = CGRectMake(0, 0, 320, height - 20);
    _storeWebView.frame = CGRectMake(0, 44, 320, height - 20 - 44);
    _storeWebView.scrollView.bounces = NO;
    
    [self initData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)doBack{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)initData{
    
    [_storeWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:VANKE_STORE_URL]]];
    
}

#pragma webview delegate

-(void)webViewDidStartLoad:(UIWebView *)webView{
    
    [_indicatorView startAnimating];
    
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    if(_indicatorView.isAnimating){
        [_indicatorView stopAnimating];
    }
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    if(_indicatorView.isAnimating){
        [_indicatorView stopAnimating];
    }
    
}

@end
