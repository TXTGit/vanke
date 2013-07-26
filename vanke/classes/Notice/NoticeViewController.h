//
//  NoticeViewController.h
//  vanke
//
//  Created by pig on 13-6-10.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCustomNavigationBarView.h"
#import "MenuOfHeadView.h"
#import "CustomWindow.h"
#import "EGOImageView.h"

#import "BaseViewController.h"

@interface NoticeViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, EGOImageViewDelegate>

@property (nonatomic, retain) PCustomNavigationBarView *navView;

@property (nonatomic, retain) MenuOfHeadView *menuOfHeadView;
@property (nonatomic, retain) CustomWindow *menuOfCustomWindow;

@property (nonatomic, retain) IBOutlet UITableView *activityTableView;

@property (nonatomic, retain) NSMutableArray *activityList;

-(void)doBack;
-(void)touchMenuAction:(id)sender;
-(void)touchOutOfMenuAction:(id)sender;
-(void)hiddenMenuAfterAnimation;

-(void)touchHomeAction:(id)sender;
-(void)touchNoticeAction:(id)sender;
-(void)touchChatAction:(id)sender;
-(void)touchSettingAction:(id)sender;

-(void)initData;
-(void)getActivitysListUrl:(int)page rows:(int)rows;

@end
