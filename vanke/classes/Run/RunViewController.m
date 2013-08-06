//
//  RunViewController.m
//  vanke
//
//  Created by pig on 13-6-10.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "RunViewController.h"
#import "UIImage+PImageCategory.h"
#import <MediaPlayer/MediaPlayer.h>
#import "RunResultViewController.h"
#import "RunRecordListViewController.h"
#import "NoticeViewController.h"
#import "ChatViewController.h"
#import "SettingViewController.h"
#import "PCommonUtil.h"
#import "UserSessionManager.h"
#import "LBSViewController.h"
#import "TaskViewController.h"
#import "VankeAPI.h"
#import "AFJSONRequestOperation.h"
#import "Song.h"
#import "MBProgressHUD.h"
#import "RunInfoOfWeek.h"
#import "ChatlistViewController.h"
#import "AppDelegate.h"

#define RECORD_RUN_DATA_INTERVAL 60.0

#define StopRunAlertTag 100

@interface RunViewController ()

@end

@implementation RunViewController

@synthesize mapView = _mapView;

@synthesize navView = _navView;

@synthesize menuOfHeadView = _menuOfHeadView;
@synthesize menuOfCustomWindow = _menuOfCustomWindow;

@synthesize runMenuView = _runMenuView;
@synthesize btnMenu = _btnMenu;

@synthesize ivRunProcess = _ivRunProcess;
@synthesize ivCircleProcess = _ivCircleProcess;
@synthesize ivRunProcessPoint = _ivRunProcessPoint;
@synthesize btnStart = _btnStart;
@synthesize runningTimer = _runningTimer;
@synthesize isRunning = _isRunning;
@synthesize lblRunDistance = _lblRunDistance;
@synthesize nStartTime = _nStartTime;
@synthesize sqlitePath = _sqlitePath;
@synthesize database = _database;
@synthesize lastLocation = _lastLocation;
@synthesize currentLocation = _currentLocation;
@synthesize nRuningOneTimeId = _nRuningOneTimeId;
@synthesize nDistance = _nDistance;
@synthesize nTotalDistance = _nTotalDistance;

@synthesize nLastRecordTime = _nLastRecordTime;

@synthesize runingDataBgImageView = _runingDataBgImageView;
@synthesize lblCalorie = _lblCalorie;
@synthesize lblRunCount = _lblRunCount;
@synthesize lblSpead = _lblSpead;

@synthesize ivRunRecordOfWeek = _ivRunRecordOfWeek;

@synthesize btnDownUpArrow = _btnDownUpArrow;
@synthesize isRecordShowing = _isRecordShowing;
@synthesize lblMonday = _lblMonday;
@synthesize lblTuesday = _lblTuesday;
@synthesize lblWednesday = _lblWednesday;
@synthesize lblThursday = _lblThursday;
@synthesize lblFriday = _lblFriday;
@synthesize lblSaturday = _lblSaturday;
@synthesize lblSunday = _lblSunday;

@synthesize aaplayer = _aaplayer;

@synthesize isMenuOfBottomShowing = _isMenuOfBottomShowing;

@synthesize locationList = _locationList;

@synthesize btnMenuFirst = _btnMenuFirst;
@synthesize btnMenuSecond = _btnMenuSecond;
@synthesize btnMenuThird = _btnMenuThird;
@synthesize btnMenuFourth = _btnMenuFourth;
@synthesize btnMenuCenter = _btnMenuCenter;
@synthesize ivMenuBg = _ivMenuBg;

@synthesize menuBottomView = _menuBottomView;

@synthesize musicPlayerControllerView = _musicPlayerControllerView; //new view

@synthesize locationSongList = _locationSongList;
@synthesize currentSongIndex = _currentSongIndex;
@synthesize player = _player;
@synthesize mediaPickerController = _mediaPickerController;
@synthesize totalSongDuration = _totalSongDuration;

@synthesize weekRunList = _weekRunList;

