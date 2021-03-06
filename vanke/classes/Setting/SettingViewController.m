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

#import "FriendInfo.h"
#import "ChatViewController.h"
#import "UserSessionManager.h"

#import "GTMBase64.h"
#import "AFHTTPClient.h"
#import "PCommonUtil.h"
#import "VankeConfig.h"
#import "LoginViewController.h"

#import "ScoreListViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

@synthesize navView = _navView;

@synthesize tempScroll = _tempScroll;
@synthesize broadView = _broadView;
@synthesize avatarImageView = _avatarImageView;
@synthesize btnHeadImg = _btnHeadImg;
@synthesize lblTotalDistance = _lblTotalDistance;
@synthesize lblDuiHuanDistance = _lblDuiHuanDistance;

@synthesize lblMingCi = _lblMingCi;
@synthesize lblHaoYou = _lblHaoYou;
@synthesize lblNengLiang = _lblNengLiang;
@synthesize lblDeFen = _lblDeFen;

@synthesize settingBodyMenuImageView = _settingBodyMenuImageView;

@synthesize btnJiFen = _btnJiFen;
@synthesize btnDuoBao = _btnDuoBao;
@synthesize btnDuiHuanRecord = _btnDuiHuanRecord;

@synthesize tallField = _tallField;
@synthesize lblTallDesc = _lblTallDesc;
@synthesize lblTallCM = _lblTallCM;
@synthesize weightField = _weightField;
@synthesize lblWeightDesc = _lblWeightDesc;
@synthesize lblWeightKG = _lblWeightKG;
//@synthesize areaField = _areaField;
@synthesize lblAreaDesc = _lblAreaDesc;
@synthesize lblArea = _lblArea;
@synthesize lblAddressDesc = _lblAddressDesc;
@synthesize addressField = _addressField;
@synthesize lblTelDesc = _lblTelDesc;
@synthesize telField = _telField;

@synthesize btnSina = _btnSina;
@synthesize btnTel = _btnTel;
@synthesize logoutImageView = _logoutImageView;
@synthesize btnLogout = _btnLogout;

@synthesize memberid = _memberid;
@synthesize runner = _runner;

@synthesize achtionSheet = _achtionSheet;
@synthesize currentSelectedItem = _currentSelectedItem;

@synthesize publicBgImageView = _publicBgImageView;
@synthesize lblPublic = _lblPublic;
@synthesize switchPublic = _switchPublic;
@synthesize positionBgImageView = _positionBgImageView;
@synthesize lblPosition = _lblPosition;
@synthesize switchPosition = _switchPosition;

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
    [bgImageView setFrame:CGRectMake(0, 0, 320, 551)];
    [bgImageView setImage:[UIImage imageWithName:@"login_bg" type:@"png"]];
    [self.view insertSubview:bgImageView atIndex:0];
    
    _broadView.frame = CGRectMake(0, 0, 320, 590);//688
    
    _tempScroll = [[UIScrollView alloc] init];
    _tempScroll.frame = CGRectMake(0, 0, 320, height);
    _tempScroll.scrollEnabled = YES;
    _tempScroll.contentSize = CGSizeMake(320, 590);//688
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
        UIImage *indexHeadBg = [UIImage imageWithName:@"setting_btn_save" type:@"png"];
        [_navView.rightButton setBackgroundImage:indexHeadBg forState:UIControlStateNormal];
