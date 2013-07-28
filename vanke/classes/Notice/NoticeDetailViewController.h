//
//  NoticeDetailViewController.h
//  vanke
//
//  Created by user on 13-7-29.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "BaseViewController.h"
#import "PCustomNavigationBarView.h"
#import "NewsInfo.h"

@interface NoticeDetailViewController : BaseViewController
@property (nonatomic, retain) PCustomNavigationBarView *navView;
@property (nonatomic, retain) NewsInfo *newsInfo;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