@synthesize errorAlert = _errorAlert;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _isRecordShowing = YES;
        _isRunning = NO;
        _isMenuOfBottomShowing = NO;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    float height = [UIScreen mainScreen].bounds.size.height - 20;
    
    //nav bar
    _navView = [[PCustomNavigationBarView alloc] initWithTitle:[UserSessionManager GetInstance].currentRunUser.nickname bgImageView:@"index_nav_bg"];
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
    
    //menu of head
    UIView *transparentByForMenu = [[UIView alloc] init];
    transparentByForMenu.frame = CGRectMake(0, 0, 320, height);
    UITapGestureRecognizer *tapViewForMenu = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchOutOfMenuAction:)];
    tapViewForMenu.cancelsTouchesInView = NO;
    [transparentByForMenu addGestureRecognizer:tapViewForMenu];
    
    _menuOfHeadView = [[PDropdownMenuView alloc] initDropdownMenuOfHead:CGRectMake(270, 70, 57, 210)];
    [transparentByForMenu addSubview:_menuOfHeadView];
    _menuOfCustomWindow = [[CustomWindow alloc] initWithView:transparentByForMenu];
    
    //menu of head 1
    [_menuOfHeadView.btnMenu1 addTarget:self action:@selector(doBack) forControlEvents:UIControlEventTouchUpInside];
    [_menuOfHeadView.btnMenu2 addTarget:self action:@selector(touchChatAction:) forControlEvents:UIControlEventTouchUpInside];
    [_menuOfHeadView.btnMenu3 addTarget:self action:@selector(touchNoticeAction:) forControlEvents:UIControlEventTouchUpInside];
    [_menuOfHeadView.btnMenu4 addTarget:self action:@selector(touchSettingAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //process
    [self updateRunningProcessByDistance:1];
    
    //new music player
    _musicPlayerControllerView = [[PMusicPlayerControllerView alloc] initMusicPlayerController:CGRectMake(0, 350, 320, 100)];
    _musicPlayerControllerView.hidden = YES;
    _musicPlayerControllerView.sliderMusicProcess.hidden = YES;
    
    [_musicPlayerControllerView.btnStart addTarget:self action:@selector(pauseOrPlay) forControlEvents:UIControlEventTouchUpInside];
    [_musicPlayerControllerView.btnLast addTarget:self action:@selector(playLast) forControlEvents:UIControlEventTouchUpInside];
    [_musicPlayerControllerView.btnNext addTarget:self action:@selector(playNext) forControlEvents:UIControlEventTouchUpInside];
    [_musicPlayerControllerView.btnMusic addTarget:self action:@selector(pickerIPodLib) forControlEvents:UIControlEventTouchUpInside];
    [_musicPlayerControllerView.btnSound addTarget:self action:@selector(showVolume) forControlEvents:UIControlEventTouchUpInside];
    [_musicPlayerControllerView.sliderVolume addTarget:self action:@selector(volumeSet:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:_musicPlayerControllerView];
//    [self.view insertSubview:_musicPlayerControllerView belowSubview:_menuBottomView];
    
    _locationSongList = [[NSMutableArray alloc] init];
    _currentSongIndex = 0;
    
    //bottom
    self.ivMenuBg.hidden = YES;
    self.btnMenuFirst.hidden = YES;
    self.btnMenuSecond.hidden = YES;
    self.btnMenuThird.hidden = YES;
    self.btnMenuFourth.hidden = YES;
    
    [self.btnMenuCenter addTarget:self action:@selector(touchCenterMenuOfBottom:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnMenuFirst addTarget:self action:@selector(touchFirstMenuOfBottom:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnMenuSecond addTarget:self action:@selector(touchSecondMenuOfBottom:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnMenuThird addTarget:self action:@selector(touchThirdMenuOfBottom:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnMenuFourth addTarget:self action:@selector(touchFourthMenuOfBottom:) forControlEvents:UIControlEventTouchUpInside];
    
    //
    _weekRunList = [[NSMutableArray alloc] init];
    [self doShowOrHideRunRecord:_btnDownUpArrow];
    
    //song in phone
    [self getSongListInPhone];
    
    //aaplayer
    [self initAndStartPlayer];
    
    //
    [self initLocalDatabase];
    
    _locationList = [[NSMutableArray alloc] init];
    
    [self initFont];
}

#pragma mark 初始化字体
-(void)initFont
{
    [self.lblRunDistance setFont:MainFont(17.0f)];
    [self.lblCalorie setFont:MainFont(16.0f)];
    [self.lblRunCount setFont:MainFont(16.0f)];
    [self.lblSpead setFont:MainFont(16.0f)];
    [self.lblMonday setFont:MainFont(10.0f)];
    [self.lblTuesday setFont:MainFont(10.0f)];
    [self.lblWednesday setFont:MainFont(10.0f)];
    [self.lblThursday setFont:MainFont(10.0f)];
    [self.lblFriday setFont:MainFont(10.0f)];
    [self.lblSaturday setFont:MainFont(10.f)];
    [self.lblSunday setFont:MainFont(10.0f)];
}

//是否第一次进入,提示设置身高体重
//修改为如果身高体重小于10，则提醒设置身高体重
-(void)firstEnterRunningShowTip{
    if (![[UserSessionManager GetInstance].currentRunUser.nickname isEqualToString:@""] && ([UserSessionManager GetInstance].currentRunUser.tall<10 || [UserSessionManager GetInstance].currentRunUser.weight<10)) {
        if (!_settingAlert) {
            _settingAlert = [[UIAlertView alloc] initWithTitle:nil message:@"请先设置身高和体重哦" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        }
        [_settingAlert show];
    }
//    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//    if (![ud boolForKey:@"FirstEnterRunning"]) {
//        
//        [ud setBool:YES forKey:@"FirstEnterRunning"];
//        
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请先设置身高和体重哦" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        [alertView show];
//        
//    }
    
}

#pragma uialertview delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSLog(@"buttonIndex: %d", buttonIndex);
    if (alertView.tag==StopRunAlertTag) {
        if (buttonIndex==1) {
            [self stopRun];
        }
    }else if(alertView != _errorAlert)
    {
        if (1 == buttonIndex) {
            [self touchSettingAction:nil];
        }
    }
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    if (!_isRunning) {
        _musicPlayerControllerView.hidden = YES;
        //更新显示内容背景图片
        _runingDataBgImageView.image = [UIImage imageWithName:@"run_his" type:@"png"];
        
        //圆盘进度
        [self updateRunningProcessByDistance:1];
        
        //获取用户个人数据
        [self getMemberDetailInfo:[UserSessionManager GetInstance].currentRunUser.userid];
        
    } else {
        
        //更新显示内容背景图片
        _runingDataBgImageView.image = [UIImage imageWithName:@"run_his_running" type:@"png"];
        //跑步时间
        long currentRecordTime = [[NSDate date] timeIntervalSince1970];
        long tempShowRunningTime = currentRecordTime - _nStartTime;
//        _lblRunCount.text = [NSString stringWithFormat:@"%ld", tempShowRunningTime / 60];
        
        NSString *temphh = [NSString stringWithFormat:@"%ld", tempShowRunningTime / 3600];
        if (temphh.length == 1) {
            temphh = [NSString stringWithFormat:@"0%@", temphh];
        }
        
        NSString *tempmm = [NSString stringWithFormat:@"%ld", (tempShowRunningTime / 60) % 60];
        if (tempmm.length == 1) {
            tempmm = [NSString stringWithFormat:@"0%@", tempmm];
        }
        
        NSString *tempss = [NSString stringWithFormat:@"%ld", tempShowRunningTime % 60];
        if (tempss.length == 1) {
            tempss = [NSString stringWithFormat:@"0%@", tempss];
        }
        _lblRunCount.text = [NSString stringWithFormat:@"%@:%@:%@", temphh, tempmm, tempss];
        
    }
    
    //刷新一周记录
    [self getWeekRunRecordList];
    
    //百度
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    
    //Once the view has loaded then we can register to begin recieving controls and we can become the first responder
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    
    //进入后等3秒判断是否设置了身高体重，先等服务器的数据返回。
    [self performSelector:@selector(firstEnterRunningShowTip) withObject:nil afterDelay:3.0f];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //更新未读提醒
    [[AppDelegate App] getUnreadList];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    
    //End recieving events
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
    
    [_settingAlert setDelegate:nil];
    _settingAlert = nil;
}

-(BOOL)canBecomeFirstResponder{
    return YES;
}

-(void)remoteControlReceivedWithEvent:(UIEvent *)event{
    
    //if it is a remote control event handle it correctly
    if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlTogglePlayPause:
            {
                NSLog(@"UIEventSubtypeRemoteControlTogglePlayPause...");
                [self pauseOrPlay];
                break;
            }
            case UIEventSubtypeRemoteControlPlay:
            {
                NSLog(@"UIEventSubtypeRemoteControlPlay...");
                break;
            }
            case UIEventSubtypeRemoteControlPause:
            {
                NSLog(@"UIEventSubtypeRemoteControlPause...");
                break;
            }
            case UIEventSubtypeRemoteControlStop:
            {
                NSLog(@"UIEventSubtypeRemoteControlStop...");
                break;
            }
            case UIEventSubtypeRemoteControlNextTrack:
            {
                NSLog(@"UIEventSubtypeRemoteControlNextTrack...");
                break;
            }
            case UIEventSubtypeRemoteControlPreviousTrack:
            {
                NSLog(@"UIEventSubtypeRemoteControlPreviousTrack...");
                break;
            }
            default:
                break;
        }
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//初始化数据
-(void)initLocalDatabase{
    
    NSString *docsdir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    _sqlitePath = [docsdir stringByAppendingPathComponent:@"user.sqlite"];
    NSLog(@"_sqlitePath: %@", _sqlitePath);
    _database = [FMDatabase databaseWithPath:_sqlitePath];
    
    [_database open];
    [_database executeUpdate:@"create table if not exists RUN_RECORD_DATA (dataid integer, runtime integer, oldlatitude text, oldlongitude text, newlatitude text, newlongitude text, distance integer, speed integer, datacreatetime integer, runingOneTimeId integer)"];
    [_database close];
    
}

//获取用户的个人数据纪录
-(void)getMemberDetailInfo:(NSString *)memberid{
    
    NSString *memberDetailUrl = [VankeAPI getGetMemberDetailUrl:memberid];
    NSLog(@"memberDetailUrl: %@",memberDetailUrl);
    NSURL *url = [NSURL URLWithString:memberDetailUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"App.net Global Stream: %@", JSON);
        NSDictionary *dicResult = JSON;
        NSString *status = [dicResult objectForKey:@"status"];
        NSLog(@"status: %@", status);
        if ([status isEqual:@"0"]) {
            
            NSString *imgpath = [dicResult objectForKey:@"imgPath"];
            NSArray *entList = [dicResult objectForKey:@"ent"];
            if (entList && [entList count] > 0) {
                
                //如果已经开始跑步，就不显示
                if (_isRunning) {
                    return;
                }
                
                NSDictionary *dicEnt0 = [entList objectAtIndex:0];
                RunUser *runner = [RunUser initWithNSDictionary:dicEnt0];
                
                //总的卡路里
                _lblCalorie.text = [NSString stringWithFormat:@"%.2f", runner.calorie];
                
                //总跑步次数
                _lblRunCount.text = [NSString stringWithFormat:@"%d", runner.runTimes];
                
                //总的平均速度
                float secondPerMileage = (runner.mileage > 0.0001) ? runner.minute * 60 / runner.mileage : 0;
                int tempMinute = secondPerMileage / 60;
                int tempSecond = secondPerMileage - tempMinute * 60;
                
                NSString *tempspeedmm = [NSString stringWithFormat:@"%d", tempMinute];
                if (tempspeedmm.length == 1) {
                    tempspeedmm = [NSString stringWithFormat:@"0%@", tempspeedmm];
                }
                NSString *tempspeedss = [NSString stringWithFormat:@"%d", tempSecond];
                if (tempspeedss.length == 1) {
                    tempspeedss = [NSString stringWithFormat:@"0%@", tempspeedss];
                }
                _lblSpead.text = [NSString stringWithFormat:@"%@'%@\"", tempspeedmm, tempspeedss];
                
            }
            
        }//if
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"failure: %@", error);
        
    }];
    [operation start];
    
}

-(void)getWeekRunRecordList{
    
    NSString *memberid = [UserSessionManager GetInstance].currentRunUser.userid;
    NSString *getWeekRunListUrl = [VankeAPI getGetWeekRunListUrl:memberid];
    NSLog(@"getWeekRunListUrl: %@", getWeekRunListUrl);
    
    NSURL *url = [NSURL URLWithString:getWeekRunListUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"getWeekRunRecordList: %@", JSON);
        NSDictionary *dicResult = JSON;
        NSString *status = [dicResult objectForKey:@"status"];
        NSLog(@"status: %@", status);
        if ([status isEqual:@"0"]) {
            
            [_weekRunList removeAllObjects];
            
            //当前时间
            NSDate *nowDate = [NSDate date];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *strNowTime = [formatter stringFromDate:nowDate];
            int nowWeekDay = [PCommonUtil getWeekFromTime:strNowTime];
            NSLog(@"strNowTime: %@, nowWeekDay: %d", strNowTime, nowWeekDay);
            
            NSArray *datalist = [dicResult objectForKey:@"list"];
            int datalistCount = [datalist count];
            for (int i=0; i<datalistCount; i++) {
                NSDictionary *dicrecord = [datalist objectAtIndex:i];
                RunInfoOfWeek *runInfoOfWeek = [RunInfoOfWeek initWithNSDictionary:dicrecord];
                
                if (runInfoOfWeek.beginTime) {
                    
                    int tempweek = [PCommonUtil getWeekFromTime:runInfoOfWeek.beginTime];
                    switch (tempweek) {
                        case 1:
                        {
                            _lblSunday.text = [NSString stringWithFormat:@"%.1fkm", runInfoOfWeek.mileage];
                            if (nowWeekDay >= 1) {
                                _lblSunday.textColor = [UIColor colorWithRed:249.0f/255.0f green:66.0f/255.0f blue:3.0f/255.0f alpha:1.0f];
                            }
                        }
                            break;
                        case 2:
                        {
                            _lblMonday.text = [NSString stringWithFormat:@"%.1fkm", runInfoOfWeek.mileage];
                            if (nowWeekDay >= 2) {
                                _lblMonday.textColor = [UIColor colorWithRed:249.0f/255.0f green:66.0f/255.0f blue:3.0f/255.0f alpha:1.0f];
                            }
                        }
                            break;
                        case 3:
                        {
                            _lblTuesday.text = [NSString stringWithFormat:@"%.1fkm", runInfoOfWeek.mileage];
                            if (nowWeekDay >= 3) {
                                _lblTuesday.textColor = [UIColor colorWithRed:249.0f/255.0f green:66.0f/255.0f blue:3.0f/255.0f alpha:1.0f];
                            }
                        }
                            break;
                        case 4:
                        {
                            _lblWednesday.text = [NSString stringWithFormat:@"%.1fkm", runInfoOfWeek.mileage];
                            if (nowWeekDay >= 4) {
                                _lblWednesday.textColor = [UIColor colorWithRed:249.0f/255.0f green:66.0f/255.0f blue:3.0f/255.0f alpha:1.0f];
                            }
                        }
                            break;
                        case 5:
                        {
                            _lblThursday.text = [NSString stringWithFormat:@"%.1fkm", runInfoOfWeek.mileage];
                            if (nowWeekDay >= 5) {
                                _lblThursday.textColor = [UIColor colorWithRed:249.0f/255.0f green:66.0f/255.0f blue:3.0f/255.0f alpha:1.0f];
                            }
                        }
                            break;
                        case 6:
                        {
                            _lblFriday.text = [NSString stringWithFormat:@"%.1fkm", runInfoOfWeek.mileage];
                            if (nowWeekDay >= 6) {
                                _lblFriday.textColor = [UIColor colorWithRed:249.0f/255.0f green:66.0f/255.0f blue:3.0f/255.0f alpha:1.0f];
                            }
                        }
                            break;
                        case 7:
                        {
                            _lblSaturday.text = [NSString stringWithFormat:@"%.1fkm", runInfoOfWeek.mileage];
                            if (nowWeekDay >= 7) {
                                _lblSaturday.textColor = [UIColor colorWithRed:249.0f/255.0f green:66.0f/255.0f blue:3.0f/255.0f alpha:1.0f];
                            }
                        }
                            break;
                            
                        default:
                            break;
                    }
                    
                }
                
                [_weekRunList addObject:runInfoOfWeek];
            }
            
        }else{
            NSString *errMsg = [dicResult objectForKey:@"msg"];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            
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

-(void)doBack{
    
    @synchronized(_player) {
        
        if (_player) {
            [_player pause];
            _player = nil;
        }
        
    }
    
    [_aaplayer playerDestory];
    
    [self timerStop];
    
    //baidu
    _mapView.showsUserLocation = NO;
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

//-(void)touchMenuAction:(id)sender{
//    
//    NSLog(@"touchMenuAction...");
//    
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:0.3];
//    [UIView setAnimationDelegate:self];
//    
//    _menuOfHeadView.hidden = NO;
//    if ([UserSessionManager GetInstance].unreadMessageCount > 0) {
//        _menuOfHeadView.redDotImageView.hidden = NO;
//    } else {
//        _menuOfHeadView.redDotImageView.hidden = YES;
//    }
//    CGRect menuframe = _menuOfHeadView.frame;
//    _menuOfHeadView.frame = CGRectMake(menuframe.origin.x, menuframe.origin.y, menuframe.size.width, 210);
//    
//    [_menuOfCustomWindow show];
//    
//    [UIView commitAnimations];
//    
//}
//
//-(void)touchOutOfMenuAction:(id)sender{
//    
//    NSLog(@"touchOutOfMenuAction...");
//    
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:0.3];
//    [UIView setAnimationDelegate:self];
//    
////    _menuOfHeadView.alpha = 0.0f;
//    CGRect menuframe = _menuOfHeadView.frame;
//    _menuOfHeadView.frame = CGRectMake(menuframe.origin.x, menuframe.origin.y, menuframe.size.width, 0);
//    
//    [UIView setAnimationDidStopSelector:@selector(hiddenMenuAfterAnimation)];
//    [UIView commitAnimations];
//    
//}

-(void)hiddenMenuAfterAnimation{
    _menuOfCustomWindow.hidden = YES;
    _menuOfHeadView.hidden = YES;
    [_menuOfCustomWindow close];
}

//-(void)touchHomeAction:(id)sender{
//    
//    [self doBack];
//    
//}
//
//-(void)touchNoticeAction:(id)sender{
//    
//    NSLog(@"touchNoticeAction...");
//    
//    NoticeViewController *noticeViewController = [[NoticeViewController alloc] initWithNibName:@"NoticeViewController" bundle:nil];
//    [self.navigationController pushViewController:noticeViewController animated:YES];
//    
//}
//
//-(void)touchChatAction:(id)sender{
//    
//    NSLog(@"touchChatAction...");
//    
////    ChatViewController *chatViewController = [[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil];
////    [chatViewController setChatType:chatTypeDefault];
////    [self.navigationController pushViewController:chatViewController animated:YES];
//    
//    ChatlistViewController *chatListViewController = [[ChatlistViewController alloc]initWithNibName:@"ChatlistViewController" bundle:nil];
//    [self.navigationController pushViewController:chatListViewController animated:YES];
//}
//
//-(void)touchSettingAction:(id)sender{
//    
//    NSLog(@"touchSettingAction...");
//    
//    NSString *memberid = [UserSessionManager GetInstance].currentRunUser.userid;
//    SettingViewController *settingViewController = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
//    [settingViewController setMemberid:[memberid longLongValue]];
//    [self.navigationController pushViewController:settingViewController animated:YES];
//    
//}

#pragma mark 开始或结束跑步
-(IBAction)doStartOrStop:(id)sender{
    
    [_aaplayer playerPlayPause];
    
    if (_isRunning) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"是否要结束跑步？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert setTag:StopRunAlertTag];
        [alert show];
        
    } else {
        
        NSLog(@"doStart...");
        
        //开始时，清理旧数据
        [_locationList removeAllObjects];
        
        /*
        @synchronized(_player) {
            if (_locationSongList && [_locationSongList count]>0) {
                if (_player) {
                    [_player pause];
                    _player = nil;
                }
                
                Song *tempsong = [_locationSongList objectAtIndex:_currentSongIndex];
                
                //使用playerItem获取视频的信息，当前播放时间，总时间等
                AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:tempsong.musicUrl];
                //player是视频播放的控制器，可以用来快进播放，暂停等
                _player = [AVPlayer playerWithPlayerItem:playerItem];
                [_player play];
                //计算视频总时间
                CMTime totalTime = playerItem.duration;
                //因为slider的值是小数，要转成float，当前时间和总时间相除才能得到小数,因为5/10=0
                _totalSongDuration = totalTime.value / totalTime.timescale;
                NSLog(@"_totalSongDuration: %f", _totalSongDuration);
                
                UIImage *palyImage = [UIImage imageNamed:@"run_player_pause.png"];
                [_musicPlayerControllerView.btnStart setImage:palyImage forState:UIControlStateNormal];
                
                //添加视频播放完成的notifation
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(songPlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
                
            }
        }
        */
        
        //更新显示内容背景图片
        _runingDataBgImageView.image = [UIImage imageWithName:@"run_his_running" type:@"png"];
        //本次跑步卡路里
        _lblCalorie.text = [NSString stringWithFormat:@"0.0"];
        //本次跑步时间
        _lblRunCount.text = [NSString stringWithFormat:@"00:00:00"];
        //本次跑步速度
        _lblSpead.text = [NSString stringWithFormat:@"00'00\""];
        
        //处理底部菜单
        _isMenuOfBottomShowing = YES;
        [self touchCenterMenuOfBottom:nil];
        //隐藏跑步记录
        _isRecordShowing = YES;
        [self doShowOrHideRunRecord:nil];
        
        //显示播放器
        _musicPlayerControllerView.hidden = NO;
        
        //baidu
        _mapView.showsUserLocation = YES;
        
        NSDate *nowDate = [NSDate date];
        _nStartTime = [nowDate timeIntervalSince1970];
        _nLastRecordTime = _nStartTime;
        _nRuningOneTimeId = _nStartTime;
        
        UIImage *showRunStopImage = [UIImage imageWithName:@"run_stop" type:@"png"];
        [_btnStart setImage:showRunStopImage forState:UIControlStateNormal];
        
        //开始记录
        [self timerStart];
        
        _isRunning = YES;
        _nDistance = 0;
        
    }
    
}

-(void)stopRun
{
    
    NSLog(@"doStop...");
    
    @synchronized(_player) {
        
        if (_player) {
            [_player pause];
            _player = nil;
            
            UIImage *palyImage = [UIImage imageNamed:@"run_player_play.png"];
            [_musicPlayerControllerView.btnStart setImage:palyImage forState:UIControlStateNormal];
            
        }
        
        //释放掉对playItem的观察
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        
    }
    
    //baidu
    _mapView.showsUserLocation = NO;
    
    UIImage *showRunStartImage = [UIImage imageWithName:@"run_start" type:@"png"];
    [_btnStart setImage:showRunStartImage forState:UIControlStateNormal];
    
    [self timerStop];
    
    _isRunning = NO;
    
    //显示跑步记录
    [self doGotoRunResult];
}

-(void)doGotoRunResult{
    
    NSString *memberid = [UserSessionManager GetInstance].currentRunUser.userid;
    float tempRunnerWeight = [UserSessionManager GetInstance].currentRunUser.weight;
    NSDate *currentDate = [NSDate date];
    long nStopTime = [currentDate timeIntervalSince1970];
    long nRunSecond = nStopTime - _nStartTime;
    
    RunRecord *runRecord = [[RunRecord alloc] init];
    runRecord.memberID = [memberid longLongValue];
    runRecord.mileage = _nDistance / 1000;
    runRecord.minute = (float)nRunSecond / 60.0f;
    runRecord.secondOfRunning = nRunSecond;
    runRecord.calorie = [PCommonUtil calcCalorie:tempRunnerWeight distance:runRecord.mileage];
    runRecord.speed = (nRunSecond > 0) ? _nDistance / nRunSecond : 0;//m/s
    runRecord.runTime = [PCommonUtil formatDate:currentDate formatter:@"yyyy-MM-dd HH:mm:ss"];
    [runRecord setLocationList:_locationList];
    
    RunResultViewController *runResultViewController = [[RunResultViewController alloc] initWithNibName:@"RunResultViewController" bundle:nil];
    [runResultViewController setRunRecord:runRecord];
    [self.navigationController pushViewController:runResultViewController animated:YES];
    
}

-(void)timerStart{
    
    [self timerStop];
    _runningTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(runningTimerFunction) userInfo:nil repeats:YES];
    
}

-(void)timerStop{
    
    @synchronized(self){
        if (_runningTimer != nil) {
            if ([_runningTimer isValid]) {
                [_runningTimer invalidate];
            }
            _runningTimer = nil;
        }
    }
    
}

-(void)runningTimerFunction{
    
    @synchronized(_currentLocation){
        
//        if ([UserSessionManager GetInstance].unreadMessageCount > 0) {
//            [_navView.messageTipImageView setHidden:NO];
//        } else {
//            [_navView.messageTipImageView setHidden:YES];
//        }
        
        NSLog(@"--------------runningTimerFunction start--------------");
        
        //跑步时间
        long currentRecordTime = [[NSDate date] timeIntervalSince1970];
        long tempShowRunningTime = currentRecordTime - _nStartTime;
        
        NSString *temphh = [NSString stringWithFormat:@"%ld", tempShowRunningTime / 3600];
        if (temphh.length == 1) {
            temphh = [NSString stringWithFormat:@"0%@", temphh];
        }
        
        NSString *tempmm = [NSString stringWithFormat:@"%ld", (tempShowRunningTime / 60) % 60];
        if (tempmm.length == 1) {
            tempmm = [NSString stringWithFormat:@"0%@", tempmm];
        }
        
        NSString *tempss = [NSString stringWithFormat:@"%ld", tempShowRunningTime % 60];
        if (tempss.length == 1) {
            tempss = [NSString stringWithFormat:@"0%@", tempss];
        }
        _lblRunCount.text = [NSString stringWithFormat:@"%@:%@:%@", temphh, tempmm, tempss];
        
        if (!_lastLocation || !_currentLocation) {
            return;
        }
        
        //计算跑步距离
        double tempOneDistance = [self calcDistanceByGpsData:_lastLocation currentLocation:_currentLocation];
        if (tempOneDistance < 15) {
            
            //如果大于5米，则记录
            if (tempOneDistance > 5) {
                NSString *templocation = [NSString stringWithFormat:@"%f,%f", _currentLocation.coordinate.latitude, _currentLocation.coordinate.longitude];
                [_locationList addObject:templocation];
            }
            
            NSLog(@"--------------didUpdateUserLocation end--------------");
            return;
        }
        
        //打印数据测试
        NSString *strOldLatitude = [NSString stringWithFormat:@"%f", _lastLocation.coordinate.latitude];
        NSString *strOldLongitude = [NSString stringWithFormat:@"%f", _lastLocation.coordinate.longitude];
        NSString *strNewLatitude = [NSString stringWithFormat:@"%f", _currentLocation.coordinate.latitude];
        NSString *strNewLongitude = [NSString stringWithFormat:@"%f", _currentLocation.coordinate.longitude];
        NSLog(@"strOldLatitude: %@, strOldLongitude: %@", strOldLatitude, strOldLongitude);
        NSLog(@"strNewLatitude: %@, strNewLongitude: %@", strNewLatitude, strNewLongitude);
        
        //记录上一次的坐标
        NSString *templocation = [NSString stringWithFormat:@"%f,%f", _lastLocation.coordinate.latitude, _lastLocation.coordinate.longitude];
        [_locationList addObject:templocation];
        
        //记录最近的两次坐标
        _lastLocation = _currentLocation;           //记录本次位置点
        _currentLocation = nil;                     //新的位置清零，直到新d移动位置
        
        //记录此次移动所有的时间
//        long currentRecordTime = [[NSDate date] timeIntervalSince1970];
        long tempMoveTime = currentRecordTime - _nLastRecordTime;
        tempMoveTime = (tempMoveTime > 0) ? tempMoveTime : 10000;//如果时间过短就延长时间，忽略速度
        _nLastRecordTime = currentRecordTime;
        
        //写入本地数据库
        float tempSpeed = (float)(tempOneDistance / tempMoveTime);
        [self insertRunRecord:tempMoveTime distance:tempOneDistance/1000 oldLatitude:strOldLatitude oldLongitude:strOldLongitude newLatitude:strNewLatitude newLongitude:strNewLongitude speed:tempSpeed runingOneTimeId:_nRuningOneTimeId];
        
        //作弊过滤－超过20km/h不计算 by 20130726
        if (tempSpeed > 5.56) {
            tempOneDistance = 0;
            if (!_errorAlert) {
                _errorAlert= [[UIAlertView alloc]initWithTitle:nil message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            }
            [_errorAlert show];
        }
        _nDistance += tempOneDistance;//本次跑步距离
        
        //刷新里程
        _lblRunDistance.text = [NSString stringWithFormat:@"%.3f",(float)_nDistance/1000];
        
        //刷新圆盘进度
        [self updateRunningProcessByDistance:_nDistance];
        
        //计算本次跑步卡路里
        float tempRunnerWeight = [UserSessionManager GetInstance].currentRunUser.weight;
        NSLog(@"runTotalDistance: %f m, _nDistance: %f m, runnerWeight: %f kg", _nTotalDistance, _nDistance, tempRunnerWeight);
        double tempCalorie = [PCommonUtil calcCalorie:tempRunnerWeight distance:_nDistance/1000];
        _lblCalorie.text = [NSString stringWithFormat:@"%.2f", tempCalorie];
        
        //计算速度
        float tempMileage = _nDistance/1000;
        long tempRunningTime = currentRecordTime - _nStartTime;
        float secondPerMileage = (tempMileage > 0.0001) ? tempRunningTime / tempMileage : 0;
        int tempMinute = secondPerMileage / 60;
        int tempSecond = secondPerMileage - tempMinute * 60;
        
        NSString *tempspeedmm = [NSString stringWithFormat:@"%d", tempMinute];
        if (tempspeedmm.length == 1) {
            tempspeedmm = [NSString stringWithFormat:@"0%@", tempspeedmm];
        }
        NSString *tempspeedss = [NSString stringWithFormat:@"%d", tempSecond];
        if (tempspeedss.length == 1) {
            tempspeedss = [NSString stringWithFormat:@"0%@", tempspeedss];
        }
        _lblSpead.text = [NSString stringWithFormat:@"%@'%@\"", tempspeedmm, tempspeedss];
        
        //2分钟更新一次移动坐标
        NSDate *nowDate = [NSDate date];
        long currentTime = [nowDate timeIntervalSince1970];
        if (currentTime - _nStartTime > 120) {
            [self doSetGPS:[NSString stringWithFormat:@"%@,%@", strNewLatitude, strNewLongitude]];
        }
        
        NSLog(@"--------------didUpdateUserLocation end--------------");
        
    }
    
}

//计算两个坐标点间的记录
-(double)calcDistanceByGpsData:(CLLocation *)location1 currentLocation:(CLLocation *)location2{
    
    double runDistance = 0;
    
    if (location1 && location2) {
        
        double lat1 = location1.coordinate.latitude;
        double lng1 = location1.coordinate.longitude;
        double lat2 = location2.coordinate.latitude;
        double lng2 = location2.coordinate.longitude;
        
        runDistance = [PCommonUtil calcDistance:lat1 longitude1:lng1 latitude2:lat2 longitude2:lng2];
        
        runDistance = (runDistance < 0) ? (-runDistance) : runDistance;
        
    }
    
    NSLog(@"runDistance: %f", runDistance);
    
    return runDistance;
}

//刷新圆盘进度
-(void)updateRunningProcessByDistance:(double)distance{
    
    double tempDistance = distance;
    //圆周比率
    while (tempDistance > 12000) {
        tempDistance -= 12000;
    }
    double distanceRate = tempDistance / 12000.0f;
    if (distanceRate <= 0.01) {
        distanceRate = 0.01;
    }
    
    float width = 193.0f;
    float height = 193.0f;
    CGSize imageSize = CGSizeMake(width, height);
    //半径
    CGFloat radius = MIN(height, width) / 2 - 10;
    //扇形开始角度
    CGFloat radians = DEGREES_2_RADIANS((distanceRate*359.9)-90);
    CGFloat xOffset = radius*(1 + 0.85*cosf(radians));
    CGFloat yOffset = radius*(1 + 0.85*sinf(radians));
    
    //金属圆点
    CGRect processPointFrame = _ivRunProcessPoint.frame;
    processPointFrame.origin.x = xOffset + 72 - (processPointFrame.size.width/2);
    processPointFrame.origin.y = yOffset + 90 -  (processPointFrame.size.height/2);
    _ivRunProcessPoint.frame = processPointFrame;
    
    //圆盘
    UIImage *circleProcess = [UIImage imageWithName:@"circle_process" type:@"png"];
    UIImage *processMask = [PCommonUtil getCircleProcessImageWithNoneAlpha:imageSize progress:distanceRate];
    UIImage *currentProcessImage = [PCommonUtil maskImage:circleProcess withImage:processMask];
    _ivCircleProcess.image = currentProcessImage;
    
}

-(void)insertRunRecord:(long)tRunTime distance:(double)tDistance oldLatitude:(NSString *)toldLatitude oldLongitude:(NSString *)toldLongitude newLatitude:(NSString *)tnewLatitude newLongitude:(NSString *)tnewLongitude speed:(float)tspeed runingOneTimeId:(long)tRuningOneTimeId{
    
    NSLog(@"tRunTime: %ld, tDistance: %f, toldLatitude: %@, toldLongitude: %@, tnewLatitude: %@, tnewLongitude: %@, speed: %f, nRuningOneTimeId: %ld", tRunTime, tDistance, toldLatitude, toldLongitude, tnewLatitude, tnewLongitude, tspeed, tRuningOneTimeId);
    
    [_database open];
    
    NSString *sql = @"insert into RUN_RECORD_DATA (dataid, runtime, oldlatitude, oldlongitude, newlatitude, newlongitude, distance, speed, datacreatetime, runingOneTimeId) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    
    NSDate *nowdate = [NSDate date];
    NSNumber *dataid = [NSNumber numberWithLong:[nowdate timeIntervalSince1970]];
    NSNumber *runtime = [NSNumber numberWithLong:tRunTime];
    NSNumber *oldlatitude = [NSNumber numberWithFloat:[toldLatitude floatValue]];
    NSNumber *oldlongitude = [NSNumber numberWithFloat:[toldLongitude floatValue]];
    NSNumber *newlatitude = [NSNumber numberWithFloat:[tnewLatitude floatValue]];
    NSNumber *newlongitude = [NSNumber numberWithFloat:[tnewLongitude floatValue]];
    NSNumber *distance = [NSNumber numberWithDouble:tDistance];
    NSNumber *speed = [NSNumber numberWithFloat:tspeed];
    NSNumber *numRuningOneTimeId = [NSNumber numberWithLong:tRuningOneTimeId];
    
    [_database executeUpdate:sql, dataid, runtime, oldlatitude, oldlongitude, newlatitude, newlongitude, distance, speed, dataid, numRuningOneTimeId];
    
    [_database close];
    
}

-(void)doSetGPS:(NSString *)location{
    
    NSString *memberid = [UserSessionManager GetInstance].currentRunUser.userid;
    NSString *fanListUrl = [VankeAPI getSetGPSUrl:memberid gpsData:location];
    NSURL *url = [NSURL URLWithString:fanListUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"App.net Global Stream: %@", JSON);
        NSDictionary *dicResult = JSON;
        NSString *status = [dicResult objectForKey:@"status"];
        NSLog(@"status: %@", status);
        if ([status isEqual:@"0"]) {
            NSLog(@"doSetGPS successfule...");
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"failure: %@", error);
    }];
    [operation start];
    
}

-(void)initAndStartPlayer{
    
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"qhc" ofType:@"caf"];
    
    [_aaplayer setSourcePath:filepath];
    [_aaplayer playerInit];
    [_aaplayer setSingleLoop];
//    [_aaplayer playerPlayPause];    //test player
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    
}

