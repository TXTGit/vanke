//
//  RunRecordListViewController.h
//  vanke
//
//  Created by pig on 13-6-10.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCustomNavigationBarView.h"
#import "FMDatabase.h"
#import "PDropdownMenuView.h"
#import "CustomWindow.h"

#import "BaseViewController.h"

@interface RunRecordListViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource,UIActionSheetDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, retain) PCustomNavigationBarView *navView;
@property (nonatomic, retain) PDropdownMenuView *menuOfHeadView;
@property (nonatomic, retain) CustomWindow *menuOfCustomWindow;

@property (nonatomic, retain) IBOutlet UITableView *runRecordTableView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicatorView;

@property (nonatomic, retain) NSMutableArray *recordList;
@property (nonatomic, retain) FMDatabase *database;

@property (nonatomic, assign) BOOL isComeFromRunResultView;

@property (nonatomic, retain) UIActionSheet *achtionSheet;
@property (nonatomic, assign) NSInteger currentYear;
@property (nonatomic, assign) NSInteger currentMonth;

@property (nonatomic, retain) UISegmentedControl *cancellButton;
@property (nonatomic, retain) UISegmentedControl *completeButton;

-(void)touchMenuAction:(id)sender;
-(void)touchOutOfMenuAction:(id)sender;
-(void)hiddenMenuAfterAnimation;

-(void)touchHomeAction:(id)sender;
-(void)touchNoticeAction:(id)sender;
-(void)touchChatAction:(id)sender;
-(void)touchSettingAction:(id)sender;

-(void)initData;
-(void)showLocationData;            //本地数据
-(void)getRunList;                  //服务器获取数据
-(void)doBack;

@end
