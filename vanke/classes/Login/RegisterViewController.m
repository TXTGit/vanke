//
//  RegisterViewController.m
//  vanke
//
//  Created by pig on 13-6-10.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "RegisterViewController.h"
#import "UIImage+PImageCategory.h"
#import "BindViewController.h"
#import "RunUser.h"
#import "VankeAPI.h"
#import "AFJSONRequestOperation.h"
#import "IndexViewController.h"
#import "UserSessionManager.h"
#import "MBProgressHUD.h"
#import "PCommonUtil.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

@synthesize tempScroll = _tempScroll;
@synthesize broadView = _broadView;
@synthesize nicknameField = _nicknameField;
@synthesize passwordField = _passwordField;
@synthesize realnameField = _realnameField;
@synthesize idcardField = _idcardField;
@synthesize telField = _telField;
@synthesize btnNext = _btnNext;

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
    
    _broadView.frame = CGRectMake(0, 0, 320, 548);
    
    _tempScroll = [[UIScrollView alloc] init];
    _tempScroll.frame = CGRectMake(0, 20, 320, height);
    _tempScroll.scrollEnabled = YES;
    _tempScroll.contentSize = CGSizeMake(320, 548);
    [_tempScroll addSubview:_broadView];
    [self.view addSubview:_tempScroll];
    
    //nav bar
    _navView = [[PCustomNavigationBarView alloc] initWithTitle:@"注册" bgImageView:@"index_nav_bg"];
    [self.view addSubview:_navView];
    
    UIImage *indexBack = [UIImage imageWithName:@"main_back" type:@"png"];
    [_navView.leftButton setBackgroundImage:indexBack forState:UIControlStateNormal];
    [_navView.leftButton setHidden:NO];
    [_navView.leftButton addTarget:self action:@selector(doBack) forControlEvents:UIControlEventTouchUpInside];
        
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)doBack{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma textfield delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    float height = [UIScreen mainScreen].bounds.size.height - 20;
    _tempScroll.frame = CGRectMake(0, 0, 320, height - 210);
    
    if (textField == _passwordField) {
        [_tempScroll scrollRectToVisible:CGRectMake(0, 80, 320, height - 210) animated:YES];
    } else if (textField == _realnameField) {
        [_tempScroll scrollRectToVisible:CGRectMake(0, 140, 320, height - 210) animated:YES];
    } else if (textField == _idcardField) {
        [_tempScroll scrollRectToVisible:CGRectMake(0, 180, 320, height - 210) animated:YES];
    } else if (textField == _telField) {
        [_tempScroll scrollRectToVisible:CGRectMake(0, 220, 320, height - 210) animated:YES];
    }
    
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == _nicknameField) {
        [_passwordField becomeFirstResponder];
    } else if (textField == _passwordField) {
        [_realnameField becomeFirstResponder];
    } else if (textField == _realnameField) {
        [_idcardField becomeFirstResponder];
    } else if (textField == _idcardField) {
        [_telField becomeFirstResponder];
    } else {
        
        float height = [UIScreen mainScreen].bounds.size.height - 20;
        _tempScroll.frame = CGRectMake(0, 20, 320, height);
        
        [textField resignFirstResponder];
        
    }
    
    return YES;
}

-(IBAction)resiginTextField:(id)sender{
    
    float height = [UIScreen mainScreen].bounds.size.height - 20;
    _tempScroll.frame = CGRectMake(0, 20, 320, height);
    
    [_nicknameField resignFirstResponder];
    [_passwordField resignFirstResponder];
    [_realnameField resignFirstResponder];
    [_idcardField resignFirstResponder];
    [_telField resignFirstResponder];
    
}

-(IBAction)doNext:(id)sender{
    [self.btnNext setEnabled:NO];
    
    RunUser *runner = [[RunUser alloc] init];
    runner.nickname = _nicknameField.text;
    runner.password = _passwordField.text;
    runner.fullname = _realnameField.text;
    runner.idcard = _idcardField.text;
    runner.tel = _telField.text;
    
    [self doRegister:runner];
    
}

-(void)doRegister:(RunUser *)runner{
    
    [self resiginTextField:nil];
    
    NSString *errMsg = [[NSString alloc]init];
    
    if (!runner.nickname || runner.nickname.length <= 2) {
        NSLog(@"runner data is null...");
        errMsg = @"昵称需要大于2个字";
    }else if([self.passwordField.text isEqualToString:@""]){
        errMsg = @"请输入密码";
    }else if([self.realnameField.text isEqualToString:@""]){
        errMsg = @"请输入真实姓名";
    }
    else if (![PCommonUtil isValidateIdentityCard:self.idcardField.text]) {
        errMsg = @"请输入正确的身份证号码";
    }else if (![PCommonUtil isValidateMobile:self.telField.text]) {
        errMsg = @"请输入正确的手机号码";
    }
    
    if (errMsg && ![errMsg isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.labelText = errMsg;
        hud.margin = 10.f;
        hud.yOffset = 150.f;
        hud.removeFromSuperViewOnHide = YES;
        
        [hud hide:YES afterDelay:2];
        
        [self.btnNext setEnabled:YES];
        return;
    }
    
    NSString *registerUrl = [VankeAPI getRegisterUrl:runner.tel password:runner.password nickname:runner.nickname fullname:runner.fullname idCard:runner.idcard];
    NSLog(@"registerUrl:%@",registerUrl);
    NSURL *url = [NSURL URLWithString:registerUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"App.net Global Stream: %@", JSON);
        NSDictionary *dicResult = JSON;
        NSString *status = [dicResult objectForKey:@"status"];
        NSLog(@"status: %@", status);
        if ([status isEqual:@"0"]) {
            
            [UserSessionManager GetInstance].currentRunUser.userid = [dicResult objectForKey:@"memberID"];
            int communityid = [[dicResult objectForKey:@"communityID"] intValue];
            if (communityid > 0) {
                
                IndexViewController *indexViewController = [[IndexViewController alloc] initWithNibName:@"IndexViewController" bundle:nil];
                [self.navigationController pushViewController:indexViewController animated:YES];
                
            } else {
                
                BindViewController *bindViewController = [[BindViewController alloc] initWithNibName:@"BindViewController" bundle:nil];
                [bindViewController setRunUser:runner];
                [self.navigationController pushViewController:bindViewController animated:YES];
                
            }
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
            
            [self.btnNext setEnabled:YES];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"failure: %@", error);
    }];
    [operation start];
    
}

@end