//获取手机本地歌曲
-(void)getSongListInPhone{
    
    MPMediaQuery *videoQuery = [[MPMediaQuery alloc] init];
    NSArray *mediaItems = [videoQuery items];
    for (MPMediaItem *mediaItem in mediaItems){
        
        NSURL *URL = (NSURL*)[mediaItem valueForProperty:MPMediaItemPropertyAssetURL];
        if (URL) {
            NSString *name = (NSString *)[mediaItem valueForProperty:MPMediaItemPropertyTitle];
            NSString *artist = (NSString*)[mediaItem valueForProperty:MPMediaItemPropertyArtist];
            NSString *music = [URL absoluteString];
            
            NSLog(@"name(%@), artist(%@), musicUrl(%@)", name, artist, music);
            
            Song *song = [[Song alloc] init];
            song.name = name;
            song.artist = artist;
            song.music = music;
            song.musicUrl = URL;
            
            [_locationSongList addObject:song];
        }
    }
    
}

-(void)pauseOrPlay{
    
    NSLog(@"pauseOrPlay...");
    
    @synchronized(_player) {
        if (_locationSongList && [_locationSongList count]>0) {
            if (_player) {
                [_player pause];
                _player = nil;
                
                UIImage *palyImage = [UIImage imageNamed:@"run_player_play.png"];
                [_musicPlayerControllerView.btnStart setImage:palyImage forState:UIControlStateNormal];
                
            } else {
                Song *tempsong = [_locationSongList objectAtIndex:_currentSongIndex];
//                _player = [[AVPlayer alloc] initWithURL:tempsong.musicUrl];
//                [_player play];
                
                //使用playerItem获取视频的信息，当前播放时间，总时间等
                AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:tempsong.musicUrl];
                //player是视频播放的控制器，可以用来快进播放，暂停等
                _player = [AVPlayer playerWithPlayerItem:playerItem];
                [_player play];
                //计算视频总时间
                CMTime totalTime = playerItem.duration;
                //因为slider的值是小数，要转成float，当前时间和总时间相除才能得到小数,因为5/10=0
                _totalSongDuration = totalTime.value / totalTime.timescale;
                NSLog(@"_totalSongDuration: %f", _totalSongDuration);
                
                UIImage *palyImage = [UIImage imageNamed:@"run_player_pause.png"];
                [_musicPlayerControllerView.btnStart setImage:palyImage forState:UIControlStateNormal];
                
            }
        }
    }
    
}

