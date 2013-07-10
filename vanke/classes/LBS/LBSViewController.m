//
//  LBSViewController.m
//  vanke
//
//  Created by pig on 13-6-12.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "LBSViewController.h"
#import "UIImage+PImageCategory.h"
#import "NearViewController.h"
#import "FriendViewController.h"
#import "TrendViewController.h"
#import "SettingViewController.h"
#import "RankViewController.h"
#import "UserSessionManager.h"
#import "VankeAPI.h"
#import "AFJSONRequestOperation.h"
#import "NearFriend.h"
#import "PCommonUtil.h"

#import "CustomPointAnnotation.h"
#import "CalloutMapAnnotation.h"
#import "CallOutAnnotationView.h"

#import "AppDelegate.h"

#import "ImageCacher.h"

@interface LBSViewController ()

@end

@implementation LBSViewController

@synthesize mapView = _mapView;
@synthesize navView = _navView;
@synthesize btnLeftMenu = _btnLeftMenu;
@synthesize btnRightMenu = _btnRightMenu;
@synthesize shapMenuView = _shapMenuView;
@synthesize btnCenterMenu = _btnCenterMenu;
@synthesize isShapMenuShowing = _isShapMenuShowing;

@synthesize currentLocation = _currentLocation;
@synthesize nearfriendlist = _nearfriendlist;
@synthesize communitylist = _communitylist;

