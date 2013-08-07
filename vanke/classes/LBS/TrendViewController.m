//
//  TrendViewController.m
//  vanke
//
//  Created by pig on 13-6-12.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "TrendViewController.h"
#import "UIImage+PImageCategory.h"
#import "UserSessionManager.h"
#import "AFJSONRequestOperation.h"
#import "TrendCell.h"
#import "VankeAPI.h"
#import "TrendInfo.h"
#import "PCommonUtil.h"
#import "AppDelegate.h"

@interface TrendViewController ()

@end

@implementation TrendViewController

@synthesize navView = _navView;
@synthesize trendTableView = _trendTableView;
@synthesize indicatorView = _indicatorView;

@synthesize trendList = _trendList;

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
    
    //nav bar
    _navView = [[PCustomNavigationBarView alloc] initWithTitle:@"跑友动态" bgImageView:@"index_nav_bg"];
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
    
    //bg
    float height = [UIScreen mainScreen].bounds.size.height - 20;
    
    UIImageView *bgImageView = [[UIImageView alloc] init];
    [bgImageView setFrame:CGRectMake(0, 44, 320, 551)];
    [bgImageView setImage:[UIImage imageWithName:@"login_bg" type:@"png"]];
    [self.view insertSubview:bgImageView atIndex:0];
    
    //tableview
    _trendTableView.backgroundColor = [UIColor clearColor];
    _trendTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _trendTableView.frame = CGRectMake(0, 44, 320, height - 44);
    _trendTableView.delegate = self;
    
    [self initData];
    
    //data
    _trendList = [[NSMutableArray alloc] init];
}

-(void)initData{
    
    [_indicatorView startAnimating];
    
    NSString *memberid = [UserSessionManager GetInstance].currentRunUser.userid;
//    NSString *tomemberid = [NSString stringWithFormat:@"%ld", _friendInfo.fromMemberID];
    //    NSString *memberid = @"23";//测试用MemberID，测试完成删除
    //    NSString *tomemberid = @"33";//测试用MemberId，测试完成删除
    //    _friendInfo.fromMemberID = 33;
    //    _friendInfo.toMemberID = 23;
    NSString *msgListUrl = [VankeAPI getShareListUrl:memberid page:1 rows:10];
    NSURL *url = [NSURL URLWithString:msgListUrl];
    NSLog(@"url:%@",url);
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
                TrendInfo *trendInfo = [TrendInfo initWithNSDictionary:dicrecord];
                [_trendList addObject:trendInfo];
                NSLog(@"shareContent:%@",trendInfo.shareContent);
            }
            
            [_trendTableView reloadData];
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

#pragma mark - UITableView datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"trendList:%d",[_trendList count]);
    return [_trendList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"TrendTableCell";
	TrendCell *cell = (TrendCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"TrendCell" owner:self options:nil];
        cell = (TrendCell *)[nibContents objectAtIndex:0];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
    
    TrendInfo *trendInfo = [_trendList objectAtIndex:indexPath.row];
    NSLog(@"indePah.row:%d",indexPath.row);
    if (trendInfo) {
        cell.trendInfo = trendInfo;
        
        [cell updateView];
    }
	return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TrendCell *cell = (TrendCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"cell.frame.size.height: %f", cell.frame.size.height);
    return cell.frame.size.height;
    
    //    return 57;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)doBack{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewDidUnload {
    [self setTrendTableView:nil];
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //更新未读提醒
    [[AppDelegate App] getUnreadList];
}

@end