-(void)playLast{
    
    NSLog(@"playLast...");
    
    @synchronized(_player) {
        if (_locationSongList && [_locationSongList count]>0) {
            _currentSongIndex = ([_locationSongList count] + _currentSongIndex - 1) % [_locationSongList count];
            Song *tempsong = [_locationSongList objectAtIndex:_currentSongIndex];
            
            if (_player) {
                [_player pause];
                _player = nil;
            }
            
//            _player = [[AVPlayer alloc] initWithURL:tempsong.musicUrl];
//            [_player play];
            
            //使用playerItem获取视频的信息，当前播放时间，总时间等
            AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:tempsong.musicUrl];
            //player是视频播放的控制器，可以用来快进播放，暂停等
            _player = [AVPlayer playerWithPlayerItem:playerItem];
            [_player play];
            //计算视频总时间
            CMTime totalTime = playerItem.duration;
            //因为slider的值是小数，要转成float，当前时间和总时间相除才能得到小数,因为5/10=0
            _totalSongDuration = totalTime.value / totalTime.timescale;
            NSLog(@"_totalSongDuration: %f", _totalSongDuration);
            
            
        }
    }
    
    
    
}

-(void)playNext{
    
    NSLog(@"playLast...");
    
    @synchronized(_player) {
        if (_locationSongList && [_locationSongList count]>0) {
            _currentSongIndex = (_currentSongIndex + 1) % [_locationSongList count];
            Song *tempsong = [_locationSongList objectAtIndex:_currentSongIndex];
            
            if (_player) {
                [_player pause];
                _player = nil;
            }
            
//            _player = [[AVPlayer alloc] initWithURL:tempsong.musicUrl];
//            [_player play];
            
            //使用playerItem获取视频的信息，当前播放时间，总时间等
            AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:tempsong.musicUrl];
            //player是视频播放的控制器，可以用来快进播放，暂停等
            _player = [AVPlayer playerWithPlayerItem:playerItem];
            [_player play];
            //计算视频总时间
            CMTime totalTime = playerItem.duration;
            //因为slider的值是小数，要转成float，当前时间和总时间相除才能得到小数,因为5/10=0
            _totalSongDuration = totalTime.value / totalTime.timescale;
            NSLog(@"_totalSongDuration: %f", _totalSongDuration);
            
            
        }
    }
    
}

