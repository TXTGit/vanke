//
//  BaseViewController.h
//  vanke
//
//  Created by user on 13-7-26.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDropdownMenuView.h"
#import "CustomWindow.h"
#import "UserSessionManager.h"
#import "PCommonUtil.h"

@interface BaseViewController : UIViewController

@property (nonatomic, retain) PDropdownMenuView *menuOfHeadView;
@property (nonatomic, retain) CustomWindow *menuOfCustomWindow;

@end
