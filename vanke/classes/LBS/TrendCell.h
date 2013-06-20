//
//  TrendCell.h
//  vanke
//
//  Created by user on 13-6-20.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrendInfo.h"
#import "EGOImageView.h"

@interface TrendCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *imgVline;
@property (retain, nonatomic) IBOutlet EGOImageView *imgHead;
@property (retain, nonatomic) IBOutlet UIImageView *imgBg;
@property (retain, nonatomic) IBOutlet UILabel *lblTitle;
@property (retain, nonatomic) IBOutlet UILabel *lblTime;
@property (retain, nonatomic) IBOutlet EGOImageView *imgShare;

@property (retain, nonatomic) TrendInfo *trendInfo;
-(void)updateView;
@end