-(void)pickerIPodLib{
    
    NSLog(@"pickerIPodLib...");
    
    _mediaPickerController = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeMusic];
    _mediaPickerController.delegate = self;
    _mediaPickerController.prompt = NSLocalizedString (@"Add songs to play", "Prompt in media item picker");
    _mediaPickerController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentModalViewController:_mediaPickerController animated:YES];
    
}

-(void)volumeSet:(UISlider *)slider{
    
    //控制手机系统音量
    [[MPMusicPlayerController applicationMusicPlayer] setVolume:slider.value];
    NSLog(@"slider.value: %f, applicationMusicPlayer.volume: %f", slider.value, [MPMusicPlayerController applicationMusicPlayer].volume);
    
}

-(void)showVolume{
    _musicPlayerControllerView.sliderVolume.hidden = NO;
    [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(hideVolume) userInfo:nil repeats:NO];
}

-(void)hideVolume{
    _musicPlayerControllerView.sliderVolume.hidden = YES;
}

-(void)songPlayDidEnd:(NSNotification *)notification{
    
    //一首歌曲播放完成，下一首
    [self playNext];
    
}

#pragma MediaPicker delegate
-(void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection{
    
    NSURL *url = [[mediaItemCollection.items objectAtIndex:0] valueForProperty:MPMediaItemPropertyAssetURL];
    
    @synchronized(_player) {
        
        if (_player) {
            [_player pause];
            _player = nil;
        }
        _player = [[AVPlayer alloc] initWithURL:url];
        [_player play];
        
        UIImage *palyImage = [UIImage imageNamed:@"run_player_pause.png"];
        [_musicPlayerControllerView.btnStart setImage:palyImage forState:UIControlStateNormal];
        
    }
    
    [mediaPicker dismissModalViewControllerAnimated:YES];
    
}

-(void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker{
    
    [mediaPicker dismissModalViewControllerAnimated:YES];
    
}

//设置锁屏状态，显示的歌曲信息
-(void)configNowPlayingInfoCenter{
    
    if (NSClassFromString(@"MPNowPlayingInfoCenter")) {
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:@"name" forKey:MPMediaItemPropertyTitle];
        [dict setObject:@"singer" forKey:MPMediaItemPropertyArtist];
        [dict setObject:@"album" forKey:MPMediaItemPropertyAlbumTitle];
        
        UIImage *image = [UIImage imageWithName:@"fs00" type:@"png"];
        MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:image];
        [dict setObject:artwork forKey:MPMediaItemPropertyArtwork];
        
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
        
    }
    
}