//        [_navView.rightButton setTitle:@"保存" forState:UIControlStateNormal];
        [_navView.rightButton setHidden:NO];
        [_navView.rightButton setFrame:CGRectMake(258, 7, 56, 29)];
        [_navView.rightButton addTarget:self action:@selector(touchMenuAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.btnJiFen setEnabled:YES];
        [self.btnDuoBao setEnabled:YES];
        [self.btnDuiHuanRecord setEnabled:YES];
        
        [self.tallField setEnabled:YES];
        [self.weightField setEnabled:YES];
//        [self.areaField setEnabled:YES];
        [self.addressField setEnabled:YES];
        [self.telField setEnabled:YES];
        
    }else{
        NSString *setIsFanUrl = [VankeAPI getIsFanUrl:[UserSessionManager GetInstance].currentRunUser.userid :[NSString stringWithFormat:@"%ld",_memberid]];
        NSURL *url = [NSURL URLWithString:setIsFanUrl];
        NSLog(@"isFan:%@",setIsFanUrl);
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSLog(@"App.net Global Stream: %@", JSON);
            NSDictionary *dicResult = JSON;
            NSString *status = [dicResult objectForKey:@"status"];
            NSLog(@"status: %@", status);
            if ([status isEqual:@"0"]) {
                NSLog(@"isFan：%d",[[dicResult objectForKey:@"isFan"] intValue]);
                if ([[dicResult objectForKey:@"isFan"] intValue] == 1) {
                    UIImage *indexHeadBg = [UIImage imageWithName:@"setting_btn_chat" type:@"png"];
                    [_navView.rightButton setBackgroundImage:indexHeadBg forState:UIControlStateNormal];
//                    [_navView.rightButton setTitle:@"聊天" forState:UIControlStateNormal];
                    [_navView.rightButton setHidden:NO];
                    [_navView.rightButton setFrame:CGRectMake(258, 9, 56, 29)];
                    [_navView.rightButton addTarget:self action:@selector(doGotoChat:) forControlEvents:UIControlEventTouchUpInside];
                }else{
                    UIImage *indexHeadBg = [UIImage imageWithName:@"setting_btn_invit" type:@"png"];
                    [_navView.rightButton setBackgroundImage:indexHeadBg forState:UIControlStateNormal];
                    //        [_navView.rightButton setTitle:@"约跑" forState:UIControlStateNormal];
                    [_navView.rightButton setHidden:NO];
                    [_navView.rightButton setFrame:CGRectMake(285, 9, 24, 25)];
                    [_navView.rightButton addTarget:self action:@selector(doGotoInvite:) forControlEvents:UIControlEventTouchUpInside];
                }
            }else{
                NSString *errMsg = [dicResult objectForKey:@"msg"];
//                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
//                
//                // Configure for text only and offset down
//                hud.mode = MBProgressHUDModeText;
//                hud.labelText = errMsg;
//                hud.margin = 10.f;
//                hud.yOffset = 150.0f;
//                hud.removeFromSuperViewOnHide = YES;
//                [hud hide:YES afterDelay:2];
                [SVProgressHUD showErrorWithStatus:errMsg];
            }
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            NSLog(@"failure: %@", error);
            [SVProgressHUD showErrorWithStatus:@"网络异常,请重试"];
        }];
        [operation start];
        
        [self.btnJiFen setEnabled:NO];
        [self.btnDuoBao setEnabled:NO];
        [self.btnDuiHuanRecord setEnabled:NO];
        
        [self.tallField setEnabled:NO];
        [self.weightField setEnabled:NO];
//        [self.areaField setEnabled:NO];
        [self.addressField setEnabled:NO];
        [self.telField setEnabled:NO];
        
        //隐藏
        _settingBodyMenuImageView.hidden = YES;
        _btnJiFen.hidden = YES;
        _btnDuoBao.hidden = YES;
        _btnDuiHuanRecord.hidden = YES;
        _lblTallDesc.hidden = YES;
        _tallField.hidden = YES;
        _lblTallCM.hidden = YES;
        _lblWeightDesc.hidden = YES;
        _weightField.hidden = YES;
        _lblWeightKG.hidden = YES;
        _lblArea.hidden = YES;
        _addressField.hidden = YES;
        _telField.hidden = YES;
        _btnSina.hidden = YES;
        _btnTel.hidden = YES;
        _publicBgImageView.hidden = YES;
        _lblPublic.hidden = YES;
        _switchPublic.hidden = YES;
        _positionBgImageView.hidden = YES;
        _lblPosition.hidden = YES;
        _switchPosition.hidden = YES;
        _btnLogout.hidden = YES;
        
        _tempScroll.scrollEnabled = NO;
        
    }
    
    UIImage *messageTip = [UIImage imageWithName:@"index_button_new" type:@"png"];
    [_navView.messageTipImageView setImage:messageTip];