@synthesize calloutMapAnnotation = _calloutMapAnnotation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _isShapMenuShowing = NO;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    float height = [UIScreen mainScreen].bounds.size.height - 20;
    
    //nav bar
    _navView = [[PCustomNavigationBarView alloc] initWithTitle:@"约跑神器" bgImageView:@"index_nav_bg"];
    [self.view addSubview:_navView];
    
    UIImage *indexBack = [UIImage imageWithName:@"main_back" type:@"png"];
    [_navView.leftButton setBackgroundImage:indexBack forState:UIControlStateNormal];
    [_navView.leftButton setHidden:NO];
    [_navView.leftButton addTarget:self action:@selector(doBack) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *headImg = [UserSessionManager GetInstance].currentRunUser.headImg;
    if (headImg && ![headImg isEqualToString:@""]) {
        NSURL *headUrl = [NSURL URLWithString:headImg];
        [_navView.rightButton setImageURL:headUrl];
    }else{
        UIImage *indexHeadBg = [UIImage imageWithName:@"main_head" type:@"png"];
        [_navView.rightButton setBackgroundImage:indexHeadBg forState:UIControlStateNormal];
    }
    [_navView.rightButton setHidden:NO];
    
    //shap menu view
    _shapMenuView = [[PShapMenuView alloc] initShapMenuOfLBS:CGRectMake(0, height-160, 320, 160)];
    [_shapMenuView.btnMenuFirst addTarget:self action:@selector(touchFirstMenuOfBottom:) forControlEvents:UIControlEventTouchUpInside];
    [_shapMenuView.btnMenuSecond addTarget:self action:@selector(touchSecondMenuOfBottom:) forControlEvents:UIControlEventTouchUpInside];
    [_shapMenuView.btnMenuThird addTarget:self action:@selector(touchThirdMenuOfBottom:) forControlEvents:UIControlEventTouchUpInside];
    [_shapMenuView.btnMenuFourth addTarget:self action:@selector(touchFourthMenuOfBottom:) forControlEvents:UIControlEventTouchUpInside];
    _shapMenuView.hidden = YES;
    
    [self.view addSubview:_shapMenuView];
    
    _btnCenterMenu = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnCenterMenu.frame = CGRectMake(123, height - 29, 74, 29);
    UIImage *centerMenuImage = [UIImage imageWithName:@"run_bt" type:@"png"];
    [_btnCenterMenu setImage:centerMenuImage forState:UIControlStateNormal];
    [_btnCenterMenu addTarget:self action:@selector(touchCenterMenuOfBottom:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnCenterMenu];
    
    //data
    _nearfriendlist = [[NSMutableArray alloc] init];
    _communitylist = [[NSMutableArray alloc] init];
    
    //baidu
    _mapView.showsUserLocation = YES;
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    //更新未读提醒
    [[AppDelegate App] getUnreadList];
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)doBack{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(IBAction)doLeftMenu:(id)sender{
    
    NSLog(@"doLeftMenu...");
    
    NearViewController *nearViewController = [[NearViewController alloc] initWithNibName:@"NearViewController" bundle:nil];
    [self.navigationController pushViewController:nearViewController animated:YES];
    
}

-(IBAction)doRightMenu:(id)sender{
    
    NSLog(@"doRightMenu...");
    
    FriendViewController *friendViewController = [[FriendViewController alloc] initWithNibName:@"FriendViewController" bundle:nil];
    [self.navigationController pushViewController:friendViewController animated:YES];
    
}

-(void)touchCenterMenuOfBottom:(id)sender{
    
    NSLog(@"touchCenterMenuOfBottom...");
    
    if (_isShapMenuShowing) {
        
        _shapMenuView.hidden = YES;
        _isShapMenuShowing = NO;
        
    } else {
        _shapMenuView.hidden = NO;
        _isShapMenuShowing = YES;
        
    }
    
}

-(void)touchFirstMenuOfBottom:(id)sender{
    
    NSLog(@"touchFirstMenuOfBottom...");
    
}

-(void)touchSecondMenuOfBottom:(id)sender{
    
    NSLog(@"touchSecondMenuOfBottom...");
    
    TrendViewController *trendViewController = [[TrendViewController alloc] initWithNibName:@"TrendViewController" bundle:nil];
    [self.navigationController pushViewController:trendViewController animated:YES];
    
}

-(void)touchThirdMenuOfBottom:(id)sender{
    
    NSLog(@"touchThirdMenuOfBottom...");
    
    NSString *memberid = [UserSessionManager GetInstance].currentRunUser.userid;
    SettingViewController *settingViewController = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
    [settingViewController setMemberid:[memberid longLongValue]];
    [self.navigationController pushViewController:settingViewController animated:YES];
    
}

-(void)touchFourthMenuOfBottom:(id)sender{
    
    NSLog(@"touchFourthMenuOfBottom...");
    
    RankViewController *rankViewController = [[RankViewController alloc] initWithNibName:@"RankViewController" bundle:nil];
    [self.navigationController pushViewController:rankViewController animated:YES];
    
}

//data

-(void)initData{
    
    if (_currentLocation) {
        [self getLbsList];
        [self getLbsCommunityList];
    }
    
}

-(void)getLbsList{
    
    NSString *memberid = [UserSessionManager GetInstance].currentRunUser.userid;
    NSString *fanListUrl = [VankeAPI getGetLbsListUrl:memberid gpsData:_currentLocation radius:1000];
    NSURL *url = [NSURL URLWithString:fanListUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"App.net Global Stream: %@", JSON);
        NSDictionary *dicResult = JSON;
        NSString *status = [dicResult objectForKey:@"status"];
        NSLog(@"status: %@", status);
        if ([status isEqual:@"0"]) {
            
            NSArray *datalist = [dicResult objectForKey:@"list"];
            int datalistCount = [datalist count];
            for (int i=0; i<datalistCount; i++) {
                NSDictionary *dicrecord = [datalist objectAtIndex:i];
                NearFriend *nearfriend = [NearFriend initWithNSDictionary:dicrecord];
                [_nearfriendlist addObject:nearfriend];
            }
            
            [self showRunnerOnMapView:_nearfriendlist];
        }else{
            NSString *errMsg = [dicResult objectForKey:@"msg"];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            
            // Configure for text only and offset down
            hud.mode = MBProgressHUDModeText;
            hud.labelText = errMsg;
            hud.margin = 10.f;
            hud.yOffset = 150.0f;
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:2];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"failure: %@", error);
    }];
    [operation start];
    
}