-(IBAction)doShowOrHideRunRecord:(id)sender{
    
    if (_isRunning) {
        return;
    }
    
    if (_isRecordShowing) {
        
        //隐藏
        [self arrowMoveUp];
        [self hideRecord];
        _isRecordShowing = NO;
        
        _musicPlayerControllerView.hidden = YES;
        
    } else {
        //显示
        [self arrowMoveDown];
        [self showRecord];
        
        //底部menu
        if (_isMenuOfBottomShowing) {
            [self touchCenterMenuOfBottom:nil];
        }
        
    }
    
}

-(void)arrowMoveDown{
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut animations:^{
        
        _btnDownUpArrow.frame = CGRectMake(10, 406, 300, 17);
    } completion:^(BOOL finished) {
        
    }];
}

-(void)arrowMoveUp{
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut animations:^{
        
        _btnDownUpArrow.frame = CGRectMake(10, 332, 300, 17);
    } completion:^(BOOL finished) {
        
    }];
}

-(void)showRecord{
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut animations:^{
        
        _ivRunRecordOfWeek.frame = CGRectMake(10, 332, 300, 80);
        _ivRunRecordOfWeek.alpha = 1.0f;
    } completion:^(BOOL finished) {
        //显示跑步纪录
        _lblMonday.hidden = NO;
        _lblTuesday.hidden = NO;
        _lblWednesday.hidden = NO;
        _lblThursday.hidden = NO;
        _lblFriday.hidden = NO;
        _lblSaturday.hidden = NO;
        _lblSunday.hidden = NO;
        _isRecordShowing = YES;
    }];
}

