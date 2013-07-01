//
//  ChatlistViewController.h
//  vanke
//
//  Created by zengwu on 13-7-1.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCustomNavigationBarView.h"

@interface ChatlistViewController : UIViewController

@property (nonatomic, retain) PCustomNavigationBarView *navView;
@property (nonatomic, retain) IBOutlet UITableView *friendTableView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicatorView;

@property (nonatomic, retain) NSMutableArray *unReadFriendList;

-(void)doBack;
-(void)initData;
-(void)doGotoChat:(id)sender;

@end