//    [_navView.messageTipImageView setHidden:NO];
    
    //show data
    _menuMarkImageView.hidden = YES;
    [self initData];
    [self initFont];
}

#pragma mark 初始化字体
-(void)initFont
{
    [self.lblTotalDistance setFont:MainFont(36.0f)];
    [self.lblDuiHuanDistance setFont:MainFont(13.0f)];
    [self.lblMingCi setFont:MainFont(12.0f)];
    [self.lblHaoYou setFont:MainFont(12.0f)];
    [self.lblNengLiang setFont:MainFont(12.0f)];
    [self.lblDeFen setFont:MainFont(12.0f)];
    [self.tallField setFont:MainFont(14.0f)];
    [self.weightField setFont:MainFont(14.0f)];
    [self.telField setFont:MainFont(14.0f)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if ([UserSessionManager GetInstance].isLoggedIn) {
        //已登陆
        
    }
    
}

-(void)initData{
    
    NSString *memberUrl = [VankeAPI getGetMemberDetailUrl:[NSString stringWithFormat:@"%ld", _memberid]];
    NSLog(@"memberUrl: %@", memberUrl);
    
    NSURL *url = [NSURL URLWithString:memberUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"App.net Global Stream: %@", JSON);
        NSDictionary *dicResult = JSON;
        NSString *status = [dicResult objectForKey:@"status"];
        NSLog(@"status: %@", status);
        if ([status isEqual:@"0"]) {
            
//            NSDictionary *dicEnt = [dicResult objectForKey:@"ent"];
            NSArray *entList = [dicResult objectForKey:@"ent"];
            if (entList && [entList count] > 0) {
                
                NSDictionary *dicEnt0 = [entList objectAtIndex:0];
                _runner = [RunUser initWithNSDictionary:dicEnt0];
                
                long long currentMemberid = [[UserSessionManager GetInstance].currentRunUser.userid longLongValue];
                //如果不是登录者，则Title改为用户昵称
                if (currentMemberid != _memberid) {
                    _navView.titleLabel.text = _runner.nickname;
                }
                
                NSString *imgpath = [dicResult objectForKey:@"imgPath"];
                if (_runner.headImg) {
                    _runner.headImg = [NSString stringWithFormat:@"%@%@%@", VANKE_DOMAINBase, imgpath, _runner.headImg];
                }
                
                NSLog(@"headImg: %@", _runner.headImg);
                _btnHeadImg.delegate = self;
                if (_runner.headImg) {
                    _btnHeadImg.imageURL = [NSURL URLWithString:_runner.headImg];
                }
                
                _lblTotalDistance.text = [NSString stringWithFormat:@"%.2f", _runner.mileage];
                float tempCanUseMileage = _runner.mileage - _runner.mileageUsed;
                _lblDuiHuanDistance.text = [NSString stringWithFormat:@"可兑换里程%.2fkm", tempCanUseMileage];
                
                _lblMingCi.text = [NSString stringWithFormat:@"%d", _runner.rank];
                [_lblMingCi sizeThatFits:CGSizeMake(32, 21)];
                _lblMingCiTitle.layer.position = CGPointMake(_lblMingCi.frame.origin.x + _lblMingCi.frame.size.width + 3, _lblMingCiTitle.layer.position.y);
                _lblHaoYou.text = [NSString stringWithFormat:@"%d", _runner.fanCount];
                [_lblHaoYou sizeThatFits:CGSizeMake(42, 21)];
                _lblHaoYouTitle.layer.position = CGPointMake(_lblHaoYou.frame.origin.x + _lblHaoYou.frame.size.width + 3, _lblHaoYou.layer.position.y);
                _lblNengLiang.text = [NSString stringWithFormat:@"%.2f", _runner.energy];
                [_lblNengLiang sizeThatFits:CGSizeMake(39, 21)];
                _lblNengLiangTitle.layer.position = CGPointMake(_lblNengLiang.frame.origin.x + _lblNengLiang.frame.size.width + 3, _lblNengLiang.layer.position.y);
                _lblDeFen.text = [NSString stringWithFormat:@"%ld", _runner.score];
                [_lblDeFen sizeThatFits:CGSizeMake(30, 21)];
                _lblJiFenTitle.layer.position = CGPointMake(_lblDeFen.frame.origin.x + _lblDeFen.frame.size.width + 3, _lblDeFen.layer.position.y);
                
                _tallField.text = [NSString stringWithFormat:@"%.2f", _runner.tall];
                _weightField.text = [NSString stringWithFormat:@"%.2f", _runner.weight];
                _lblArea.text = _runner.communityName;
                _addressField.text = _runner.gpsAddress;
                _telField.text = _runner.tel;//_runner.tel;
                
                if (_runner.isPublic > 0) {
                    [_switchPublic setOn:YES animated:YES];
                    [self showAllInfo];
                } else {
                    [_switchPublic setOn:NO animated:YES];
                }
                
                if (_runner.isPosition > 0) {
                    [_switchPosition setOn:YES animated:YES];
                } else {
                    [_switchPosition setOn:NO animated:YES];
                }
                //如果是登录者，则更新Session内容
                if (currentMemberid == _memberid) {
                    [UserSessionManager GetInstance].currentRunUser = _runner;
                }
            }else{
                NSString *errMsg = [dicResult objectForKey:@"msg"];
//                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
//                
//                // Configure for text only and offset down
//                hud.mode = MBProgressHUDModeText;
//                hud.labelText = errMsg;
//                hud.margin = 10.f;
//                hud.yOffset = 150.0f;
//                hud.removeFromSuperViewOnHide = YES;
//                [hud hide:YES afterDelay:2];
                [SVProgressHUD showErrorWithStatus:errMsg];
            }
            
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"failure: %@", error);
        [SVProgressHUD showErrorWithStatus:@"网络异常,请重试"];
    }];
    [operation start];
}

