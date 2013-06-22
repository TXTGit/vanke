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

@interface RunRecordListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) PCustomNavigationBarView *navView;
@property (nonatomic, retain) IBOutlet UITableView *runRecordTableView;

@property (nonatomic, retain) NSMutableArray *recordList;
@property (nonatomic, retain) FMDatabase *database;

@property (nonatomic, assign) BOOL isComeFromRunResultView;

-(void)initData;
-(void)showLocationData;            //本地数据
-(void)getRunList;                  //服务器获取数据
-(void)doBack;

@end