-(void)hideRecord{
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut animations:^{
        
        //隐藏跑步纪录
        _lblMonday.hidden = YES;
        _lblTuesday.hidden = YES;
        _lblWednesday.hidden = YES;
        _lblThursday.hidden = YES;
        _lblFriday.hidden = YES;
        _lblSaturday.hidden = YES;
        _lblSunday.hidden = YES;
        
        _ivRunRecordOfWeek.frame = CGRectMake(10, 332, 300, 0);
        _ivRunRecordOfWeek.alpha = 0.0f;
    } completion:^(BOOL finished) {
        
    }];
}

//Bottom menu action
-(void)touchCenterMenuOfBottom:(id)sender{
    
    NSLog(@"touchCenterMenuOfBottom...");
    
    //跑步时，取消点击
    if (_isRunning) {
        return;
    }
    
    if (_isMenuOfBottomShowing) {
        
        self.ivMenuBg.hidden = YES;
        self.btnMenuFirst.hidden = YES;
        self.btnMenuSecond.hidden = YES;
        self.btnMenuThird.hidden = YES;
        self.btnMenuFourth.hidden = YES;
        _isMenuOfBottomShowing = NO;
        
//        _musicPlayerControllerView.hidden = YES;
        
    } else {
        self.ivMenuBg.hidden = NO;
        self.btnMenuFirst.hidden = NO;
        self.btnMenuSecond.hidden = NO;
        self.btnMenuThird.hidden = NO;
        self.btnMenuFourth.hidden = NO;
        _isMenuOfBottomShowing = YES;
        
        //隐藏跑步记录
        if (_isRecordShowing) {
            [self doShowOrHideRunRecord:nil];
        }
        
    }
    
}