-(void)getLbsCommunityList{
    
    NSString *memberid = [UserSessionManager GetInstance].currentRunUser.userid;
    int communityid = [UserSessionManager GetInstance].currentRunUser.communityid;
    NSString *fanListUrl = [VankeAPI getLbsCommunityList:memberid communityID:communityid gpsData:_currentLocation radius:1000];
    NSURL *url = [NSURL URLWithString:fanListUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"App.net Global Stream: %@", JSON);
        NSDictionary *dicResult = JSON;
        NSString *status = [dicResult objectForKey:@"status"];
        NSLog(@"status: %@", status);
        if ([status isEqual:@"0"]) {
            
            NSArray *datalist = [dicResult objectForKey:@"list"];
            int datalistCount = [datalist count];
            for (int i=0; i<datalistCount; i++) {
                NSDictionary *dicrecord = [datalist objectAtIndex:i];
                NearFriend *nearfriend = [NearFriend initWithNSDictionary:dicrecord];
                [_communitylist addObject:nearfriend];
            }
            
            //显示社区用户
            [self showRunnerOnMapView:_communitylist];
        }else{
            NSString *errMsg = [dicResult objectForKey:@"msg"];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            
            // Configure for text only and offset down
            hud.mode = MBProgressHUDModeText;
            hud.labelText = errMsg;
            hud.margin = 10.f;
            hud.yOffset = 150.0f;
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:2];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"failure: %@", error);
    }];
    [operation start];
    
}

-(void)showRunnerOnMapView:(NSMutableArray *)locationList{
    
    //显示runner
    int locationCount = locationList.count;
    CLLocationCoordinate2D coors[locationCount];
    for (int i=0; i<locationCount; i++) {
        NearFriend *tempnearfriend = [locationList objectAtIndex:i];
        NSString *location = tempnearfriend.gps;
        NSArray *dl = [location componentsSeparatedByString:@","];
        coors[i].latitude = [[dl objectAtIndex:0] doubleValue];
        coors[i].longitude = [[dl objectAtIndex:1] doubleValue];
        
        CustomPointAnnotation *pointAnnotation = [[CustomPointAnnotation alloc] init];
        pointAnnotation.coordinate = coors[i];
        pointAnnotation.title = @"Runner";
        pointAnnotation.nearFriend = tempnearfriend;
        [_mapView addAnnotation:pointAnnotation];
        
//        MapPointAnnotation *customAnnotation = [[MapPointAnnotation alloc] init];
//        customAnnotation.coordinate = coors[i];
//        customAnnotation.title = @"Runner";
//        customAnnotation.nearFriend = tempnearfriend;
//        [_mapView addAnnotation:customAnnotation];
        
//        BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
//        annotation.coordinate = coors[i];
//        annotation.title = @"Runner";
//        [_mapView addAnnotation:annotation];
        
    }
    
//    BMKPolyline* polyline = [BMKPolyline polylineWithCoordinates:coors count:locationCount];
//    [_mapView addOverlay:polyline];
//    [_mapView setZoomLevel:11];
}

-(void)doSetGPS:(NSString *)location{
    
    NSString *memberid = [UserSessionManager GetInstance].currentRunUser.userid;
    NSString *fanListUrl = [VankeAPI getSetGPSUrl:memberid gpsData:location];
    NSURL *url = [NSURL URLWithString:fanListUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"App.net Global Stream: %@", JSON);
        NSDictionary *dicResult = JSON;
        NSString *status = [dicResult objectForKey:@"status"];
        NSLog(@"status: %@", status);
        if ([status isEqual:@"0"]) {
            NSLog(@"doSetGPS successfule...");
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"failure: %@", error);
    }];
    [operation start];
    
}

