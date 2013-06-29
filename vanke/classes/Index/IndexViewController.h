//
//  IndexViewController.h
//  vanke
//
//  Created by pig on 13-6-9.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCustomNavigationBarView.h"
#import "EGOImageView.h"
#import "PDropdownMenuView.h"
#import "CustomWindow.h"

@interface IndexViewController : UIViewController

@property (nonatomic, retain) PCustomNavigationBarView *navView;

@property (nonatomic, retain) PDropdownMenuView *menuOfHeadView;
@property (nonatomic, retain) CustomWindow *menuOfCustomWindow;

@property (nonatomic, retain) IBOutlet UIButton *btnIndexRun;
@property (nonatomic, retain) IBOutlet UIButton *btnIndexVanke;
@property (nonatomic, retain) IBOutlet UIButton *btnIndexStore;

-(void)touchMenuAction:(id)sender;
-(void)touchOutOfMenuAction:(id)sender;
-(void)hiddenMenuAfterAnimation;

-(void)touchHomeAction:(id)sender;
-(void)touchNoticeAction:(id)sender;
-(void)touchChatAction:(id)sender;
-(void)touchSettingAction:(id)sender;

-(IBAction)doIndexRun:(id)sender;
-(IBAction)doIndexVanke:(id)sender;
-(IBAction)doIndexStore:(id)sender;

-(void)getUnreadDataFromServerByHttp;
-(void)doGetMemberInfo:(NSString *)memberid;

@end
