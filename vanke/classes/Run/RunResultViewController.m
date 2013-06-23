//
//  RunResultViewController.m
//  vanke
//
//  Created by pig on 13-6-10.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "RunResultViewController.h"
#import "UIImage+PImageCategory.h"
#import "RunUser.h"
#import "UserSessionManager.h"
#import "PCommonUtil.h"
#import "VankeAPI.h"
#import "AFJSONRequestOperation.h"
#import "RunRecordListViewController.h"
#import <QuartzCore/QuartzCore.h>

#import "GTMBase64.h"
#import "AFJSONRequestOperation.h"
#import "AFHTTPClient.h"

#import "MBProgressHUD.h"

@interface RunResultViewController ()

@end

@implementation RunResultViewController

@synthesize runResultBgImageView = _runResultBgImageView;
@synthesize navView = _navView;
@synthesize mapView = _mapView;

@synthesize lblRunDistance = _lblRunDistance;
@synthesize lblRunTime = _lblRunTime;
@synthesize lblCalorie = _lblCalorie;
@synthesize lblSpead = _lblSpead;
@synthesize btnCancel = _btnCancel;
@synthesize btnSure = _btnSure;

@synthesize runRecord = _runRecord;
@synthesize isHistory = _isHistory;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //bg
    _runResultBgImageView.hidden = YES;
    UIImageView *resultBg = [[UIImageView alloc] init];
    resultBg.frame = CGRectMake(0, 0, 320, 548);
    resultBg.image = [UIImage imageWithName:@"run_result_bg" type:@"png"];
    [self.view addSubview:resultBg];
    [self.view sendSubviewToBack:resultBg];
    
    //nav bar
    _navView = [[PCustomNavigationBarView alloc] initWithTitle:@"Hi! Mey" bgImageView:@"index_nav_bg"];
    [self.view addSubview:_navView];
    
    UIImage *indexBack = [UIImage imageWithName:@"main_back" type:@"png"];
    [_navView.leftButton setBackgroundImage:indexBack forState:UIControlStateNormal];
    [_navView.leftButton setHidden:NO];
    [_navView.leftButton addTarget:self action:@selector(doBack) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *indexHeadBg = [UIImage imageWithName:@"run_share" type:@"png"];
    [_navView.rightButton setBackgroundImage:indexHeadBg forState:UIControlStateNormal];
    [_navView.rightButton setHidden:NO];
    [_navView.rightButton addTarget:self action:@selector(doShare) forControlEvents:UIControlEventTouchUpInside];
    
    //show data
    _lblRunDistance.text = [NSString stringWithFormat:@"%.2f", _runRecord.mileage];
    _lblRunTime.text = [NSString stringWithFormat:@"%ld", _runRecord.minute];
    _lblCalorie.text = [NSString stringWithFormat:@"%.2f", _runRecord.calorie];
    
    float secondPerMileage = (_runRecord.mileage > 0.0001) ? _runRecord.secondOfRunning / _runRecord.mileage : 0;
    int tempMinute = secondPerMileage / 60;
    int tempSecond = secondPerMileage - tempMinute * 60;
    _lblSpead.text = [NSString stringWithFormat:@"%d'%d\"", tempMinute, tempSecond];
    
    //显示线路图
    int locationCount = _runRecord.locationList.count;
    CLLocationCoordinate2D coors[locationCount];
    for (int i=0; i<locationCount; i++) {
        NSString *location = [_runRecord.locationList objectAtIndex:i];
        NSArray *dl = [location componentsSeparatedByString:@","];
        coors[i].latitude = [[dl objectAtIndex:0] doubleValue];
        coors[i].longitude = [[dl objectAtIndex:1] doubleValue];
        
        if (i == 0) {
            BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
            annotation.coordinate = coors[i];
            annotation.title = @"起点";
            [_mapView addAnnotation:annotation];
        }
        
        if (i == locationCount / 2) {
            CLLocationCoordinate2D center = coors[i];
            [_mapView setCenterCoordinate:center animated:YES];
        }
        
        if (i == locationCount - 1) {
            BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
            annotation.coordinate = coors[i];
            annotation.title = @"终点";
            [_mapView addAnnotation:annotation];
        }
        
    }
    BMKPolyline* polyline = [BMKPolyline polylineWithCoordinates:coors count:locationCount];
    [_mapView addOverlay:polyline];
    
    [_mapView setZoomLevel:11];
    
    //提交数据
    if (locationCount > 0 && !_isHistory) {
        //最新的gps坐标位置
        NSString *location = [_runRecord.locationList objectAtIndex:0];
        [self doSetGPS:[NSString stringWithFormat:@"%ld", _runRecord.memberID] location:location];
        
        //跑步移动gps数据
        [self doSetRunLocationList];
        
    }
    
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotation = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        if ([annotation.title isEqualToString:@"起点"]) {
            newAnnotation.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"lbs_user_tip" ofType:@"png"]];
        } else if ([annotation.title isEqualToString:@"终点"]) {
            newAnnotation.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"lbs_user_tip" ofType:@"png"]];
        }
        newAnnotation.animatesDrop = YES;
        newAnnotation.canShowCallout = YES;
        newAnnotation.calloutOffset = CGPointMake(0,0);
        newAnnotation.draggable = NO;//拖动
        return newAnnotation;
    }
    return nil;
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    //判断是否是历史记录
    if (_isHistory) {
        _btnCancel.hidden = YES;
        _btnSure.hidden = YES;
    }
    
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)doBack{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark 分享
-(void)doShare{
    NSLog(@"doShare...");
    
    //screenshots
    UIImage *mapimage = [self glToUIImage];
//    UIImage *tipimage = [self capture:_mapView];
    UIImage *tipimage = [UIImage imageWithName:@"lbs_user_tip" type:@"png"];
    UIImage *image = [self mergerImage:mapimage secodImage:tipimage];
    
    //保存图像
//    NSDate *nowDate = [NSDate date];
//    long forImageName = [nowDate timeIntervalSince1970];
//    NSString *path = [NSHomeDirectory() stringByAppendingFormat:@"/%ld.png", forImageName];
//    if ([UIImagePNGRepresentation(image) writeToFile:path atomically:YES]) {
//        NSLog(@"Successful...");
//    } else {
//        NSLog(@"failure...");
//    }
    
//    UIGraphicsBeginImageContext(self.mapView.frame.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSaveGState(context);
//    UIRectClip(CGRectMake(0, 0, 320, 190));
//    [self.mapView.layer renderInContext:context];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    
    
    NSString *setShareUrl = [VankeAPI getSendShareUrl:[NSString stringWithFormat:@"%ld", _runRecord.memberID] shareContent:[NSString stringWithFormat:@"%@完成了%@公里",[UserSessionManager GetInstance].currentRunUser.mobile,_lblRunDistance.text]];
    
    
    NSData *imageData = UIImagePNGRepresentation(image);
    NSString *base64data = [[NSString alloc] initWithData:[GTMBase64 encodeData:imageData] encoding:NSUTF8StringEncoding];
    
//    NSLog(@"base64data: %@", base64data);
    
    NSDictionary *dicParam = [NSDictionary dictionaryWithObjectsAndKeys:base64data, @"shareImg", nil];
    NSURL *url = [NSURL URLWithString:setShareUrl];
    
//    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
//    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:nil parameters:dicParam constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        [formData appendPartWithFileData:imageData name:@"shareImg" fileName:@"23_201306200600.jpg" mimeType:@"image/jpeg"];
//    }];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:nil parameters:dicParam constructingBodyWithBlock:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"App.net Global Stream: %@", JSON);
        NSDictionary *dicResult = JSON;
        NSString *status = [dicResult objectForKey:@"status"];
        NSString *msg = [dicResult objectForKey:@"msg"];
        NSLog(@"status: %@, msg: %@", status, msg);
        if ([status isEqual:@"0"]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            
            // Configure for text only and offset down
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"分享成功";
            hud.margin = 10.f;
            hud.yOffset = 0.f;
            hud.removeFromSuperViewOnHide = YES;
            
            [hud hide:YES afterDelay:3];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"failure: %@", error);
    }];
    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
    }];
    
    [operation start];
}