-(void)doGotoSetting:(id)sender{
    
    EGOImageButton *btnUserTip = (EGOImageButton *)sender;
    long memberid = btnUserTip.tag;
    NSLog(@"doGotoSetting memberid: %ld", memberid);
    
    SettingViewController *settingViewController = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
    [settingViewController setMemberid:memberid];
    [self.navigationController pushViewController:settingViewController animated:YES];
    
}

#pragma map view delegate

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation{
    @try {
        if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
            CustomPointAnnotation *customAnn = (CustomPointAnnotation*)annotation;
            BMKPinAnnotationView *newAnnotation = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
            if (annotation.title && [annotation.title isEqualToString:@"Runner"]) {
                newAnnotation.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"lbs_user_tip" ofType:@"png"]];
                
                if (customAnn.nearFriend.headImg && ![customAnn.nearFriend.headImg isEqualToString:@""]) {
                    NSURL *imgUrl=[NSURL URLWithString:customAnn.nearFriend.headImg];
                    if (hasCachedImage(imgUrl)) {
                        [newAnnotation setImage:[UIImage imageWithContentsOfFile:pathForURL(imgUrl)]];
                    }else
                    {
                        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:imgUrl,@"url",newAnnotation,@"imageView",annotation,@"BMKPin",nil];
                        [NSThread detachNewThreadSelector:@selector(cacheImage:) toTarget:[ImageCacher defaultCacher] withObject:dic];
                    }
                }
                
            } else if (annotation.title && [annotation.title isEqualToString:@"Owner"]) {
                newAnnotation.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"lbs_user_tip" ofType:@"png"]];
                
                if (customAnn.nearFriend.headImg && ![customAnn.nearFriend.headImg isEqualToString:@""]) {
                    NSURL *imgUrl=[NSURL URLWithString:customAnn.nearFriend.headImg];
                    if (hasCachedImage(imgUrl)) {
                        [newAnnotation setImage:[UIImage imageWithContentsOfFile:pathForURL(imgUrl)]];
                    }else
                    {
                        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:imgUrl,@"url",newAnnotation,@"imageView",annotation,@"BMKPin",nil];
                        [NSThread detachNewThreadSelector:@selector(cacheImage:) toTarget:[ImageCacher defaultCacher] withObject:dic];
                    }
                }
            }
            
            newAnnotation.animatesDrop = YES;
            newAnnotation.canShowCallout = NO;
            newAnnotation.calloutOffset = CGPointMake(0,0);
            newAnnotation.draggable = NO;//拖动
            
            return newAnnotation;
        } else if ([annotation isKindOfClass:[CustomPointAnnotation class]]) {
            
            static NSString *annotationIdentifier = @"customAnnotation";
            BMKPinAnnotationView *annotationview = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
            annotationview.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"lbs_user_tip" ofType:@"png"]];
            annotationview.animatesDrop = YES;
            annotationview.canShowCallout = NO;
            
            //下载头像图片
            CustomPointAnnotation *ann = annotation;
            if (ann.nearFriend.headImg) {
                NSURL *photoUrl = [NSURL URLWithString:ann.nearFriend.headImg];
                [[EGOImageLoader sharedImageLoader] loadImageForURL:photoUrl observer:self];
            }
            
            return annotationview;
        } else if ([annotation isKindOfClass:[CalloutMapAnnotation class]]) {
            
            //此时annotation就是我们calloutview的annotation
            CalloutMapAnnotation *ann = (CalloutMapAnnotation *)annotation;
            
            //如果可以重用
            CallOutAnnotationView *calloutannotationview = (CallOutAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"calloutview"];
            
            //否则创建新的calloutView
            if (!calloutannotationview) {
                calloutannotationview = [[CallOutAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"calloutview"];
                
                BusPointCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"BusPointCell" owner:self options:nil] objectAtIndex:0];
                
                [calloutannotationview.contentView addSubview:cell];
                calloutannotationview.busInfoView = cell;
            }
            
            //开始设置添加marker时的赋值
            long memberid = ann.nearFriend.memberID;
            calloutannotationview.busInfoView.btnUserTip.tag = memberid;
            if (ann.nearFriend.headImg && ![ann.nearFriend.headImg isEqualToString:@""]) {
                calloutannotationview.busInfoView.btnUserTip.imageURL = [NSURL URLWithString:ann.nearFriend.headImg];
            }
            [calloutannotationview.busInfoView.btnUserTip addTarget:self action:@selector(doGotoSetting:) forControlEvents:UIControlEventTouchUpInside];
            if ([PCommonUtil checkDataIsNull:ann.nearFriend.nickName]) {
                calloutannotationview.busInfoView.lblNickName.text = ann.nearFriend.nickName;
            }else{
                calloutannotationview.busInfoView.lblNickName.text = @"";
            }
            calloutannotationview.busInfoView.lblLoginTime.text = ann.nearFriend.loginTime;
            
            return calloutannotationview;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"parser RunUser failed...pease check");
        
        static NSString *annotationIdentifier = @"customAnnotation";
        BMKPinAnnotationView *annotationview = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
        annotationview.image = nil;
        annotationview.animatesDrop = YES;
        annotationview.canShowCallout = NO;
        
        return annotationview;
    }
    
    return nil;
}