#pragma mark 公开个人信息
-(void)showAllInfo
{
    _settingBodyMenuImageView.hidden = NO;
    _btnJiFen.hidden = NO;
    _btnDuoBao.hidden = NO;
    _btnDuiHuanRecord.hidden = NO;
    _lblTallDesc.hidden = NO;
    _tallField.hidden = NO;
    _lblTallCM.hidden = NO;
    _lblWeightDesc.hidden = NO;
    _weightField.hidden = NO;
    _lblWeightKG.hidden = NO;
    _lblArea.hidden = NO;
    _addressField.hidden = NO;
    _telField.hidden = NO;
    
    if (_memberid != [[UserSessionManager GetInstance].currentRunUser.userid longLongValue]) {
        _menuMarkImageView.hidden = NO;
    } else {
        _menuMarkImageView.hidden = YES;
    }
    
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
    if ([UserSessionManager GetInstance].currentRunUser.birthday) {
        strBirthday = [UserSessionManager GetInstance].currentRunUser.birthday;
    }
    
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
                if (!changeHeadImg) {
                    [SVProgressHUD showSuccessWithStatus:@"保存成功"];
                    [self initData];
                }
            }else{
                NSString *errMsg = [dicResult objectForKey:@"msg"];
                [SVProgressHUD showErrorWithStatus:errMsg];
            }
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            NSLog(@"failure: %@", error);
            [SVProgressHUD showErrorWithStatus:@"网络异常,请重试"];
        }];
        [operation start];
        
    }//end if
    if (changeHeadImg) {
        
        /*
        //处理头像，增加白色圆圈 20130712
        UIImage *srcHeadImage = self.btnHeadImg.imageView.image;
        NSLog(@"srcHeadImage.size.width: %f, srcHeadImage.size.height: %f", srcHeadImage.size.width, srcHeadImage.size.height);
        
        UIImage *srcWhiteCircle = [UIImage imageWithName:@"white_circle" type:@"png"];
        UIImage *tempWhiteCircle = [UIImage scaleImage:srcWhiteCircle scaleToSize:srcHeadImage.size];
        UIImage *avatarImage = [PCommonUtil mergerImage:srcHeadImage secodImage:tempWhiteCircle];
        
        NSDate *nowDate = [NSDate date];
        long forImageName = [nowDate timeIntervalSince1970];
        NSString *path = [NSHomeDirectory() stringByAppendingFormat:@"/%ld.png", forImageName];
        if ([UIImagePNGRepresentation(avatarImage) writeToFile:path atomically:YES]) {
            NSLog(@"Successful...");
        } else {
            NSLog(@"failure...");
        }

        NSData *headData = UIImagePNGRepresentation(avatarImage);
        */
        
        [SVProgressHUD showWithStatus:@"头像上传中"];
        
        NSData *headData = UIImagePNGRepresentation(self.btnHeadImg.imageView.image);
        NSString *base64data = [[NSString alloc] initWithData:[GTMBase64 encodeData:headData] encoding:NSUTF8StringEncoding];
        
//        NSLog(@"base64data: %@", base64data);
        
        NSString *uploadImageUrl = [VankeAPI getSetHeadImgUrl:strMemberid];
        
        NSDictionary *dicParam = [NSDictionary dictionaryWithObjectsAndKeys:base64data, @"headImg", nil];
        NSURL *url = [NSURL URLWithString:uploadImageUrl];
        
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
        NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:nil parameters:dicParam constructingBodyWithBlock:nil];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSLog(@"App.net Global Stream: %@", JSON);
            NSDictionary *dicResult = JSON;
            NSString *status = [dicResult objectForKey:@"status"];
            NSString *msg = [dicResult objectForKey:@"msg"];
            NSLog(@"status: %@, msg: %@", status, msg);
            if ([status isEqual:@"0"]) {
                [SVProgressHUD showSuccessWithStatus:@"保存成功"];
                changeHeadImg = NO;
                [self initData];
            }
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            NSLog(@"failure: %@", error);
            [SVProgressHUD showErrorWithStatus:@"网络异常,请重试"];
        }];
        
        [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
        }];
        
        [operation start];
    }
    
    //设置位置是否公开，个人信息是否公开
    [self doSettingPublicAndPosition];
    
}

