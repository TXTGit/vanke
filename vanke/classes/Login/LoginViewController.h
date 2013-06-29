//
//  LoginViewController.h
//  vanke
//
//  Created by pig on 13-6-9.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AutoLogin.h"
#import "MBProgressHUD.h"

@interface LoginViewController : UIViewController<UITextFieldDelegate, AutoLoginDelegate, MBProgressHUDDelegate>
{
    BOOL IsRemember;
    BOOL IsAutoLogin;
}

@property (nonatomic, retain) IBOutlet UITextField *usernameField;
@property (nonatomic, retain) IBOutlet UITextField *passwordField;
@property (nonatomic, retain) IBOutlet UIButton *btnLogin;
@property (nonatomic, retain) IBOutlet UIButton *btnUse;
@property (nonatomic, retain) IBOutlet UIImageView *ivIsRecordAccount;
@property (nonatomic, retain) IBOutlet UIButton *btnIsRecordAccount;
@property (nonatomic, retain) IBOutlet UIImageView *ivIsAutoLogin;
@property (nonatomic, retain) IBOutlet UIButton *btnIsAutoLogin;
@property (nonatomic, retain) IBOutlet UIButton *btnCreateAccount;

@property (nonatomic, retain) MBProgressHUD *HUD;

-(IBAction)doLogin:(id)sender;
-(IBAction)doUse:(id)sender;
-(IBAction)resiginTextField:(id)sender;
-(IBAction)touchIsRecordAccount:(id)sender;
-(IBAction)touchIsAutoLogin:(id)sender;
-(IBAction)touchCreateAccount:(id)sender;

@end
