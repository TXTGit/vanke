//
//  RunRecordListViewController.m
//  vanke
//
//  Created by pig on 13-6-10.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "RunRecordListViewController.h"
#import "UIImage+PImageCategory.h"
#import "RunRecord.h"
#import "RunRecordCell.h"
#import "RunUser.h"
#import "UserSessionManager.h"
#import "PCommonUtil.h"
#import "RunResultViewController.h"
#import "VankeAPI.h"
#import "AFJSONRequestOperation.h"
#import "IndexViewController.h"
#import "NoticeViewController.h"
#import "ChatViewController.h"
#import "SettingViewController.h"
#import "ChatlistViewController.h"
#import "AppDelegate.h"

@interface RunRecordListViewController ()

@end

@implementation RunRecordListViewController

@synthesize navView = _navView;
@synthesize menuOfHeadView = _menuOfHeadView;
@synthesize menuOfCustomWindow = _menuOfCustomWindow;

@synthesize runRecordTableView = _runRecordTableView;
@synthesize indicatorView = _indicatorView;

@synthesize recordList = _recordList;
@synthesize database = _database;

@synthesize isComeFromRunResultView = _isComeFromRunResultView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _isComeFromRunResultView = NO;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    float height = [UIScreen mainScreen].bounds.size.height - 20;
    
    //nav bar
    _navView = [[PCustomNavigationBarView alloc] initWithTitle:@"跑步记录列表" bgImageView:@"index_nav_bg"];
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
    [_navView.rightButton addTarget:self action:@selector(touchMenuAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *messageTip = [UIImage imageWithName:@"index_button_new" type:@"png"];
    [_navView.messageTipImageView setImage:messageTip];
//    [_navView.messageTipImageView setHidden:NO];
    
    //menu of head
    UIView *transparentByForMenu = [[UIView alloc] init];
    transparentByForMenu.frame = CGRectMake(0, 0, 320, height);
    UITapGestureRecognizer *tapViewForMenu = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchOutOfMenuAction:)];
    tapViewForMenu.cancelsTouchesInView = NO;
    [transparentByForMenu addGestureRecognizer:tapViewForMenu];
    
    _menuOfHeadView = [[PDropdownMenuView alloc] initDropdownMenuOfHead:CGRectMake(270, 70, 57, 210)];
    [transparentByForMenu addSubview:_menuOfHeadView];
    _menuOfCustomWindow = [[CustomWindow alloc] initWithView:transparentByForMenu];
    
    //menu of head 1
    [_menuOfHeadView.btnMenu1 addTarget:self action:@selector(touchHomeAction:) forControlEvents:UIControlEventTouchUpInside];
    [_menuOfHeadView.btnMenu2 addTarget:self action:@selector(touchChatAction:) forControlEvents:UIControlEventTouchUpInside];
    [_menuOfHeadView.btnMenu3 addTarget:self action:@selector(touchNoticeAction:) forControlEvents:UIControlEventTouchUpInside];
    [_menuOfHeadView.btnMenu4 addTarget:self action:@selector(touchSettingAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //tableview
    UIImageView *bgImageView = [[UIImageView alloc] init];
    [bgImageView setFrame:CGRectMake(0, 0, 320, height - 44)];
    [bgImageView setImage:[UIImage imageWithName:@"run_bg" type:@"png"]];
    _runRecordTableView.backgroundColor = [UIColor clearColor];
    _runRecordTableView.backgroundView = bgImageView;
    _runRecordTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _runRecordTableView.frame = CGRectMake(0, 44, 320, height - 44);
    
    //data
    _recordList = [[NSMutableArray alloc] init];
    
    //from net
    [self initData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)touchMenuAction:(id)sender{
//    
//    NSLog(@"touchMenuAction...");
//    
//    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut animations:^{
//        
//        _menuOfHeadView.hidden = NO;
//        _menuOfHeadView.alpha = 1.0f;
//        _menuOfHeadView.btnMenu1.alpha = 1.0f;
//        _menuOfHeadView.btnMenu2.alpha = 1.0f;
//        _menuOfHeadView.btnMenu3.alpha = 1.0f;
//        _menuOfHeadView.btnMenu4.alpha = 1.0f;
//        CGRect menuframe = _menuOfHeadView.frame;
//        _menuOfHeadView.frame = CGRectMake(menuframe.origin.x, menuframe.origin.y, menuframe.size.width, 210);
//        
//        [_menuOfCustomWindow show];
//        
//    } completion:^(BOOL finished) {
//        
//    }];
//    
//}
//
//-(void)touchOutOfMenuAction:(id)sender{
//    
//    NSLog(@"touchOutOfMenuAction...");
//    
//    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut animations:^{
//        
//        _menuOfHeadView.alpha = 0.0f;
//        _menuOfHeadView.btnMenu1.alpha = 0.0f;
//        _menuOfHeadView.btnMenu2.alpha = 0.0f;
//        _menuOfHeadView.btnMenu3.alpha = 0.0f;
//        _menuOfHeadView.btnMenu4.alpha = 0.0f;
//        CGRect menuframe = _menuOfHeadView.frame;
//        _menuOfHeadView.frame = CGRectMake(menuframe.origin.x, menuframe.origin.y, menuframe.size.width, 0);
//        
//    } completion:^(BOOL finished) {
//        
//        _menuOfCustomWindow.hidden = YES;
//        _menuOfHeadView.hidden = YES;
//        [_menuOfCustomWindow close];
//        
//    }];
//    
//}

//-(void)touchHomeAction:(id)sender{
//    
//    NSLog(@"touchHomeAction...");
//    
//}
//
//-(void)touchNoticeAction:(id)sender{
//    
//    NSLog(@"touchNoticeAction...");
//    
//    NoticeViewController *noticeViewController = [[NoticeViewController alloc] initWithNibName:@"NoticeViewController" bundle:nil];
//    [self.navigationController pushViewController:noticeViewController animated:YES];
//    
//}
//
//-(void)touchChatAction:(id)sender{
//    
//    NSLog(@"touchChatAction...");
//    
////    ChatViewController *chatViewController = [[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil];
////    [chatViewController setChatType:chatTypeDefault];
////    [self.navigationController pushViewController:chatViewController animated:YES];
//    
//    ChatlistViewController *chatListViewController = [[ChatlistViewController alloc]initWithNibName:@"ChatlistViewController" bundle:nil];
//    [self.navigationController pushViewController:chatListViewController animated:YES];
//}
//
//-(void)touchSettingAction:(id)sender{
//    
//    NSLog(@"touchSettingAction...");
//    
//    NSString *memberid = [UserSessionManager GetInstance].currentRunUser.userid;
//    SettingViewController *settingViewController = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
//    [settingViewController setMemberid:[memberid longLongValue]];
//    [self.navigationController pushViewController:settingViewController animated:YES];
//    
//}

//

-(void)initData{
    
//    [self showLocationData];
    [self getRunList];
    
}

-(void)getRunList{
    
    [_indicatorView startAnimating];
    
    NSString *memberid = [UserSessionManager GetInstance].currentRunUser.userid;
    NSString *memberUrl = [VankeAPI getGetRunListUrl:memberid page:1 rows:20];
    NSURL *url = [NSURL URLWithString:memberUrl];
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
                RunRecord *runrecord = [RunRecord initWithNSDictionary:dicrecord];
                [_recordList addObject:runrecord];
            }
            
            [_runRecordTableView reloadData];
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
        
        if(_indicatorView.isAnimating){
            [_indicatorView stopAnimating];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"failure: %@", error);
        
        if(_indicatorView.isAnimating){
            [_indicatorView stopAnimating];
        }
        
    }];
    [operation start];
    
}

