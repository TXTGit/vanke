//
//  RegisterViewController.h
//  vanke
//
//  Created by pig on 13-6-10.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCustomNavigationBarView.h"
#import "RunUser.h"

@interface RegisterViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic, retain) PCustomNavigationBarView *navView;

@property (nonatomic, retain) UIScrollView *tempScroll;
@property (nonatomic, retain) IBOutlet UIView *broadView;
@property (nonatomic, retain) IBOutlet UITextField *nicknameField;
@property (nonatomic, retain) IBOutlet UITextField *passwordField;
@property (nonatomic, retain) IBOutlet UITextField *realnameField;
@property (nonatomic, retain) IBOutlet UITextField *idcardField;
@property (nonatomic, retain) IBOutlet UITextField *telField;
@property (nonatomic, retain) IBOutlet UIButton *btnNext;

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicatorView;

-(void)doBack;
-(IBAction)resiginTextField:(id)sender;
-(IBAction)doNext:(id)sender;
-(void)doRegister:(RunUser *)runner;

@end