-(void)doSettingPublicAndPosition{
    
    NSString *memberid = [UserSessionManager GetInstance].currentRunUser.userid;
    int temppublic = 0;
    if (_switchPublic.isOn) {
        temppublic = 1;
    }
    int tempposition = 0;
    if (_switchPosition.isOn) {
        tempposition = 1;
    }
    
    NSString *setInfoUrl = [VankeAPI getSettingUrl:memberid isPublic:temppublic isPosition:tempposition];
    NSURL *url = [NSURL URLWithString:setInfoUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"doSettingPublicAndPosition: %@", JSON);
        NSDictionary *dicResult = JSON;
        NSString *status = [dicResult objectForKey:@"status"];
        NSLog(@"status: %@", status);
        if ([status isEqual:@"0"]) {
            
            NSLog(@"SetInfo successful...");
            
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"failure: %@", error);
        [SVProgressHUD showErrorWithStatus:@"网络异常,请重试"];
    }];
    [operation start];
    
}

-(void)doGotoInvite:(id)sender{
    NSLog(@"doGotoInvite...");
    
//    FriendInfo *friendinfo = [[FriendInfo alloc]init];
//    friendinfo.fromMemberID = [_runner.userid longLongValue];
//    
//    ChatViewController *chatViewController = [[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil];
//    [chatViewController setFriendInfo:friendinfo];
//    [chatViewController setChatType:chatTypeInvite];
//    [self.navigationController pushViewController:chatViewController animated:YES];
    
    //直接发送好友邀请，邀请内容为：一起跑步好吗？
    NSString *msgText = @"一起跑步好吗？";
    
    NSString *memberid = [UserSessionManager GetInstance].currentRunUser.userid;
    NSString *tomemberid = [NSString stringWithFormat:@"%ld",_memberid];
    NSString *msgListUrl = [VankeAPI getSendInviteUrl:memberid toMemberId:tomemberid msgText:msgText];
    
    NSURL *url = [NSURL URLWithString:msgListUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"App.net Global Stream: %@", JSON);
        NSDictionary *dicResult = JSON;
        NSString *status = [dicResult objectForKey:@"status"];
        NSLog(@"status: %@", status);
        if ([status isEqual:@"0"]) {
//            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
//            
//            // Configure for text only and offset down
//            hud.mode = MBProgressHUDModeText;
//            hud.labelText = @"您已成功发送好友邀请！";
//            hud.margin = 10.f;
//            hud.yOffset = 150.0f;
//            hud.removeFromSuperViewOnHide = YES;
//            [hud hide:YES afterDelay:2];
            [SVProgressHUD showSuccessWithStatus:@"您已成功发送好友邀请！"];
        }else{
            NSString *errMsg = [dicResult objectForKey:@"msg"];
//            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
//            
//            // Configure for text only and offset down
//            hud.mode = MBProgressHUDModeText;
//            hud.labelText = errMsg;
//            hud.margin = 10.f;
//            hud.yOffset = 150.0f;
//            hud.removeFromSuperViewOnHide = YES;
//            [hud hide:YES afterDelay:2];
            [SVProgressHUD showErrorWithStatus:errMsg];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"failure: %@", error);
        [SVProgressHUD showErrorWithStatus:@"网络异常,请重试"];
    }];
    [operation start];
}