-(void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    
    //CustomPointAnnotation 是自定义的marker标注点，通过这个来得到添加marker时设置的pointCalloutInfo属性
    CustomPointAnnotation *annn = (CustomPointAnnotation *)view.annotation;
    
    if ([view.annotation isKindOfClass:[CustomPointAnnotation class]]) {
        //如果点到了这个marker点，什么也不做
        if (_calloutMapAnnotation.coordinate.latitude == view.annotation.coordinate.latitude && _calloutMapAnnotation.coordinate.longitude == view.annotation.coordinate.longitude) {
            return;
        }
        
        //如果当前显示着calloutview，又触发了select方法，删除这个calloutview annotation
        if (_calloutMapAnnotation) {
            [_mapView removeAnnotation:_calloutMapAnnotation];
            _calloutMapAnnotation = nil;
        }
        
        //创建搭载自定义calloutview的annotation
//        _calloutMapAnnotation = [[CalloutMapAnnotation alloc] initWithLatitude:view.annotation.coordinate.latitude andLongitude:view.annotation.coordinate.longitude];
//        
//        //把通过marker(ZNBCPointAnnotation)设置的pointCalloutInfo信息赋值给CalloutMapAnnotation
//        _calloutMapAnnotation.nearFriend = annn.nearFriend;
//        
//        [_mapView addAnnotation:_calloutMapAnnotation];
//        [_mapView setCenterCoordinate:view.annotation.coordinate animated:YES];
        
        //直接打开个人信息页
        SettingViewController *settingViewController = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
        [settingViewController setMemberid:annn.nearFriend.memberID];
        [self.navigationController pushViewController:settingViewController animated:YES];
    }
    
}

