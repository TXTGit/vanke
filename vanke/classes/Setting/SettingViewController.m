//
//  SettingViewController.m
//  vanke
//
//  Created by pig on 13-6-10.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "SettingViewController.h"
#import "UIImage+PImageCategory.h"
#import "VankeAPI.h"
#import "AFJSONRequestOperation.h"
#import "UserSessionManager.h"
#import "TaskViewController.h"

#import "MBProgressHUD.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

@synthesize navView = _navView;

@synthesize tempScroll = _tempScroll;
@synthesize broadView = _broadView;
@synthesize avatarImageView = _avatarImageView;
@synthesize lblTotalDistance = _lblTotalDistance;
@synthesize lblDuiHuanDistance = _lblDuiHuanDistance;

@synthesize lblMingCi = _lblMingCi;
@synthesize lblHaoYou = _lblHaoYou;
@synthesize lblNengLiang = _lblNengLiang;
@synthesize lblDeFen = _lblDeFen;

@synthesize btnJiFen = _btnJiFen;
@synthesize btnDuoBao = _btnDuoBao;
@synthesize btnDuiHuanRecord = _btnDuiHuanRecord;

@synthesize tallField = _tallField;
@synthesize weightField = _weightField;
@synthesize areaField = _areaField;
@synthesize addressField = _addressField;
@synthesize telField = _telField;

@synthesize btnSina = _btnSina;
@synthesize btnTel = _btnTel;

@synthesize memberid = _memberid;

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
    
    UIImageView *bgImageView = [[UIImageView alloc] init];
    [bgImageView setFrame:CGRectMake(0, 0, 320, height)];
    [bgImageView setImage:[UIImage imageWithName:@"setting_bg" type:@"png"]];
    [self.view addSubview:bgImageView];
    
    _broadView.frame = CGRectMake(0, 0, 320, 548);
    
    _tempScroll = [[UIScrollView alloc] init];
    _tempScroll.frame = CGRectMake(0, 0, 320, height);
    _tempScroll.scrollEnabled = YES;
    _tempScroll.contentSize = CGSizeMake(320, 548);
    _tempScroll.delegate = self;
    [_tempScroll addSubview:_broadView];
    [self.view addSubview:_tempScroll];
    
    //nav bar
    _navView = [[PCustomNavigationBarView alloc] initWithTitle:@"设置(个人)" bgImageView:@"index_nav_bg"];
    [self.view addSubview:_navView];
    
    UIImage *indexBack = [UIImage imageWithName:@"main_back" type:@"png"];
    [_navView.leftButton setBackgroundImage:indexBack forState:UIControlStateNormal];
    [_navView.leftButton setHidden:NO];
    [_navView.leftButton addTarget:self action:@selector(doBack) forControlEvents:UIControlEventTouchUpInside];
    
    long long currentMemberid = [[UserSessionManager GetInstance].currentRunUser.userid longLongValue];
     //如果是登录者进入设置，则显示保存按钮
    if (currentMemberid == _memberid) {
        UIImage *indexHeadBg = [UIImage imageWithName:@"main_head" type:@"png"];
        [_navView.rightButton setBackgroundImage:indexHeadBg forState:UIControlStateNormal];
        [_navView.rightButton setTitle:@"保存" forState:UIControlStateNormal];
        [_navView.rightButton setHidden:NO];
        [_navView.rightButton addTarget:self action:@selector(touchMenuAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.btnJiFen setEnabled:YES];
        [self.btnDuoBao setEnabled:YES];
        [self.btnDuiHuanRecord setEnabled:YES];
        
        [self.tallField setEnabled:YES];
        [self.weightField setEnabled:YES];
        [self.areaField setEnabled:YES];
        [self.addressField setEnabled:YES];
        [self.telField setEnabled:YES];
    }else{
        UIImage *indexHeadBg = [UIImage imageWithName:@"main_head" type:@"png"];
        [_navView.rightButton setBackgroundImage:indexHeadBg forState:UIControlStateNormal];
        [_navView.rightButton setTitle:@"约跑" forState:UIControlStateNormal];
        [_navView.rightButton setHidden:NO];
        [_navView.rightButton addTarget:self action:@selector(touchMenuAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.btnJiFen setEnabled:NO];
        [self.btnDuoBao setEnabled:NO];
        [self.btnDuiHuanRecord setEnabled:NO];
        
        [self.tallField setEnabled:NO];
        [self.weightField setEnabled:NO];
        [self.areaField setEnabled:NO];
        [self.addressField setEnabled:NO];
        [self.telField setEnabled:NO];
    }
    
    UIImage *messageTip = [UIImage imageWithName:@"index_button_new" type:@"png"];
    [_navView.messageTipImageView setImage:messageTip];
//    [_navView.messageTipImageView setHidden:NO];
    
    //show data
    [self initData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initData{
    
    NSString *memberUrl = [VankeAPI getGetMemberUrl:[NSString stringWithFormat:@"%ld", _memberid]];
    NSURL *url = [NSURL URLWithString:memberUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"App.net Global Stream: %@", JSON);
        NSDictionary *dicResult = JSON;
        NSString *status = [dicResult objectForKey:@"status"];
        NSLog(@"status: %@", status);
        if ([status isEqual:@"0"]) {
            
            NSDictionary *dicEnt = [dicResult objectForKey:@"ent"];
            RunUser *runner = [RunUser initWithNSDictionary:dicEnt];
            
            _tallField.text = [NSString stringWithFormat:@"%.2f", runner.tall];
            _weightField.text = [NSString stringWithFormat:@"%.2f", runner.weight];
            _areaField.text = [NSString stringWithFormat:@"%d", runner.communityid];
            _addressField.text = [NSString stringWithFormat:@"%@", runner.address];
            _telField.text = [NSString stringWithFormat:@"%@", runner.tel];
            
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"failure: %@", error);
    }];
    [operation start];
    
}

-(void)doBack{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)touchMenuAction:(id)sender{
    
    //临时保存使用
    NSLog(@"SetInfo...");
    
    long long currentMemberid = [[UserSessionManager GetInstance].currentRunUser.userid longLongValue];
    if (currentMemberid != _memberid) {
        return;
    }
    
    NSString *strMemberid = [NSString stringWithFormat:@"%ld", _memberid];
    NSString *strTall = _tallField.text;
    NSString *strWeight = _weightField.text;
    NSString *strBirthday = @"2013-06-15";
    
    if (strTall && strTall.length >= 1 && strWeight && strWeight.length >= 1) {
        
        NSString *setInfoUrl = [VankeAPI getSetInfoUrl:strMemberid height:strTall weight:strWeight birthday:strBirthday];
        NSURL *url = [NSURL URLWithString:setInfoUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSLog(@"App.net Global Stream: %@", JSON);
            NSDictionary *dicResult = JSON;
            NSString *status = [dicResult objectForKey:@"status"];
            NSLog(@"status: %@", status);
            if ([status isEqual:@"0"]) {
                NSLog(@"SetInfo successful...");
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                
                // Configure for text only and offset down
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"分享成功";
                hud.margin = 10.f;
                hud.yOffset = 0.f;
                hud.removeFromSuperViewOnHide = YES;
                
                [hud hide:YES afterDelay:3];
            }
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            NSLog(@"failure: %@", error);
        }];
        [operation start];
        
    }//end if
    
}

