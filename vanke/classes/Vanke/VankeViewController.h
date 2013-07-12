//
//  VankeViewController.h
//  vanke
//
//  Created by apple on 13-7-12.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCustomNavigationBarView.h"

@interface VankeViewController : UIViewController<UIWebViewDelegate>

@property (nonatomic, retain) PCustomNavigationBarView *navView;
@property (nonatomic, retain) IBOutlet UIWebView *vankeWebView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicatorView;

-(void)doBack;
-(void)initData;

@end
