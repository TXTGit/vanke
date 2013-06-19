//
//  BindViewController.h
//  vanke
//
//  Created by pig on 13-6-12.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCustomNavigationBarView.h"
#import "RunUser.h"
#import "Community.h"

@interface BindViewController : UIViewController<UIActionSheetDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, retain) PCustomNavigationBarView *navView;

@property (nonatomic, retain) IBOutlet UILabel *lblArea;
@property (nonatomic, retain) IBOutlet UIButton *btnAreaSelect;
@property (nonatomic, retain) IBOutlet UIButton *btnFinish;

@property (nonatomic, retain) UIActionSheet *achtionSheet;

@property (nonatomic, assign) int currentSelectedCommunityId;
@property (nonatomic, retain) RunUser *runUser;
@property (nonatomic, retain) NSMutableArray *communityList;

-(void)initData;

-(void)doBack;
-(IBAction)doSelect:(id)sender;
-(IBAction)doFinish:(id)sender;
-(void)doBind;

@end
