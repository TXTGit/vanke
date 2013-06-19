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
#import "AutoLogin.h"

@interface IndexViewController ()

@end

@implementation IndexViewController

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
    
    //nav bar
    _navView = [[PCustomNavigationBarView alloc] initWithTitle:@"Hi! Mey" bgImageView:@"index_nav_bg"];
    [self.view addSubview:_navView];
    
    UIImage *indexHeadBg = [UIImage imageWithName:@"main_head" type:@"png"];
    [_navView.rightButton setBackgroundImage:indexHeadBg forState:UIControlStateNormal];
    [_navView.rightButton setHidden:NO];
    
    UIImage *messageTip = [UIImage imageWithName:@"index_button_new" type:@"png"];
    [_navView.messageTipImageView setImage:messageTip];
    [_navView.messageTipImageView setHidden:NO];
    
    AutoLogin *autoLogin = [[AutoLogin alloc] init];
    [autoLogin doAutoLogin];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)doIndexRun:(id)sender{
    
    RunViewController *runViewController = [[RunViewController alloc] initWithNibName:@"RunViewController" bundle:nil];
    [self.navigationController pushViewController:runViewController animated:YES];
    
}

-(IBAction)doIndexVanke:(id)sender{
    
}

-(IBAction)doIndexStore:(id)sender{
    
}

@end
