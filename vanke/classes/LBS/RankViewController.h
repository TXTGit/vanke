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

@property (nonatomic, retain) NSMutableArray *fanRankList;
@property (nonatomic, retain) NSMutableArray *communityRankList;
@property (nonatomic, retain) NSMutableArray *totalRankList;                //总排名显示数据

@property (nonatomic, assign) int showRankType;     //显示排名类型，1-跑友圈排名，2-社区排名，3-总排名
@property (nonatomic, assign) BOOL isCommunity;     //是否是社区排行

-(void)doBack;
-(void)initData;
-(void)getFanRankListByType:(int)rankType;//跑友圈
-(void)getCommunityRankListByType:(int)rankType;//社区
-(void)getTotalRanklistByType:(BOOL)isCommunity rankType:(int)rankType;//根据跑友圈还是社区，显示类别排名
-(void)updateCurrentArraw;

-(IBAction)doShowFanRank:(id)sender;
-(IBAction)doShowCommunityRank:(id)sender;
-(IBAction)doShowTotalRank:(id)sender;

-(void)doGotoSetting:(id)sender;
-(void)doGotoChat:(id)sender;

@end
