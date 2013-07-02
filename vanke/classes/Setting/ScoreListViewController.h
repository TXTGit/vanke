//
//  ScoreListViewController.h
//  vanke
//
//  Created by pig on 13-7-2.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCustomNavigationBarView.h"

@interface ScoreListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) PCustomNavigationBarView *navView;
@property (weak, nonatomic) IBOutlet UITableView *scoreTableView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicatorView;

@property (nonatomic, retain) NSMutableArray *scoreList;

-(void)doBack;
-(void)initData;

@end
