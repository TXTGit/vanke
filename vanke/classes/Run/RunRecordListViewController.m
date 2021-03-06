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

@synthesize achtionSheet = _achtionSheet;
@synthesize currentYear = _currentYear;
@synthesize currentMonth = _currentMonth;

@synthesize completeButton = _completeButton;
@synthesize cancellButton = _cancellButton;

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
    
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
//    _currentSelectedItem = [NSString stringWithFormat:@"%d%d",[dateComponent year],[dateComponent month]];
    _currentYear = [dateComponent year];
    _currentMonth = [dateComponent month];
    
    UIImage *indexBack = [UIImage imageWithName:@"main_back" type:@"png"];
    [_navView.leftButton setBackgroundImage:indexBack forState:UIControlStateNormal];
    [_navView.leftButton setHidden:NO];
    [_navView.leftButton addTarget:self action:@selector(doBack) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *indexHeadBg = [UIImage imageWithName:@"btn_bg" type:@"png"];
    [_navView.rightButton setBackgroundImage:indexHeadBg forState:UIControlStateNormal];
    [_navView.rightButton setTitle:[NSString stringWithFormat:@"%d月",_currentMonth] forState:UIControlStateNormal];
    [_navView.rightButton setHidden:NO];
    [_navView.rightButton setFrame:CGRectMake(258, 7, 56, 29)];
    [_navView.rightButton addTarget:self action:@selector(doSelectMonth:) forControlEvents:UIControlEventTouchUpInside];
    
    //tableview
    UIImageView *bgImageView = [[UIImageView alloc] init];
    [bgImageView setFrame:CGRectMake(0, 44, 320, 551)];
    [bgImageView setImage:[UIImage imageWithName:@"login_bg" type:@"png"]];
    
    [self.view insertSubview:bgImageView atIndex:0];
    
    _runRecordTableView.backgroundColor = [UIColor clearColor];
//    _runRecordTableView.backgroundView = bgImageView;
    _runRecordTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _runRecordTableView.frame = CGRectMake(0, 44, 320, height - 44);
    
    //data
    _recordList = [[NSMutableArray alloc] init];
    
    //from net
    [self initData];
    
}

-(IBAction)doSelectMonth:(id)sender
{
    NSLog(@"touchMenuAction...");
//    _currentSelectedItem = 1;
    if (!_achtionSheet) {
        _achtionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
        [_achtionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
        
        UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, 320, 150)];
        [pickerView setBackgroundColor:[UIColor blueColor]];
        pickerView.tag = 101;
        pickerView.delegate = self;
        pickerView.dataSource = self;
        pickerView.showsSelectionIndicator = YES;
        
        [_achtionSheet addSubview:pickerView];
    }
    
    _completeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"完成", nil]];
    [_completeButton setSegmentedControlStyle:UISegmentedControlStyleBar];
    [_completeButton setFrame:CGRectMake(270, 12, 50, 30)];
    [_completeButton addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    [_achtionSheet addSubview:_completeButton];
    
    _cancellButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"取消", nil]];
    [_cancellButton setSegmentedControlStyle:UISegmentedControlStyleBar];
    [_cancellButton setFrame:CGRectMake(208, 12, 50, 30)];
    [_cancellButton addTarget:self action:@selector(cancellAction) forControlEvents:UIControlEventValueChanged];
    [_achtionSheet addSubview:_cancellButton];
    
    [_achtionSheet showInView:self.view];
    [_achtionSheet setBounds:CGRectMake(0, 0, 320, 400)];
    [_achtionSheet setBackgroundColor:[UIColor whiteColor]];
}

-(void)cancellAction
{
    [_achtionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

-(void)segmentAction:(UISegmentedControl *)seg{
    NSInteger index = seg.selectedSegmentIndex;
    
    [_achtionSheet dismissWithClickedButtonIndex:index animated:YES];
    
    [_navView.rightButton setTitle:[NSString stringWithFormat:@"%d月",_currentMonth] forState:UIControlStateNormal];
    
    [self getRunList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initData{
    
//    [self showLocationData];
    [self getRunList];
    
}

-(void)getRunList{
    
    [_indicatorView startAnimating];
    
    [_recordList removeAllObjects];
    
    NSString *memberid = [UserSessionManager GetInstance].currentRunUser.userid;
    
    NSString *date = [NSString stringWithFormat:@"%d%0*d01",_currentYear,2,_currentMonth];
    
    NSString *memberUrl = [VankeAPI getGetRunListUrl:memberid date:date];
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

            [SVProgressHUD showErrorWithStatus:errMsg];
        }
        
        if(_indicatorView.isAnimating){
            [_indicatorView stopAnimating];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"failure: %@", error);
        
        if(_indicatorView.isAnimating){
            [_indicatorView stopAnimating];
        }
        [SVProgressHUD showErrorWithStatus:@"网络异常,请重试"];
        
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
    [record setMemberID:[[UserSessionManager GetInstance].currentRunUser.userid longLongValue]];
    [runResultViewController setRunRecord:record];
    [runResultViewController setIsHistory:YES];
    [self.navigationController pushViewController:runResultViewController animated:YES];
    
}

//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    //更新未读提醒
//    [[AppDelegate App] getUnreadList];
//}

#pragma delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSLog(@"actionSheet clickedButtonAtIndex...");
    
}

#pragma delegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 12;//1-5分,5个选项
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    float temp = [dateComponent month] - row;
    if (temp>0) {
        return [NSString stringWithFormat:@"%d年%.0f月", [dateComponent year], temp];
    }else{
        return [NSString stringWithFormat:@"%d年%.0f月", [dateComponent year] - 1, temp+12];
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
//    _currentSelectedItem = row + 1;
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    float temp = [dateComponent month] - row;
    if (temp>0) {
//        _currentSelectedItem =  [NSString stringWithFormat:@"%d%0*.0f", [dateComponent year], 2,temp];
        _currentYear = [dateComponent year];
        _currentMonth = temp;
    }else{
//        _currentSelectedItem =  [NSString stringWithFormat:@"%d%0*.0f", [dateComponent year] - 1,2, temp+12];
        _currentYear = [dateComponent year] - 1;
        _currentMonth = temp + 12;
    }
}

@end
