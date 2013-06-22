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
#import "RunViewController.h"

@interface RunRecordListViewController ()

@end

@implementation RunRecordListViewController

@synthesize navView = _navView;
@synthesize runRecordTableView = _runRecordTableView;

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
    
    UIImage *indexHeadBg = [UIImage imageWithName:@"main_head" type:@"png"];
    [_navView.rightButton setBackgroundImage:indexHeadBg forState:UIControlStateNormal];
    [_navView.rightButton setHidden:NO];
    //    [_navView.rightButton addTarget:self action:@selector(touchMenuAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *messageTip = [UIImage imageWithName:@"index_button_new" type:@"png"];
    [_navView.messageTipImageView setImage:messageTip];
    [_navView.messageTipImageView setHidden:NO];
    
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

-(void)initData{
    
//    [self showLocationData];
    [self getRunList];
    
}

-(void)getRunList{
    
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
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"failure: %@", error);
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
        
        RunViewController *runViewController = [[RunViewController alloc] initWithNibName:@"RunViewController" bundle:nil];
        [self.navigationController pushViewController:runViewController animated:YES];
        
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
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
    
    RunRecord *record = [_recordList objectAtIndex:indexPath.row];
    
    cell.lblCreateTime.text = [NSString stringWithFormat:@"%@", record.runTime];
    cell.lblRunDistance.text = [NSString stringWithFormat:@"%.2f", record.mileage];
    cell.lblCalorie.text = [NSString stringWithFormat:@"%.2f", record.calorie];
    cell.lblSpead.text = [NSString stringWithFormat:@"%.2f", record.speed];
    
    NSLog(@"cell.frame.size.height: %f", cell.frame.size.height);
    
	return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 57;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RunRecord *record = [_recordList objectAtIndex:indexPath.row];
    
    RunResultViewController *runResultViewController = [[RunResultViewController alloc] initWithNibName:@"RunResultViewController" bundle:nil];
    [runResultViewController setRunRecord:record];
    [runResultViewController setIsHistory:YES];
    [self.navigationController pushViewController:runResultViewController animated:YES];
    
}

@end
