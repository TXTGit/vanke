//
//  LoginViewController.m
//  vanke
//
//  Created by pig on 13-6-9.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "LoginViewController.h"
#import "IndexViewController.h"
#import "UIImage+PImageCategory.h"
#import "RegisterViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize usernameField = _usernameField;
@synthesize passwordField = _passwordField;
@synthesize btnLogin = _btnLogin;
@synthesize ivIsRecordAccount = _ivIsRecordAccount;
@synthesize btnIsAutoLogin = _btnIsAutoLogin;
@synthesize ivIsAutoLogin = _ivIsAutoLogin;
@synthesize btnIsRecordAccount = _btnIsRecordAccount;
@synthesize btnCreateAccount = _btnCreateAccount;
@synthesize IsAutoLogin;
@synthesize IsRemember;

@synthesize HUD = _HUD;

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
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    IsRemember = [ud boolForKey:@"IsRemember"];
    IsAutoLogin = [ud boolForKey:@"IsAutoLogin"];
    if (IsRemember) {
        self.usernameField.text = [ud objectForKey:@"UserName"];
        self.passwordField.text = [ud objectForKey:@"Password"];
        [self.ivIsRecordAccount setImage:[UIImage imageWithName:@"login_checked" type:@"png"]];
        if(IsAutoLogin)
        {
            [self.ivIsAutoLogin setImage:[UIImage imageWithName:@"login_checked" type:@"png"]];
            [self doLogin:nil];
        }
    }else{
        self.usernameField.text = @"";
        self.passwordField.text = @"";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    float height = [UIScreen mainScreen].bounds.size.height - 20;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    
    if (textField == _usernameField) {
        self.view.frame = CGRectMake(0, -150, 320, height);
    } else if (textField == _passwordField) {
        self.view.frame = CGRectMake(0, -190, 320, height);
    }
    
    [UIView commitAnimations];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == _usernameField) {
        [_passwordField becomeFirstResponder];
    } else {
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationDelegate:self];
        
        float height = [UIScreen mainScreen].bounds.size.height - 20;
        self.view.frame = CGRectMake(0, 0, 320, height);
        
        [UIView commitAnimations];
        
        [textField resignFirstResponder];
    }
    return YES;
}

-(IBAction)doLogin:(id)sender{
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    [self.btnLogin setEnabled:NO];
    
    NSString *errMsg = [[NSString alloc]init];
    
    if([self.usernameField.text isEqualToString:@""]){
        errMsg = @"请输入帐号";
    }else if([self.passwordField.text isEqualToString:@""]){
        errMsg = @"请输入密码";
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
        
        [self.btnLogin setEnabled:YES];
        return;
    }
    
    NSString *tempusername = _usernameField.text;
    NSString *temppassword = _passwordField.text;
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    [ud setBool:IsRemember forKey:@"IsRemember"];
    if (IsRemember) {
        [ud setObject:tempusername forKey:@"UserName"];
        [ud setObject:temppassword forKey:@"Password"];
    }else{
        [ud setObject:@"" forKey:@"UserName"];
        [ud setObject:@"" forKey:@"Password"];
    }
    
    [ud setBool:IsAutoLogin forKey:@"IsAutoLogin"];
    
    AutoLogin *autoLogin = [[AutoLogin alloc] init];
    [autoLogin setDelegate:self];
    [autoLogin setUsername:tempusername];
    [autoLogin setPassword:temppassword];
    [autoLogin doAutoLogin];
    
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[_HUD removeFromSuperview];
	_HUD = nil;
}

#pragma login delegate

-(void)autoLoginStart{
    
    _HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
	_HUD.delegate = self;
    
}

-(void)autoLoginFailed:(NSString *)msg{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
//    hud.labelText = @"帐号或者密码有误，请重新登录";
    hud.labelText = msg;
    hud.margin = 10.f;
    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:2];
    
    [self.btnLogin setEnabled: YES];
    
    [_HUD setHidden:YES];
}

-(void)autoLoginSuccess{
    
    [_HUD setHidden:YES];
    
    IndexViewController *indexViewController = [[IndexViewController alloc] initWithNibName:@"IndexViewController" bundle:nil];
    [self.navigationController pushViewController:indexViewController animated:YES];
    
}

-(IBAction)resiginTextField:(id)sender{
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    
    float height = [UIScreen mainScreen].bounds.size.height - 20;
    self.view.frame = CGRectMake(0, 0, 320, height);
    
    [UIView commitAnimations];
    
    [_usernameField resignFirstResponder];
    [_passwordField resignFirstResponder];
    
}

-(IBAction)touchIsRecordAccount:(id)sender{
    if (IsRemember) {
        [self.ivIsRecordAccount setImage:[UIImage imageWithName:@"login_unchecked" type:@"png"]];
    }else{
        [self.ivIsRecordAccount setImage:[UIImage imageWithName:@"login_checked" type:@"png"]];
    }
    IsRemember = !IsRemember;
}

-(IBAction)touchIsAutoLogin:(id)sender{
    if (IsAutoLogin) {
        [self.ivIsAutoLogin setImage:[UIImage imageWithName:@"login_unchecked" type:@"png"]];
    }else{
        [self.ivIsAutoLogin setImage:[UIImage imageWithName:@"login_checked" type:@"png"]];
        if (!IsRemember) {
            [self touchIsRecordAccount:nil];
        }
    }
    IsAutoLogin = !IsAutoLogin;
}

-(IBAction)touchCreateAccount:(id)sender{
    
    RegisterViewController *registerViewController = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
    [self.navigationController pushViewController:registerViewController animated:YES];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
