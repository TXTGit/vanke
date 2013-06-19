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

@interface ChatViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, retain) PCustomNavigationBarView *navView;

@property (nonatomic, retain) IBOutlet UITableView *chatTableView;
@property (nonatomic, retain) IBOutlet UIView *sendMessageView;
@property (nonatomic, retain) IBOutlet UITextField *messageField;
@property (nonatomic, retain) IBOutlet UIButton *btnSend;

@property (nonatomic, retain) NSMutableArray *chatMessageList;
@property (nonatomic, assign) long lastMessageId;

@property (nonatomic, retain) FriendInfo *friendInfo;
@property (nonatomic, retain) NSTimer *getMsgTimer;

-(void)doBack;
-(void)initData;

-(IBAction)doSend:(id)sender;

@end