-(IBAction)doJiFen:(id)sender{
    
    NSLog(@"doJiFen...");
    
}

-(IBAction)doDuoBao:(id)sender{
    
    NSLog(@"doDuoBao...");
    
    TaskViewController *taskViewController = [[TaskViewController alloc] initWithNibName:@"TaskViewController" bundle:nil];
    [self.navigationController pushViewController:taskViewController animated:YES];
    
}

-(IBAction)doDuiHuan:(id)sender{
    
    NSLog(@"doDuiHuan...");
    
}

-(IBAction)doSina:(id)sender{
    
    NSLog(@"doSina...");
    
}

-(IBAction)doTel:(id)sender{
    
    NSLog(@"doTel...");
    
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

#pragma textfield delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    float height = [UIScreen mainScreen].bounds.size.height - 20;
    _tempScroll.frame = CGRectMake(0, 0, 320, height - 210);
    
    if (textField == _tallField || textField == _weightField) {
        [_tempScroll scrollRectToVisible:CGRectMake(0, 200, 320, height - 210) animated:YES];
    } else if (textField == _areaField) {
        [_tempScroll scrollRectToVisible:CGRectMake(0, 230, 320, height - 210) animated:YES];
    } else if (textField == _addressField) {
        [_tempScroll scrollRectToVisible:CGRectMake(0, 260, 320, height - 210) animated:YES];
    } else if (textField == _telField) {
        [_tempScroll scrollRectToVisible:CGRectMake(0, 290, 320, height - 210) animated:YES];
    }

    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == _tallField) {
        [_weightField becomeFirstResponder];
    } else if (textField == _weightField) {
        [_areaField becomeFirstResponder];
    } else if (textField == _areaField) {
        [_addressField becomeFirstResponder];
    } else if (textField == _addressField) {
        [_telField becomeFirstResponder];
    } else {
        
        float height = [UIScreen mainScreen].bounds.size.height - 20;
        _tempScroll.frame = CGRectMake(0, 0, 320, height);
        
        [textField resignFirstResponder];
        
    }
    
    return YES;
}

-(IBAction)resiginTextField:(id)sender{
    
    float height = [UIScreen mainScreen].bounds.size.height - 20;
    _tempScroll.frame = CGRectMake(0, 0, 320, height);
    
    [_tallField resignFirstResponder];
    [_weightField resignFirstResponder];
    [_areaField resignFirstResponder];
    [_addressField resignFirstResponder];
    [_telField resignFirstResponder];
    
}

@end