-(void)doGotoChat:(id)sender{
    NSLog(@"doGotoChat...");
    
    FriendInfo *friendinfo = [[FriendInfo alloc]init];
    friendinfo.fromMemberID = [_runner.userid longLongValue];
    
    ChatViewController *chatViewController = [[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil];
    [chatViewController setFriendInfo:friendinfo];
    [chatViewController setChatType:chatTypeDefault];
    [self.navigationController pushViewController:chatViewController animated:YES];
}

-(IBAction)doJiFen:(id)sender{
    
    NSLog(@"doJiFen...");
    
    _currentSelectedItem = 1;
    
    _achtionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    [_achtionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, 320, 150)];
    [pickerView setBackgroundColor:[UIColor blueColor]];
    pickerView.tag = 101;
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.showsSelectionIndicator = YES;
    
    [_achtionSheet addSubview:pickerView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 12, 180, 30)];
    [label setText:@"2公里兑换1分，每日最多兑换5分"];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setFont:[UIFont systemFontOfSize:12.0f]];
    [label setTextColor:[UIColor whiteColor]];
    [_achtionSheet addSubview:label];
    
    UISegmentedControl *button = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"完成", nil]];
    [button setSegmentedControlStyle:UISegmentedControlStyleBar];
    [button setFrame:CGRectMake(270, 12, 50, 30)];
    [button addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    [_achtionSheet addSubview:button];
    
    UISegmentedControl *cancellButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"取消", nil]];
    [cancellButton setSegmentedControlStyle:UISegmentedControlStyleBar];
    [cancellButton setFrame:CGRectMake(208, 12, 50, 30)];
    [cancellButton addTarget:self action:@selector(cancellAction) forControlEvents:UIControlEventValueChanged];
    [_achtionSheet addSubview:cancellButton];
    
    [_achtionSheet showInView:self.view];
    [_achtionSheet setBounds:CGRectMake(0, 0, 320, 400)];
    [_achtionSheet setBackgroundColor:[UIColor whiteColor]];
    
}

