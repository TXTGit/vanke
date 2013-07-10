//
//  RankViewController.h
//  vanke
//
//  Created by pig on 13-6-12.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCustomNavigationBarView.h"

@interface RankViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>

@property (nonatomic, retain) PCustomNavigationBarView *navView;

@property (nonatomic, retain) IBOutlet UIButton *btnFanRank;                //跑友圈排名
@property (nonatomic, retain) IBOutlet UIImageView *fanArrawImageView;
@property (nonatomic, retain) IBOutlet UIButton *btnCommunityRank;          //社区排名
@property (nonatomic, retain) IBOutlet UIImageView *communityArrawImageView;
@property (nonatomic, retain) IBOutlet UIButton *btnTotalRank;              //总排名
@property (nonatomic, retain) IBOutlet UIImageView *totalArrawImageView;

@property (nonatomic, retain) IBOutlet UITableView *rankTableView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicatorView;

@property (nonatomic, retain) NSMutableArray *fanRankList;
@property (nonatomic, retain) NSMutableArray *communityRankList;
@property (nonatomic, retain) NSMutableArray *totalRankList;                //总排名显示数据

@property (nonatomic, assign) int showRankType;     //显示排名类型，1-跑友圈排名，2-社区排名，3-总排名

-(void)doBack;
-(void)initData;
-(void)getFanRankListByType:(int)rankType;//跑友圈
-(void)getCommunityRankListByType:(int)rankType;//社区
-(void)getTotalRankListByType:(int)rankType;//获取总排名列表getTotalRankList（2013-7-10）
-(void)showRanklist:(int)currentShowRankType rankType:(int)rankType;//根据跑友圈、社区、总排名，显示类别排名
-(void)updateCurrentArraw;

-(IBAction)doShowFanRank:(id)sender;//跑友圈
-(IBAction)doShowCommunityRank:(id)sender;//社区
-(IBAction)doShowTotalRank:(id)sender;//总排名
-(IBAction)doShowRankSelect:(id)sender;//选择排名显示菜单

-(void)doGotoSetting:(id)sender;
-(void)doGotoChat:(id)sender;

@end
