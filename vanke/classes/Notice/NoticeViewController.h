//
//  NoticeViewController.h
//  vanke
//
//  Created by pig on 13-6-10.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCustomNavigationBarView.h"
#import "MenuOfHeadView.h"
#import "CustomWindow.h"

@interface NoticeViewController : UIViewController

@property (nonatomic, retain) PCustomNavigationBarView *navView;

@property (nonatomic, retain) MenuOfHeadView *menuOfHeadView;
@property (nonatomic, retain) CustomWindow *menuOfCustomWindow;

-(void)doBack;
-(void)touchMenuAction:(id)sender;
-(void)touchOutOfMenuAction:(id)sender;
-(void)hiddenMenuAfterAnimation;

-(void)touchHomeAction:(id)sender;
-(void)touchNoticeAction:(id)sender;
-(void)touchChatAction:(id)sender;
-(void)touchSettingAction:(id)sender;

@end