-(void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view{
    
    if (_calloutMapAnnotation && ![view isKindOfClass:[CallOutAnnotationView class]]) {
        
        if (_calloutMapAnnotation.coordinate.latitude == view.annotation.coordinate.latitude && _calloutMapAnnotation.coordinate.longitude == view.annotation.coordinate.longitude) {
            [_mapView removeAnnotation:_calloutMapAnnotation];
            _calloutMapAnnotation = nil;
        }
    }
    
}

// Override
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view;
{
    NSLog(@"paopaoclick: %d", view.tag);
    
    if ([view isKindOfClass:[CallOutAnnotationView class]]) {
        
        CallOutAnnotationView *calloutannotationview = (CallOutAnnotationView *)view;
        
        SettingViewController *settingViewController = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
        [settingViewController setMemberid:calloutannotationview.busInfoView.nearFriend.memberID];
        [self.navigationController pushViewController:settingViewController animated:YES];
    }
    
}

- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay
{
	if ([overlay isKindOfClass:[BMKCircle class]])
    {
        BMKCircleView* circleView = [[BMKCircleView alloc] initWithOverlay:overlay];
        circleView.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
        circleView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
        circleView.lineWidth = 5.0;
		return circleView;
    }
    
    if ([overlay isKindOfClass:[BMKPolyline class]])
    {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.strokeColor = [[UIColor redColor] colorWithAlphaComponent:1];
        polylineView.lineWidth = 3.0;
		return polylineView;
    }
	
	if ([overlay isKindOfClass:[BMKPolygon class]])
    {
        BMKPolygonView* polygonView = [[BMKPolygonView alloc] initWithOverlay:overlay];
        polygonView.strokeColor = [[UIColor purpleColor] colorWithAlphaComponent:1];
        polygonView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:0.2];
        polygonView.lineWidth =2.0;
		return polygonView;
    }
	return nil;
}

#pragma map view delegate

/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)mapViewWillStartLocatingUser:(BMKMapView *)mapView
{
	NSLog(@"start locate");
}

/**
 *用户位置更新后，会调用此函数
 *@param mapView 地图View
 *@param userLocation 新的用户位置
 */

- (void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation
{
	if (userLocation != nil) {
        
        NSString *templocation = [NSString stringWithFormat:@"%f,%f", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude];
        NSLog(@"templocation: %@", templocation);
        
        _currentLocation = templocation;
        
        //test
//        _currentLocation = @"113.316166,23.116726";
        
        //得到坐标后停止
        _mapView.showsUserLocation = NO;
        
        //显示自己为地图中心
        CLLocationCoordinate2D center;
        NSArray *dl = [_currentLocation componentsSeparatedByString:@","];
        center.latitude = [[dl objectAtIndex:0] doubleValue];
        center.longitude = [[dl objectAtIndex:1] doubleValue];
        [_mapView setCenterCoordinate:center animated:NO];
        
        //记录用户坐标
        [self doSetGPS:templocation];
        
        //地图上显示自己
        NSString *memberid = [UserSessionManager GetInstance].currentRunUser.userid;
        NearFriend *tempnearfriend = [[NearFriend alloc] init];
        tempnearfriend.nickName = [UserSessionManager GetInstance].currentRunUser.nickname;
        tempnearfriend.headImg = [UserSessionManager GetInstance].currentRunUser.headImg;
        tempnearfriend.distance = 0;
        NSDate *currrentDate = [NSDate date];
        tempnearfriend.loginTime = [PCommonUtil formatDate:currrentDate formatter:@"yyyy-MM-dd HH:mm"];
        tempnearfriend.gps = _currentLocation;
        tempnearfriend.memberID = [memberid longLongValue];
        
        CustomPointAnnotation *pointAnnotation = [[CustomPointAnnotation alloc] init];
        pointAnnotation.coordinate = center;
        pointAnnotation.title = @"Owner";
        pointAnnotation.nearFriend = tempnearfriend;
        [_mapView addAnnotation:pointAnnotation];
        
//        BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
//        annotation.coordinate = center;
//        annotation.title = @"Owner";
//        [_mapView addAnnotation:annotation];
        
        [_mapView setZoomLevel:11];
        
        [self initData];
        
	}
	
}
/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)mapViewDidStopLocatingUser:(BMKMapView *)mapView
{
    NSLog(@"stop locate");
}
/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
}

#pragma EGOImageLoaderObserver
-(void)imageLoaderDidFailToLoad:(NSNotification *)notification{
    
    NSLog(@"imageLoaderDidFailToLoad...%@", notification);
    
}

-(void)imageLoaderDidLoad:(NSNotification *)notification{
    
    NSLog(@"imageLoaderDidLoad...%@", notification);
    
}

@end
