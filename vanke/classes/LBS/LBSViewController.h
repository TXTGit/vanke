//
//  LBSViewController.h
//  vanke
//
//  Created by pig on 13-6-12.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import "PCustomNavigationBarView.h"
#import "PShapMenuView.h"
#import "CalloutMapAnnotation.h"
#import "EGOImageButton.h"

#import "BaseViewController.h"

@interface LBSViewController : BaseViewController<BMKMapViewDelegate, EGOImageButtonDelegate>

@property (nonatomic, retain) IBOutlet BMKMapView* mapView;
@property (nonatomic, retain) PCustomNavigationBarView *navView;
@property (nonatomic, retain) IBOutlet UIButton *btnLeftMenu;
@property (nonatomic, retain) IBOutlet UIButton *btnRightMenu;
@property (nonatomic, retain) PShapMenuView *shapMenuView;
@property (nonatomic, retain) UIButton *btnCenterMenu;
@property (nonatomic, assign) BOOL isShapMenuShowing;

@property (nonatomic, retain) NSString *currentLocation;
@property (nonatomic, retain) NSMutableArray *nearfriendlist;
@property (nonatomic, retain) NSMutableArray *communitylist;

@property (nonatomic, retain) CalloutMapAnnotation *calloutMapAnnotation;

-(void)doBack;

-(IBAction)doLeftMenu:(id)sender;
-(IBAction)doRightMenu:(id)sender;

-(void)touchCenterMenuOfBottom:(id)sender;
-(void)touchFirstMenuOfBottom:(id)sender;
-(void)touchSecondMenuOfBottom:(id)sender;
-(void)touchThirdMenuOfBottom:(id)sender;
-(void)touchFourthMenuOfBottom:(id)sender;

-(void)initData;
-(void)getLbsList;
-(void)getLbsCommunityList;
-(void)showRunnerOnMapView:(NSMutableArray *)locationList;
-(void)doSetGPS:(NSString *)location;
-(void)doGotoSetting:(id)sender;

@end
