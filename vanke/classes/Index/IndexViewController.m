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
    _navView = [[PCustomNavigationBarView alloc] initWithTitle:[UserSessionManager GetInstance].currentRunUser.nickname bgImageView:@"index_nav_bg"];
    [self.view addSubview:_navView];
    
//    UIImage *indexHeadBg = [UIImage imageWithName:@"main_head" type:@"png"];
//    [_navView.rightButton setBackgroundImage:indexHeadBg forState:UIControlStateNormal];
//    [_navView.rightButton setHidden:NO];
    
//    UIImage *messageTip = [UIImage imageWithName:@"index_button_new" type:@"png"];
//    [_navView.messageTipImageView setImage:messageTip];
//    [_navView.messageTipImageView setHidden:NO];
    
    //
//    [self getUnreadDataFromServerByHttp];
    
    [self doGetMemberInfo:[UserSessionManager GetInstance].currentRunUser.userid];
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
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60 * 30];
//    [request setValue:@"1" forKey:@"keep-alive"];
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
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            
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