-(void)cancellAction
{
    [_achtionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

-(void)segmentAction:(UISegmentedControl *)seg{
    NSInteger index = seg.selectedSegmentIndex;
    NSLog(@"index: %d, currentSelectedItem: %d", index, _currentSelectedItem);
    [_achtionSheet dismissWithClickedButtonIndex:index animated:YES];
    
    if (_runner) {
        int duihuanMileage = _runner.mileage - _runner.mileageUsed;
        if (duihuanMileage < 2 * _currentSelectedItem) {
            
//            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
//            
//            // Configure for text only and offset down
//            hud.mode = MBProgressHUDModeText;
//            hud.labelText = @"您的可兑换里程不足";
//            hud.margin = 10.f;
//            hud.yOffset = 150.0f;
//            hud.removeFromSuperViewOnHide = YES;
//            [hud hide:YES afterDelay:2];
            [SVProgressHUD showErrorWithStatus:@"您的可兑换里程不足"];
            
            return;
        }
        
    }
    
    [self doAddScore:_currentSelectedItem];
}

-(void)doAddScore:(int)tscore{
    
    NSLog(@"doAddScore...");
    
    NSString *memberid = [UserSessionManager GetInstance].currentRunUser.userid;
    NSString *addScoreUrl = [VankeAPI getAddScoreUrl:memberid score:tscore];
    NSURL *url = [NSURL URLWithString:addScoreUrl];
    NSLog(@"addScoreUrl: %@",url);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"App.net Global Stream: %@", JSON);
        NSDictionary *dicResult = JSON;
        NSString *status = [dicResult objectForKey:@"status"];
        NSLog(@"status: %@", status);
        if ([status isEqual:@"0"]) {
            
            //刷新数据
            [self initData];
            
//            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
//            
//            // Configure for text only and offset down
//            hud.mode = MBProgressHUDModeText;
//            hud.labelText = @"兑换成功";
//            hud.margin = 10.f;
//            hud.yOffset = 150.0f;
//            hud.removeFromSuperViewOnHide = YES;
//            [hud hide:YES afterDelay:2];
            [SVProgressHUD showSuccessWithStatus:@"兑换成功"];
            
        }else{
            NSString *errMsg = [dicResult objectForKey:@"msg"];
//            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
//            
//            // Configure for text only and offset down
//            hud.mode = MBProgressHUDModeText;
//            hud.labelText = errMsg;
//            hud.margin = 10.f;
//            hud.yOffset = 150.0f;
//            hud.removeFromSuperViewOnHide = YES;
//            [hud hide:YES afterDelay:2];
            [SVProgressHUD showErrorWithStatus:errMsg];
        }
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"failure: %@", error);
        [SVProgressHUD showErrorWithStatus:@"网络异常,请重试"];
        
    }];
    [operation start];
    
}

#pragma delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSLog(@"actionSheet clickedButtonAtIndex...");
    
}

#pragma delegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 5;//1-5分,5个选项
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [NSString stringWithFormat:@"%d", (row + 1)];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    _currentSelectedItem = row + 1;
    
}

-(IBAction)doDuoBao:(id)sender{
    
    NSLog(@"doDuoBao...");
    
    TaskViewController *taskViewController = [[TaskViewController alloc] initWithNibName:@"TaskViewController" bundle:nil];
    [self.navigationController pushViewController:taskViewController animated:YES];
    
}

-(IBAction)doDuiHuan:(id)sender{
    
    NSLog(@"doDuiHuan...");
    
    ScoreListViewController *scoreListViewController = [[ScoreListViewController alloc] initWithNibName:@"ScoreListViewController" bundle:nil];
    [self.navigationController pushViewController:scoreListViewController animated:YES];
    
}

-(IBAction)doSina:(id)sender{
    
    NSLog(@"doSina...");
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if ([ud boolForKey:@"BindSina"]) {
        [ud setBool:NO forKey:@"BindSina"];
        [ud synchronize];
    } else {
        [ud setBool:YES forKey:@"BindSina"];
        [ud synchronize];
    }
    
}

-(IBAction)doTel:(id)sender{
    
    NSLog(@"doTel...");
    
}

-(IBAction)doLogout:(id)sender{
    
    NSLog(@"doLogout...");
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:NO forKey:@"IsAutoLogin"];
    
    //清除Session中用户信息
//    UserSessionManager = nil;
    [UserSessionManager CleanInstance];
    
    LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [self.navigationController pushViewController:loginViewController animated:YES];
    
}

-(IBAction)doSelectHeadImg:(id)sender
{
    NSLog(@"doSelectHeadImg...");
    
    long long currentMemberid = [[UserSessionManager GetInstance].currentRunUser.userid longLongValue];
    //如果是登录者进入设置，则显示保存按钮
    if (currentMemberid != _memberid) {
        return;
    }
    
    UIImagePickerController *pc = [[UIImagePickerController alloc]init];
    pc.delegate = self;
    pc.allowsEditing = YES;
    
    //pc.allowsImageEditing = NO;
    
    pc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentModalViewController:pc animated:YES];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *imageNew = [UIImage createRoundedRectImage:image size:CGSizeMake(100, 100) radius:50];
