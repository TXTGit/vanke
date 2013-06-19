//
//  RunResultViewController.h
//  vanke
//
//  Created by pig on 13-6-10.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCustomNavigationBarView.h"
#import "BMapKit.h"
#import "RunRecord.h"

@interface RunResultViewController : UIViewController<BMKMapViewDelegate>

@property (nonatomic, retain) IBOutlet UIImageView *runResultBgImageView;
@property (nonatomic, retain) PCustomNavigationBarView *navView;
@property (nonatomic, retain) IBOutlet BMKMapView* mapView;

@property (nonatomic, retain) IBOutlet UILabel *lblRunDistance;
@property (nonatomic, retain) IBOutlet UILabel *lblRunTime;
@property (nonatomic, retain) IBOutlet UILabel *lblCalorie;
@property (nonatomic, retain) IBOutlet UILabel *lblSpead;
@property (nonatomic, retain) IBOutlet UIButton *btnCancel;
@property (nonatomic, retain) IBOutlet UIButton *btnSure;

@property (nonatomic, retain) RunRecord *runRecord;
@property (nonatomic, assign) BOOL isHistory;

-(void)doBack;
-(IBAction)doCancel:(id)sender;
-(IBAction)doSure:(id)sender;
-(void)doSetGPS:(NSString *)memberid location:(NSString *)location;
-(void)doSetRunLocationList;
-(void)doGotoRunRecord;

@end
