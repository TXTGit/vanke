//
//  TrendViewController.h
//  vanke
//
//  Created by pig on 13-6-12.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCustomNavigationBarView.h"
#import "BaseViewController.h"

@interface TrendViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, retain) PCustomNavigationBarView *navView;
@property (weak, nonatomic) IBOutlet UITableView *trendTableView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicatorView;

@property (nonatomic, retain) NSMutableArray *trendList;

-(void)doBack;

@end
