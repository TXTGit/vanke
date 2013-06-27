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
@synthesize isCommunity = _isCommunity;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _showRankType = 1;
        _isCommunity = NO;
        
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
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            
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
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            
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

-(void)getTotalRanklistByType:(BOOL)isCommunity rankType:(int)rankType{
    
    [_indicatorView startAnimating];
    
    NSString *memberid = [UserSessionManager GetInstance].currentRunUser.userid;
    NSString *rankListUrl = [VankeAPI getGetFanRankListUrl:memberid rankType:rankType];
    if (isCommunity) {
        rankListUrl = [VankeAPI getGetCommunityRankListUrl:memberid rankType:rankType];
    }
    NSLog(@"rankListUrl: %@", rankListUrl);
    
    NSURL *url = [NSURL URLWithString:rankListUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"getTotalRanklistByType: %@", JSON);
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
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            
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
//    cell.headImageView.imageURL = [NSURL URLWithString:temprankinfo.headImg];
    cell.headImageView.tag = temprankinfo.memberID;
    [cell.headImageView addTarget:self action:@selector(doGotoSetting:) forControlEvents:UIControlEventTouchUpInside];
    cell.lblNickname.text = temprankinfo.nickName;
    cell.lblTime.text = temprankinfo.loginTime;
    cell.lblEnergy.text = [NSString stringWithFormat:@"%.3f", temprankinfo.energy];
    if (temprankinfo.isFan > 0) {
        cell.isFriendImageView.hidden = NO;
    } else {
        cell.isFriendImageView.hidden = YES;
    }
    
    if (indexPath.row < 3) {
        cell.lblRank.textColor = [UIColor redColor];
        cell.lblNickname.textColor = [UIColor redColor];
        cell.lblEnergy.textColor = [UIColor redColor];
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
    _isCommunity = NO;
    [self updateCurrentArraw];
    [_rankTableView reloadData];
    
}

-(IBAction)doShowCommunityRank:(id)sender{
    
    NSLog(@"doShowCommunityRank...");
    
    _showRankType = 2;
    _isCommunity = YES;
    [self updateCurrentArraw];
    [_rankTableView reloadData];
    
}

-(IBAction)doShowTotalRank:(id)sender{
    
    NSLog(@"doShowTotalRank...");
    
    _showRankType = 3;
    [self updateCurrentArraw];
    
    //rankType：排名类型，总排名=1，年度排名=2，季度排名=3，月排名=4，周排名=5，日排名=6
    UIActionSheet *showActionSheet = [[UIActionSheet alloc] initWithTitle:@"排名选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"总排名", @"年度排名", @"季度排名", @"月排名", @"周排名", @"日排名", nil];
    showActionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [showActionSheet showInView:self.view];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    @try {
        
        NSLog(@"buttonIndex: %d", buttonIndex);
        switch (buttonIndex) {
            case 0:
            {
                [_totalRankList removeAllObjects];
                [_totalRankList addObjectsFromArray:_fanRankList];
                [_rankTableView reloadData];
            }
                break;
            case 1:
            case 2:
            case 3:
            case 4:
            case 5:
                [self getTotalRanklistByType:_isCommunity rankType:buttonIndex+1];
                break;
            case 6:
                break;
                
            default:
                break;
        }
        
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

@end