// get the current view screen shot
#pragma mark 截屏

-(UIImage *)glToUIImage{
    
    int width = 310 * 2;
    int height = 190 * 2;
    
    NSInteger myDataLength = width * height * 4;
    
    // allocate array and read pixels into it.
    GLubyte *buffer = (GLubyte *) malloc(myDataLength);
    glReadPixels(0, 0, width, height, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
    
    // gl renders "upside down" so swap top to bottom into new array.
    // there's gotta be a better way, but this works.
    GLubyte *buffer2 = (GLubyte *) malloc(myDataLength);
    for(int y = 0; y <height; y++)
    {
        for(int x = 0; x <width * 4; x++)
        {
            buffer2[(height - 1 - y) * width * 4 + x] = buffer[y * 4 * width + x];
        }
    }
    
    // make data provider with data.
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, buffer2, myDataLength, NULL);
    
    // prep the ingredients
    int bitsPerComponent = 8;
    int bitsPerPixel = 32;
    int bytesPerRow = 4 * width;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    
    // make the cgimage
    CGImageRef imageRef = CGImageCreate(width, height, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
    
    // then make the uiimage from that
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    
    return image;
}

//截取图片的位置tip
- (UIImage *) capture:(BMKMapView *)tmapview {
    
    UIImage *tempImage = nil;
    
    if (tmapview) {
        // Create a graphics context with the target size
        // On iOS 4 and later, use UIGraphicsBeginImageContextWithOptions to take the scale into consideration
        // On iOS prior to 4, fall back to use UIGraphicsBeginImageContext
        CGSize imageSize = tmapview.frame.size;
        if (NULL != UIGraphicsBeginImageContextWithOptions) {
            UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
        } else {
            UIGraphicsBeginImageContext(imageSize);
        }
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        // Iterate over every window from back to front
        for (UIView *subView in [tmapview subviews])
        {
            if ([subView isKindOfClass:[BMKPinAnnotationView class]])
            {
                // Render the layer hierarchy to the current context
                [[subView layer] renderInContext:context];
                // Retrieve the screenshot image
                tempImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                break;
            }
        }
        
    }
    
    return tempImage;
}

//合并图片
-(UIImage *)mergerImage:(UIImage *)firstImage secodImage:(UIImage *)secondImage{
    
    CGSize imageSize = CGSizeMake(620, 380);
    UIGraphicsBeginImageContext(imageSize);
    
    [firstImage drawInRect:CGRectMake(0, 0, firstImage.size.width, firstImage.size.height)];
    [secondImage drawInRect:CGRectMake(310 - 40, 190 - 60, secondImage.size.width, secondImage.size.height)];
    
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
}

-(IBAction)doCancel:(id)sender{
    
    NSLog(@"doCancel...");
    
    [self doBack];
    
}

-(IBAction)doSure:(id)sender{
    
    NSLog(@"doSure...");
    
    _isHistory = YES;
    [self doGotoRunRecord];
    
}

-(void)doSetGPS:(NSString *)memberid location:(NSString *)location{
    
    NSString *setGpsUrl = [VankeAPI getSetGPSUrl:memberid gpsData:location];
    NSLog(@"setGpsUrl: %@", setGpsUrl);
    NSURL *url = [NSURL URLWithString:setGpsUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"App.net Global Stream: %@", JSON);
        NSDictionary *dicResult = JSON;
        NSString *status = [dicResult objectForKey:@"status"];
        NSLog(@"status: %@", status);
        if ([status isEqual:@"0"]) {
            NSLog(@"successfule...");
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"failure: %@", error);
    }];
    [operation start];
    
}
-(void)doSetRunLocationList{
    
    NSMutableString *tempGpsData = [[NSMutableString alloc] init];
    int gpsDataCount = [_runRecord.locationList count];
    for (int i=0; i<gpsDataCount; i++) {
        [tempGpsData appendString:[_runRecord.locationList objectAtIndex:i]];
        [tempGpsData appendString:@";"];
    }
    
    NSString *memberid = [NSString stringWithFormat:@"%ld", _runRecord.memberID];
    NSString *mileage = [NSString stringWithFormat:@"%f", _runRecord.mileage];
    NSString *line = [tempGpsData substringToIndex:tempGpsData.length - 1];
    
    NSString *setGpsUrl = [VankeAPI getRunUrl:memberid mileage:mileage minute:_runRecord.minute speed:_runRecord.speed calorie:_runRecord.calorie line:line runTime:_runRecord.runTime];
    NSLog(@"setRunGpsUrl: %@", setGpsUrl);
    NSURL *url = [NSURL URLWithString:setGpsUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"App.net Global Stream: %@", JSON);
        NSDictionary *dicResult = JSON;
        NSString *status = [dicResult objectForKey:@"status"];
        NSLog(@"status: %@", status);
        if ([status isEqual:@"0"]) {
            
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"failure: %@", error);
    }];
    [operation start];
    
}

-(void)doGotoRunRecord{
    
    RunRecordListViewController *runRecordListViewController = [[RunRecordListViewController alloc] initWithNibName:@"RunRecordListViewController" bundle:nil];
    [runRecordListViewController setIsComeFromRunResultView:YES];
    [self.navigationController pushViewController:runRecordListViewController animated:YES];
    
}

@end
