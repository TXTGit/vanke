//
//  ChatViewController.h
//  vanke
//
//  Created by pig on 13-6-10.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCustomNavigationBarView.h"
#import "FriendInfo.h"
#import "ChatCell.h"
#import "EGORefreshTableHeaderView.h"

@interface ChatViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, EGORefreshTableHeaderDelegate>

@property (nonatomic, retain) PCustomNavigationBarView *navView;

@property (nonatomic, retain) IBOutlet UITableView *chatTableView;
@property (nonatomic, retain) IBOutlet UIView *sendMessageView;
@property (nonatomic, retain) IBOutlet UITextField *messageField;
@property (nonatomic, retain) IBOutlet UIButton *btnSend;

@property (nonatomic, retain) NSMutableArray *chatMessageList;
@property (nonatomic, assign) long lastMessageId;

@property (nonatomic, retain) FriendInfo *friendInfo;
@property (nonatomic, retain) NSTimer *getMsgTimer;
@property (nonatomic, assign) ChatType chatType;

@property (nonatomic, assign) BOOL isChatViewShow;

//下拉刷新
@property (nonatomic, retain) EGORefreshTableHeaderView *egoRefreshHeaderView;
@property (nonatomic, assign) BOOL reloading;

@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,assign) NSInteger rows;

@property (nonatomic,retain) UIAlertView *alertView;

-(void)doBack;
-(void)initData;

-(IBAction)doSend:(id)sender;

//下拉刷新方法
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

@end