-(void)showLocationData{
    
    //
    NSString *docsdir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *sqlitePath = [docsdir stringByAppendingPathComponent:@"user.sqlite"];
    NSLog(@"sqlitePath: %@", sqlitePath);
    _database = [FMDatabase databaseWithPath:sqlitePath];
    
    [_database open];
    
    FMResultSet *rs = [_database executeQuery:@"select sum(distance) as totaldistance, sum(runtime) as totalruntime, runingOneTimeId from RUN_RECORD_DATA group by runingOneTimeId"];
    
    while ([rs next]) {
        
        long totaldistance = [rs longForColumn:@"totaldistance"];
        long totalruntime = [rs longForColumn:@"totalruntime"];
        long runingOneTimeId = [rs longForColumn:@"runingOneTimeId"];
        NSLog(@"totaldistance: %ld, totalruntime: %ld", totaldistance, totalruntime);
        
        RunRecord *runRecord = [[RunRecord alloc] init];
        runRecord.mileage = totaldistance / 1000;
        runRecord.minute = totalruntime / 60;
        runRecord.speed = (float)(totaldistance / totalruntime);
        runRecord.runingOneTimeId = runingOneTimeId;
        runRecord.runId = runingOneTimeId;
        
        RunUser *runner = [UserSessionManager GetInstance].currentRunUser;
        runRecord.calorie = [PCommonUtil calcCalorie:runner.weight distance:totaldistance/1000];
        
        [_recordList addObject:runRecord];
        
    }
    
    [rs close];
    [_database close];
    
}

