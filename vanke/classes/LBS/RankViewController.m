//
//  RankViewController.m
//  vanke
//
//  Created by pig on 13-6-12.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "RankViewController.h"
#import "UIImage+PImageCategory.h"
#import "UserSessionManager.h"
#import "VankeAPI.h"
#import "AFJSONRequestOperation.h"
#import "RankInfo.h"
#import "RankCell.h"
#import "SettingViewController.h"
#import "PCommonUtil.h"
#import "AppDelegate.h"

@interface RankViewController ()

@end

@implementation RankViewController

@synthesize navView = _navView;

@synthesize btnFanRank = _btnFanRank;
@synthesize fanArrawImageView = _fanArrawImageView;
@synthesize btnCommunityRank = _btnCommunityRank;
@synthesize communityArrawImageView = _communityArrawImageView;
@synthesize btnTotalRank = _btnTotalRank;
@synthesize totalArrawImageView = _totalArrawImageView;

@synthesize rankTableView = _rankTableView;
@synthesize indicatorView = _indicatorView;

@synthesize fanRankList = _fanRankList;
@synthesize communityRankList = _communityRankList;
@synthesize totalRankList = _totalRankList;

@synthesize showRankType = _showRankType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _showRankType = 1;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    float height = [UIScreen mainScreen].bounds.size.height - 20;
    
    //nav bar
    _navView = [[PCustomNavigationBarView alloc] initWithTitle:@"排名" bgImageView:@"index_nav_bg"];
    [self.view addSubview:_navView];
    
    UIImage *indexBack = [UIImage imageWithName:@"main_back" type:@"png"];
    [_navView.leftButton setBackgroundImage:indexBack forState:UIControlStateNormal];
    [_navView.leftButton setHidden:NO];
    [_navView.leftButton addTarget:self action:@selector(doBack) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *indexHeadBg = [UIImage imageWithName:@"lbs_rank_selected_arraw" type:@"png"];
    [_navView.rightButton setBackgroundImage:indexHeadBg forState:UIControlStateNormal];
    [_navView.rightButton addTarget:self action:@selector(doShowRankSelect:) forControlEvents:UIControlEventTouchUpInside];
    [_navView.rightButton setHidden:NO];
    
    //current show data
    [self updateCurrentArraw];
    
    //tableview
    _rankTableView.backgroundColor = [UIColor clearColor];
    _rankTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _rankTableView.frame = CGRectMake(0, 89, 320, height - 44 - 45);
    
    //data
    _fanRankList = [[NSMutableArray alloc] init];
    _communityRankList = [[NSMutableArray alloc] init];
    _totalRankList = [[NSMutableArray alloc] init];
    
    //from net
    [self initData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)doBack{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)initData{
    
    [_indicatorView startAnimating];
    
    [self getFanRankListByType:1];
    [self getCommunityRankListByType:1];
    [self getTotalRankListByType:1];
    
}

//跑友圈
-(void)getFanRankListByType:(int)rankType{
    
    NSString *memberid = [UserSessionManager GetInstance].currentRunUser.userid;
    NSString *fanListUrl = [VankeAPI getGetFanRankListUrl:memberid rankType:rankType];
    NSURL *url = [NSURL URLWithString:fanListUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"getFanRankList: %@", JSON);
        NSDictionary *dicResult = JSON;
        NSString *status = [dicResult objectForKey:@"status"];
        NSLog(@"status: %@", status);
        if ([status isEqual:@"0"]) {
            
            [_fanRankList removeAllObjects];
            
            NSArray *datalist = [dicResult objectForKey:@"list"];
            int datalistCount = [datalist count];
            for (int i=0; i<datalistCount; i++) {
                NSDictionary *dicrecord = [datalist objectAtIndex:i];
                RankInfo *rankinfo = [RankInfo initWithNSDictionary:dicrecord];
                
                [_fanRankList addObject:rankinfo];
            }
            
            [_rankTableView reloadData];
        }else{
            NSString *errMsg = [dicResult objectForKey:@"msg"];
//            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
//            
//            // Configure for text only and offset down
//            hud.mode = MBProgressHUDModeText;
//            hud.labelText = errMsg;
//            hud.margin = 10.f;
//            hud.yOffset = 150.0f;
//            hud.removeFromSuperViewOnHide = YES;
//            [hud hide:YES afterDelay:2];
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

//社区
-(void)getCommunityRankListByType:(int)rankType{
    
    NSString *memberid = [UserSessionManager GetInstance].currentRunUser.userid;
    NSString *communityListUrl = [VankeAPI getGetCommunityRankListUrl:memberid rankType:rankType];
    NSURL *url = [NSURL URLWithString:communityListUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"getCommunityRankList: %@", JSON);
        NSDictionary *dicResult = JSON;
        NSString *status = [dicResult objectForKey:@"status"];
        NSLog(@"status: %@", status);
        if ([status isEqual:@"0"]) {
            
            [_communityRankList removeAllObjects];
            
            NSArray *datalist = [dicResult objectForKey:@"list"];
            int datalistCount = [datalist count];
            for (int i=0; i<datalistCount; i++) {
                NSDictionary *dicrecord = [datalist objectAtIndex:i];
                RankInfo *rankinfo = [RankInfo initWithNSDictionary:dicrecord];
                
                [_communityRankList addObject:rankinfo];
            }
            
            [_rankTableView reloadData];
        }else{
            NSString *errMsg = [dicResult objectForKey:@"msg"];
//            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
//            
//            // Configure for text only and offset down
//            hud.mode = MBProgressHUDModeText;
//            hud.labelText = errMsg;
//            hud.margin = 10.f;
//            hud.yOffset = 150.0f;
//            hud.removeFromSuperViewOnHide = YES;
//            [hud hide:YES afterDelay:2];
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

//获取总排名列表getTotalRankList（2013-7-10）
-(void)getTotalRankListByType:(int)rankType{
    
    NSString *memberid = [UserSessionManager GetInstance].currentRunUser.userid;
    NSString *totalRankListUrl = [VankeAPI getGetTotalRankListUrl:memberid rankType:rankType];
    NSURL *url = [NSURL URLWithString:totalRankListUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"getGetTotalRankListUrl: %@", JSON);
        NSDictionary *dicResult = JSON;
        NSString *status = [dicResult objectForKey:@"status"];
        NSLog(@"status: %@", status);
        if ([status isEqual:@"0"]) {
            
            [_totalRankList removeAllObjects];
            
            NSArray *datalist = [dicResult objectForKey:@"list"];
            int datalistCount = [datalist count];
            for (int i=0; i<datalistCount; i++) {
                NSDictionary *dicrecord = [datalist objectAtIndex:i];
                RankInfo *rankinfo = [RankInfo initWithNSDictionary:dicrecord];
                
                [_totalRankList addObject:rankinfo];
            }
            
            [_rankTableView reloadData];
        }else{
            NSString *errMsg = [dicResult objectForKey:@"msg"];
//            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
//            
//            // Configure for text only and offset down
//            hud.mode = MBProgressHUDModeText;
//            hud.labelText = errMsg;
//            hud.margin = 10.f;
//            hud.yOffset = 150.0f;
//            hud.removeFromSuperViewOnHide = YES;
//            [hud hide:YES afterDelay:2];
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

-(void)showRanklist:(int)currentShowRankType rankType:(int)rankType{
    
    [_indicatorView startAnimating];
    
    NSString *memberid = [UserSessionManager GetInstance].currentRunUser.userid;
    NSString *rankListUrl = nil;
    if (currentShowRankType == 1) {
        rankListUrl = [VankeAPI getGetFanRankListUrl:memberid rankType:rankType];
    } else if (currentShowRankType == 2) {
        rankListUrl = [VankeAPI getGetCommunityRankListUrl:memberid rankType:rankType];
    } else if (currentShowRankType == 3) {
        rankListUrl = [VankeAPI getGetTotalRankListUrl:memberid rankType:rankType];
    } else {
        rankListUrl = [VankeAPI getGetFanRankListUrl:memberid rankType:rankType];
    }
    NSLog(@"rankListUrl: %@", rankListUrl);
    
    NSURL *url = [NSURL URLWithString:rankListUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"showRanklist: %@", JSON);
        NSDictionary *dicResult = JSON;
        NSString *status = [dicResult objectForKey:@"status"];
        NSLog(@"status: %@", status);
        if ([status isEqual:@"0"]) {
            
            NSMutableArray *tempRankList = [[NSMutableArray alloc] init];
            
            NSArray *datalist = [dicResult objectForKey:@"list"];
            int datalistCount = [datalist count];
            for (int i=0; i<datalistCount; i++) {
                NSDictionary *dicrecord = [datalist objectAtIndex:i];
                RankInfo *rankinfo = [RankInfo initWithNSDictionary:dicrecord];
                
                [tempRankList addObject:rankinfo];
            }
            
            if (currentShowRankType == 1) {
                [_fanRankList removeAllObjects];
                [_fanRankList addObjectsFromArray:tempRankList];
            } else if (currentShowRankType == 2) {
                [_communityRankList removeAllObjects];
                [_communityRankList addObjectsFromArray:tempRankList];
            } else if (currentShowRankType == 3) {
                [_totalRankList removeAllObjects];
                [_totalRankList addObjectsFromArray:tempRankList];
            }
            
            [_rankTableView reloadData];
        }else{
            NSString *errMsg = [dicResult objectForKey:@"msg"];
//            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
//            
//            // Configure for text only and offset down
//            hud.mode = MBProgressHUDModeText;
//            hud.labelText = errMsg;
//            hud.margin = 10.f;
//            hud.yOffset = 150.0f;
//            hud.removeFromSuperViewOnHide = YES;
//            [hud hide:YES afterDelay:2];
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

#pragma mark - UITableView datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_showRankType == 1) {
        return [_fanRankList count];
    } else if (_showRankType == 2) {
        return [_communityRankList count];
    } else if (_showRankType == 3) {
        return [_totalRankList count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"RankTableCell";
	RankCell *cell = (RankCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"RankCell" owner:self options:nil];
        cell = (RankCell *)[nibContents objectAtIndex:0];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
    
    RankInfo *temprankinfo = nil;
    if (_showRankType == 1) {
        temprankinfo = [_fanRankList objectAtIndex:indexPath.row];
    } else if (_showRankType == 2) {
        temprankinfo = [_communityRankList objectAtIndex:indexPath.row];
    } else if (_showRankType == 3) {
        temprankinfo = [_totalRankList objectAtIndex:indexPath.row];
    }
    
    int temprank = temprankinfo.rank;
    cell.lblRank.text = [NSString stringWithFormat:@"%d", temprank];
    if ([PCommonUtil checkDataIsNull:temprankinfo.headImg]) {
        cell.headImageView.placeholderImage = [UIImage imageWithName:@"main_head"];
        cell.headImageView.imageURL = [NSURL URLWithString:[PCommonUtil getHeadImgUrl:temprankinfo.headImg]];
    }
    cell.headImageView.tag = temprankinfo.memberID;
    [cell.headImageView removeTarget:self action:@selector(doGotoSetting:) forControlEvents:UIControlEventTouchUpInside];
    [cell.headImageView addTarget:self action:@selector(doGotoSetting:) forControlEvents:UIControlEventTouchUpInside];
    cell.lblNickname.text = temprankinfo.nickName;
    cell.lblTime.text = temprankinfo.loginTime;
    cell.lblEnergy.text = [NSString stringWithFormat:@"%.2f", temprankinfo.mileage];
    if (temprankinfo.isFan > 0) {
        cell.isFriendImageView.hidden = NO;
    } else {
        cell.isFriendImageView.hidden = YES;
    }
    
    if (indexPath.row < 3) {
        cell.lblRank.textColor = [UIColor colorWithRed:249.0f/255.0f green:66.0f/255.0f blue:3.0f/255.0f alpha:1.0f];
        cell.lblNickname.textColor = [UIColor colorWithRed:249.0f/255.0f green:66.0f/255.0f blue:3.0f/255.0f alpha:1.0f];
        cell.lblEnergy.textColor = [UIColor colorWithRed:249.0f/255.0f green:66.0f/255.0f blue:3.0f/255.0f alpha:1.0f];
    } else {
        cell.lblRank.textColor = [UIColor whiteColor];
        cell.lblNickname.textColor = [UIColor whiteColor];
        cell.lblEnergy.textColor = [UIColor whiteColor];
    }
    
	return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 57;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RankInfo *temprankinfo = nil;
    if (_showRankType == 1) {
        temprankinfo = [_fanRankList objectAtIndex:indexPath.row];
    } else if (_showRankType == 2) {
        temprankinfo = [_communityRankList objectAtIndex:indexPath.row];
    } else if (_showRankType == 3) {
        temprankinfo = [_totalRankList objectAtIndex:indexPath.row];
    }
    
    
}

-(void)updateCurrentArraw{
    
    _fanArrawImageView.hidden = YES;
    _communityArrawImageView.hidden = YES;
    _totalArrawImageView.hidden = YES;
    
    if (_showRankType == 1) {
        _fanArrawImageView.hidden = NO;
    } else if (_showRankType == 2) {
        _communityArrawImageView.hidden = NO;
    } else if (_showRankType == 3) {
        _totalArrawImageView.hidden = NO;
    }
    
    
    
}

-(IBAction)doShowFanRank:(id)sender{
    
    NSLog(@"doShowFanRank...");
    
    _showRankType = 1;
    [self updateCurrentArraw];
    [_rankTableView reloadData];
    
}

-(IBAction)doShowCommunityRank:(id)sender{
    
    NSLog(@"doShowCommunityRank...");
    
    _showRankType = 2;
    [self updateCurrentArraw];
    [_rankTableView reloadData];
    
}

-(IBAction)doShowTotalRank:(id)sender{
    
    NSLog(@"doShowTotalRank...");
    
    _showRankType = 3;
    [self updateCurrentArraw];
    [_rankTableView reloadData];
    
}

-(IBAction)doShowRankSelect:(id)sender{
    
    //rankType：排名类型，总排名=1，年度排名=2，季度排名=3，月排名=4，周排名=5，日排名=6
    UIActionSheet *showActionSheet = [[UIActionSheet alloc] initWithTitle:@"排名选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"总排名", @"年度排名", @"季度排名", @"月排名", @"周排名", @"日排名", nil];
    showActionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [showActionSheet showInView:self.view];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    @try {
        
        NSLog(@"buttonIndex: %d", buttonIndex);
        if (buttonIndex >= 6) {
            return;
        }
        [self showRanklist:_showRankType rankType:buttonIndex+1];
        
    }
    @catch (NSException *exception) {
        NSLog(@"actionSheet clickedButtonAtIndex error...");
    }
    
}

-(void)doGotoSetting:(id)sender{
    
    EGOImageButton *btnHead = sender;
    long tempmemberid = btnHead.tag;
    
    SettingViewController *settingViewController = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
    [settingViewController setMemberid:tempmemberid];
    [self.navigationController pushViewController:settingViewController animated:YES];
    
}

-(void)doGotoChat:(id)sender{
    
}

//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    
//    //更新未读提醒
//    [[AppDelegate App] getUnreadList];
//}

@end