-(void)touchFirstMenuOfBottom:(id)sender{
    
    NSLog(@"touchFirstMenuOfBottom...");
    
}

-(void)touchSecondMenuOfBottom:(id)sender{
    
    NSLog(@"touchSecondMenuOfBottom...");
    
    RunRecordListViewController *runRecordListViewController = [[RunRecordListViewController alloc] initWithNibName:@"RunRecordListViewController" bundle:nil];
    [self.navigationController pushViewController:runRecordListViewController animated:YES];
    
}

-(void)touchThirdMenuOfBottom:(id)sender{
    
    NSLog(@"touchThirdMenuOfBottom...");
    
    LBSViewController *lbsViewController = [[LBSViewController alloc] initWithNibName:@"LBSViewController" bundle:nil];
    [self.navigationController pushViewController:lbsViewController animated:YES];
    
}

-(void)touchFourthMenuOfBottom:(id)sender{
    
    NSLog(@"touchFourthMenuOfBottom...");
    
    TaskViewController *taskViewController = [[TaskViewController alloc] initWithNibName:@"TaskViewController" bundle:nil];
    [self.navigationController pushViewController:taskViewController animated:YES];
    
}

#pragma map view delegate

/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)mapViewWillStartLocatingUser:(BMKMapView *)mapView
{
	NSLog(@"start locate");
}

/**
 *用户位置更新后，会调用此函数
 *@param mapView 地图View
 *@param userLocation 新的用户位置
 */

- (void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation
{
	if (userLocation != nil) {
        
        //记录最近的两次坐标
        if (!_lastLocation) {
            _lastLocation = userLocation.location;
            
            //记录上一次的坐标
            NSString *templocation = [NSString stringWithFormat:@"%f,%f", _lastLocation.coordinate.latitude, _lastLocation.coordinate.longitude];
            [_locationList addObject:templocation];
        }
        _currentLocation = userLocation.location;
        
        /*
        NSLog(@"--------------didUpdateUserLocation start--------------");
        
        NSString *location1 = [NSString stringWithFormat:@"%f,%f", _lastLocation.coordinate.latitude, _lastLocation.coordinate.longitude];
        NSString *location2 = [NSString stringWithFormat:@"%f,%f", _currentLocation.coordinate.latitude, _currentLocation.coordinate.longitude];
        NSLog(@"location1: %@, location2: %@", location1, location2);
        
        double lat1 = _lastLocation.coordinate.latitude;
        double lng1 = _lastLocation.coordinate.longitude;
        double lat2 = _currentLocation.coordinate.latitude;
        double lng2 = _currentLocation.coordinate.longitude;
        
        double new_distance = [PCommonUtil getDistanceByLatitude1:lat1 longitude1:lng1 latitude2:lat2 longitude2:lng2] / 1000;
        
        double old_distanceold = [PCommonUtil calcDistance:lat1 longitude1:lng1 latitude2:lat2 longitude2:lng2];
        NSLog(@"new_distance: %f, old_distanceold: %f", new_distance, old_distanceold);
        
        NSLog(@"--------------didUpdateUserLocation end--------------");
        */
        
	} else {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"GPS信息比较弱，未定位成功，请稍等。";
        hud.margin = 10.f;
        hud.yOffset = 150.f;
        hud.removeFromSuperViewOnHide = YES;
        
        [hud hide:YES afterDelay:2];
        
    }
	
}
/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)mapViewDidStopLocatingUser:(BMKMapView *)mapView
{
    NSLog(@"stop locate");
}
/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
}


- (void)viewDidUnload {
    [self setBtnMenuFirst:nil];
    [self setBtnMenuSecond:nil];
    [self setBtnMenuThird:nil];
    [self setBtnMenuFourth:nil];
    [self setBtnMenuCenter:nil];
    [self setIvMenuBg:nil];
    [self setMenuBottomView:nil];
    [self setErrorAlert:nil];
    [self setSettingAlert:nil];
    [super viewDidUnload];
}
@end
