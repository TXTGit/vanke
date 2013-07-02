//
//  SettingViewController.h
//  vanke
//
//  Created by pig on 13-6-10.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCustomNavigationBarView.h"
#import "RunUser.h"
#import "EGOImageButton.h"

@interface SettingViewController : UIViewController<UITextFieldDelegate,UIScrollViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,EGOImageButtonDelegate,UIActionSheetDelegate, UIPickerViewDataSource, UIPickerViewDelegate>{
    BOOL changeHeadImg;
}

@property (nonatomic, retain) PCustomNavigationBarView *navView;

@property (nonatomic, retain) UIScrollView *tempScroll;
@property (nonatomic, retain) IBOutlet UIView *broadView;
@property (nonatomic, retain) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, retain) IBOutlet EGOImageButton *btnHeadImg;
@property (nonatomic, retain) IBOutlet UILabel *lblTotalDistance;
@property (nonatomic, retain) IBOutlet UILabel *lblDuiHuanDistance;

@property (nonatomic, retain) IBOutlet UILabel *lblMingCi;               //名称
@property (nonatomic, retain) IBOutlet UILabel *lblHaoYou;               //好友
@property (nonatomic, retain) IBOutlet UILabel *lblNengLiang;            //能量
@property (nonatomic, retain) IBOutlet UILabel *lblDeFen;                //得分

@property (nonatomic, retain) IBOutlet UIButton *btnJiFen;
@property (nonatomic, retain) IBOutlet UIButton *btnDuoBao;
@property (nonatomic, retain) IBOutlet UIButton *btnDuiHuanRecord;

@property (nonatomic, retain) IBOutlet UITextField *tallField;
@property (nonatomic, retain) IBOutlet UITextField *weightField;
//@property (nonatomic, retain) IBOutlet UITextField *areaField;
@property (nonatomic, retain) IBOutlet UILabel *lblArea;
@property (nonatomic, retain) IBOutlet UITextField *addressField;
@property (nonatomic, retain) IBOutlet UITextField *telField;

@property (nonatomic, retain) IBOutlet UIButton *btnSina;                //
@property (nonatomic, retain) IBOutlet UIButton *btnTel;                 //
@property (nonatomic, retain) IBOutlet UIImageView *logoutImageView;
@property (nonatomic, retain) IBOutlet UIButton *btnLogout;              //

@property (nonatomic, assign) long memberid;
@property (nonatomic, retain) RunUser *runner;

@property (nonatomic, retain) UIActionSheet *achtionSheet;
@property (nonatomic, assign) int currentSelectedItem;

-(void)initData;

-(void)doBack;
-(void)touchMenuAction:(id)sender;

-(IBAction)doJiFen:(id)sender;
-(IBAction)doDuoBao:(id)sender;
-(IBAction)doDuiHuan:(id)sender;

-(IBAction)doSina:(id)sender;
-(IBAction)doTel:(id)sender;
-(IBAction)doLogout:(id)sender;

-(IBAction)resiginTextField:(id)sender;

@end