-(void)doBack{
    
    //如果是来自跑步结束界面，返回时，直接跳转到主页面
    if (_isComeFromRunResultView) {
        
        IndexViewController *indexViewController = [[IndexViewController alloc] initWithNibName:@"IndexViewController" bundle:nil];
        [self.navigationController pushViewController:indexViewController animated:YES];
        
    } else {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
}

#pragma mark - UITableView datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_recordList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"RecordTableCell";
	RunRecordCell *cell = (RunRecordCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"RunRecordCell" owner:self options:nil];
        cell = (RunRecordCell *)[nibContents objectAtIndex:0];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
    
    RunRecord *record = [_recordList objectAtIndex:indexPath.row];
    
    if (record.runTime && record.runTime.length > 11) {
        NSString *tempRunTime = record.runTime;
        
        cell.lblCreateTime.text = [NSString stringWithFormat:@"%@ %@", [tempRunTime substringToIndex:10], [tempRunTime substringFromIndex:11]];
    } else {
        cell.lblCreateTime.text = [NSString stringWithFormat:@"%@", record.runTime];
    }
    
    cell.lblRunDistance.text = [NSString stringWithFormat:@"%.2f km", record.mileage];
    cell.lblCalorie.text = [NSString stringWithFormat:@"%.2f", record.calorie];
//    cell.lblSpead.text = [NSString stringWithFormat:@"%.2f", record.speed];
    
    //平均速度
    float secondPerMileage = (record.mileage > 0.0001) ? record.minute * 60 / record.mileage : 0;
    int tempMinute = secondPerMileage / 60;
    int tempSecond = secondPerMileage - tempMinute * 60;
    
    NSString *tempspeedmm = [NSString stringWithFormat:@"%d", tempMinute];
    if (tempspeedmm.length == 1) {
        tempspeedmm = [NSString stringWithFormat:@"0%@", tempspeedmm];
    }
    NSString *tempspeedss = [NSString stringWithFormat:@"%d", tempSecond];
    if (tempspeedss.length == 1) {
        tempspeedss = [NSString stringWithFormat:@"0%@", tempspeedss];
    }
    cell.lblSpead.text = [NSString stringWithFormat:@"%@'%@\"", tempspeedmm, tempspeedss];
    
    NSLog(@"cell.frame.size.height: %f", cell.frame.size.height);
    
	return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 57;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RunRecord *record = [_recordList objectAtIndex:indexPath.row];
    
    RunResultViewController *runResultViewController = [[RunResultViewController alloc] initWithNibName:@"RunResultViewController" bundle:nil];
    record.secondOfRunning = record.minute * 60;
    [runResultViewController setRunRecord:record];
    [runResultViewController setIsHistory:YES];
    [self.navigationController pushViewController:runResultViewController animated:YES];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //更新未读提醒
    [[AppDelegate App] getUnreadList];
}

@end
