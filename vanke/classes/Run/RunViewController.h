//
//  RunViewController.h
//  vanke
//
//  Created by pig on 13-6-10.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "PCustomNavigationBarView.h"
#import "MenuOfHeadView.h"
#import "CustomWindow.h"
#import "AAPlayerController.h"
#import <CoreLocation/CoreLocation.h>
#import "FMDatabase.h"
#import "BMapKit.h"
#import "OBShapedButton.h"
#import "PMusicPlayerControllerView.h"
#import "PDropdownMenuView.h"

#import "MenuBottomView.h"

@interface RunViewController : UIViewController<BMKMapViewDelegate, MPMediaPickerControllerDelegate, UIAlertViewDelegate>

@property (nonatomic, retain) IBOutlet BMKMapView* mapView;

@property (nonatomic, retain) PCustomNavigationBarView *navView;

//@property (nonatomic, retain) MenuOfHeadView *menuOfHeadView;
@property (nonatomic, retain) PDropdownMenuView *menuOfHeadView;
@property (nonatomic, retain) CustomWindow *menuOfCustomWindow;

@property (nonatomic, retain) IBOutlet UIView *runMenuView;
@property (nonatomic, retain) IBOutlet UIButton *btnMenu;

@property (nonatomic, retain) IBOutlet UIImageView *ivRunProcess;
@property (nonatomic, retain) IBOutlet UIImageView *ivCircleProcess;
@property (nonatomic, retain) IBOutlet UIImageView *ivRunProcessPoint;
@property (nonatomic, retain) IBOutlet UIButton *btnStart;
@property (nonatomic, retain) NSTimer *runningTimer;
@property (nonatomic, assign) BOOL isRunning;
@property (nonatomic, retain) IBOutlet UILabel *lblRunDistance;
@property (nonatomic, assign) long nStartTime;                                      //跑步开始时间戳
@property (nonatomic, retain) NSString *sqlitePath;
@property (nonatomic, retain) FMDatabase *database;
@property (nonatomic, retain) CLLocation *lastLocation;                             //上一次坐标
@property (nonatomic, retain) CLLocation *currentLocation;                          //当前坐标
@property (nonatomic, assign) long nRuningOneTimeId;                                //一次跑步的id
@property (nonatomic, assign) double nDistance;                                     //记录跑步距离
@property (nonatomic, assign) double nTotalDistance;                                //总跑步距离

@property (nonatomic, assign) long nLastRecordTime;                                 //用于跑步分段时间

@property (nonatomic, retain) IBOutlet UIImageView *runingDataBgImageView;          //跑步数据背景图
@property (nonatomic, retain) IBOutlet UILabel *lblCalorie;
@property (nonatomic, retain) IBOutlet UILabel *lblRunCount;
@property (nonatomic, retain) IBOutlet UILabel *lblSpead;

@property (nonatomic, retain) IBOutlet UIImageView *ivRunRecordOfWeek;

@property (nonatomic, retain) IBOutlet UIButton *btnDownUpArrow;
@property (nonatomic, assign) BOOL isRecordShowing;
@property (nonatomic, retain) IBOutlet UILabel *lblMonday;
@property (nonatomic, retain) IBOutlet UILabel *lblTuesday;
@property (nonatomic, retain) IBOutlet UILabel *lblWednesday;
@property (nonatomic, retain) IBOutlet UILabel *lblThursday;
@property (nonatomic, retain) IBOutlet UILabel *lblFriday;
@property (nonatomic, retain) IBOutlet UILabel *lblSaturday;
@property (nonatomic, retain) IBOutlet UILabel *lblSunday;

@property (nonatomic, retain) IBOutlet AAPlayerController *aaplayer;

@property (nonatomic, assign) BOOL isMenuOfBottomShowing;                           //底部扇形菜单是否显示

@property (nonatomic, retain) NSMutableArray *locationList;
@property (weak, nonatomic) IBOutlet OBShapedButton *btnMenuFirst;
@property (weak, nonatomic) IBOutlet OBShapedButton *btnMenuSecond;
@property (weak, nonatomic) IBOutlet OBShapedButton *btnMenuThird;
@property (weak, nonatomic) IBOutlet OBShapedButton *btnMenuFourth;
@property (weak, nonatomic) IBOutlet OBShapedButton *btnMenuCenter;
@property (weak, nonatomic) IBOutlet UIImageView *ivMenuBg;
@property (weak, nonatomic) IBOutlet MenuBottomView *menuBottomView;

@property (nonatomic, retain) PMusicPlayerControllerView *musicPlayerControllerView;

@property (nonatomic, retain) NSMutableArray *locationSongList;             //本地歌曲
@property (nonatomic, assign) int currentSongIndex;                         //当前歌曲播放位置
@property (nonatomic, retain) AVPlayer *player;
@property (nonatomic, retain) MPMediaPickerController *mediaPickerController;
@property (nonatomic, assign) CGFloat totalSongDuration;

@property (nonatomic, retain) NSMutableArray *weekRunList;

-(void)firstEnterRunningShowTip;

-(void)initLocalDatabase;

//从本地获得总的跑步距离
-(double)getTotalRunDistanceFromDatabase;
//从本地获得总的跑步次数
-(void)getTotalRunCountFromDatabase;
//总的平均速度
-(double)getTotalRuningSpeedFromDatabase;

//获取用户的个人数据纪录
-(void)getMemberDetailInfo:(NSString *)memberid;

//从服务器获取一周跑步记录
-(void)getWeekRunRecordList;

-(void)doBack;
-(void)touchMenuAction:(id)sender;
-(void)touchOutOfMenuAction:(id)sender;
-(void)hiddenMenuAfterAnimation;

-(void)touchHomeAction:(id)sender;
-(void)touchNoticeAction:(id)sender;
-(void)touchChatAction:(id)sender;
-(void)touchSettingAction:(id)sender;

-(IBAction)doStartOrStop:(id)sender;
-(void)timerStart;
-(void)timerStop;
-(void)runningTimerFunction;

//计算跑步数据
-(double)calcDistanceByGpsData:(CLLocation *)location1 currentLocation:(CLLocation *)location2;

//刷新圆盘进度
-(void)updateRunningProcessByDistance:(double)distance;

//记录跑步沿途数据
-(void)insertRunRecord:(long)tRunTime distance:(double)tDistance oldLatitude:(NSString *)toldLatitude oldLongitude:(NSString *)toldLongitude newLatitude:(NSString *)tnewLatitude newLongitude:(NSString *)tnewLongitude speed:(float)tspeed runingOneTimeId:(long)tRuningOneTimeId;

-(void)doSetGPS:(NSString *)location;

-(void)doGotoRunResult;

-(void)initAndStartPlayer;

-(void)getSongListInPhone;              //获取手机本地歌曲
-(void)pauseOrPlay;
-(void)playLast;                        //上一首歌曲
-(void)playNext;                        //下一首歌曲
-(void)pickerIPodLib;
-(void)volumeSet:(UISlider *)slider;    //音量控制
-(void)showVolume;
-(void)hideVolume;
-(void)songPlayDidEnd:(NSNotification*)notification;

-(IBAction)doShowOrHideRunRecord:(id)sender;
-(void)showRecord;
-(void)hideRecord;

-(void)touchCenterMenuOfBottom:(id)sender;
-(void)touchFirstMenuOfBottom:(id)sender;
-(void)touchSecondMenuOfBottom:(id)sender;
-(void)touchThirdMenuOfBottom:(id)sender;
-(void)touchFourthMenuOfBottom:(id)sender;

@end