//    UIImage *imageNew = [UIImage scaleImage:image scaleToSize:CGSizeMake(100, 100)];
//    UIImage *maskImage = [UIImage imageWithName:@"header_mask" type:@"png"];
//    UIImage *resultImage = [PCommonUtil maskImage:imageNew withImage:maskImage];
    
//    UIImage *redCircleImage = [UIImage imageWithName:@"header_red_circle" type:@"png"];
//    UIImage *resultImage = [self mergerImage:imageNew secodImage:redCircleImage];
    [self.btnHeadImg setImage:imageNew forState:UIControlStateNormal];
    
    [picker dismissModalViewControllerAnimated:YES];
    changeHeadImg = YES;
}

//合并图片
-(UIImage *)mergerImage:(UIImage *)firstImage secodImage:(UIImage *)secondImage{
    
    CGSize imageSize = CGSizeMake(200, 200);
    UIGraphicsBeginImageContext(imageSize);
    
    [firstImage drawInRect:CGRectMake(0, 0, firstImage.size.width, firstImage.size.height)];
    [secondImage drawInRect:CGRectMake(0, 0, secondImage.size.width, secondImage.size.height)];
    
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
}

//-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
//{
//    [[UIApplication sharedApplication].keyWindow endEditing:YES];
//}

#pragma textfield delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    float height = [UIScreen mainScreen].bounds.size.height - 20;
    _tempScroll.frame = CGRectMake(0, 0, 320, height - 210);
    
    if (textField == _tallField || textField == _weightField) {
        [_tempScroll scrollRectToVisible:CGRectMake(0, 200, 320, height - 210) animated:YES];
    } else if (textField == _addressField) {
        [_tempScroll scrollRectToVisible:CGRectMake(0, 260, 320, height - 210) animated:YES];
    } else if (textField == _telField) {
        [_tempScroll scrollRectToVisible:CGRectMake(0, 290, 320, height - 210) animated:YES];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    float height = [UIScreen mainScreen].bounds.size.height - 20;
//    _tempScroll.frame = CGRectMake(0, 0, 320, height);
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == _tallField) {
        [_weightField becomeFirstResponder];
    } else if (textField == _weightField) {
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
    [_addressField resignFirstResponder];
    [_telField resignFirstResponder];
    
}

-(IBAction)doPublicSwitchAction:(id)sender{
    
    NSLog(@"doPublicSwitchAction...");
    
    UISwitch *tempswitch = sender;
    BOOL isButtonOn = [tempswitch isOn];
    if (isButtonOn) {
        //
    }
    
}

-(IBAction)doPositionSwitchAction:(id)sender{
    
    NSLog(@"doPositionSwitchAction...");
    
}

- (void)viewDidUnload {
    [self setBtnHeadImg:nil];
    [self setLblMingCiTitle:nil];
    [self setLblHaoYouTitle:nil];
    [self setLblNengLiangTitle:nil];
    [self setLblJiFenTitle:nil];
    [super viewDidUnload];
}

#pragma EGOImageButtonDelegate

- (void)imageButtonLoadedImage:(EGOImageButton*)imageButton{
    
    NSLog(@"imageButtonLoadedImage...");
    
    UIImage *image = [imageButton imageForState:UIControlStateNormal];
//    UIImage *maskImage = [UIImage imageWithName:@"header_mask" type:@"png"];
//    UIImage *resultImage = [PCommonUtil maskImage:image withImage:maskImage];
//    UIImage *redCircleImage = [UIImage imageWithName:@"header_red_circle" type:@"png"];
//    UIImage *resultImage = [self mergerImage:image secodImage:redCircleImage];
    [imageButton setImage:image forState:UIControlStateNormal];
}

- (void)imageButtonFailedToLoadImage:(EGOImageButton*)imageButton error:(NSError*)error{
    
    NSLog(@"imageButtonFailedToLoadImage. error: %@", error);
    
    UIImage *avatarImage = [UIImage imageWithName:@"setting_header_bg_avatar" type:@"png"];
    [imageButton setImage:avatarImage forState:UIControlStateNormal];
}

@end
