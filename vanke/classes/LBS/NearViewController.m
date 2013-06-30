//
//  NearViewController.m
//  vanke
//
//  Created by pig on 13-6-12.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "NearViewController.h"
#import "UIImage+PImageCategory.h"
#import "NearFriendCell.h"
#import "UserSessionManager.h"
#import "VankeAPI.h"
#import "AFJSONRequestOperation.h"
#import "NearFriend.h"
#import "PCommonUtil.h"

@interface NearViewController ()

@end

@implementation NearViewController

@synthesize navView = _navView;

@synthesize btnNearFriend = _btnNearFriend;
@synthesize btnCommunityFriend = _btnCommunityFriend;
@synthesize friendTableView = _friendTableView;
@synthesize indicatorView = _indicatorView;

@synthesize isShowNearFriend = _isShowNearFriend;
@synthesize nearfriendlist = _nearfriendlist;
@synthesize communitylist = _communitylist;

@synthesize currentLocation = _currentLocation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _isShowNearFriend = YES;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    float height = [UIScreen mainScreen].bounds.size.height - 20;
    
    //nav bar
    _navView = [[PCustomNavigationBarView alloc] initWithTitle:@"跑友列表" bgImageView:@"index_nav_bg"];
    [self.view addSubview:_navView];
    
    UIImage *indexBack = [UIImage imageWithName:@"main_back" type:@"png"];
    [_navView.leftButton setBackgroundImage:indexBack forState:UIControlStateNormal];
    [_navView.leftButton setHidden:NO];
    [_navView.leftButton addTarget:self action:@selector(doBack) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *indexHeadBg = [UIImage imageWithName:@"main_head" type:@"png"];
    [_navView.rightButton setBackgroundImage:indexHeadBg forState:UIControlStateNormal];
    [_navView.rightButton setHidden:NO];
    
    //tableview
    _friendTableView.backgroundColor = [UIColor clearColor];
    _friendTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _friendTableView.frame = CGRectMake(0, 89, 320, height - 44 - 45);
    
    //data
    _nearfriendlist = [[NSMutableArray alloc] init];
    _communitylist = [[NSMutableArray alloc] init];
    
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
    
    if (_currentLocation) {
        
        [_indicatorView startAnimating];
        
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
            
            [_friendTableView reloadData];
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

-(IBAction)doNearFriend:(id)sender{
    
    NSLog(@"doNearFriend...");
    
    _isShowNearFriend = YES;
    [_friendTableView reloadData];
    
}

-(IBAction)doCommunityFriend:(id)sender{
    
    NSLog(@"doCommunityFriend...");
    
    _isShowNearFriend = NO;
    [_friendTableView reloadData];
    
}

#pragma mark - UITableView datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_isShowNearFriend) {
        return [_nearfriendlist count];
    } else {
        return [_communitylist count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"FriendTableCell";
	NearFriendCell *cell = (NearFriendCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"NearFriendCell" owner:self options:nil];
        cell = (NearFriendCell *)[nibContents objectAtIndex:0];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
    
    NearFriend *nearfriend = nil;
    if (_isShowNearFriend) {
        nearfriend = [_nearfriendlist objectAtIndex:indexPath.row];
    } else {
        nearfriend = [_communitylist objectAtIndex:indexPath.row];
    }
    
    if ([PCommonUtil checkDataIsNull:nearfriend.nickName]) {
        cell.lblNickname.text = nearfriend.nickName;
    }
    cell.lblNearDistance.text = [NSString stringWithFormat:@"%ld M", nearfriend.distance];
    if (nearfriend.isFan) {
        cell.isFriendImageView.hidden = NO;
    } else {
        cell.isFriendImageView.hidden = YES;
    }
    
	return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 57;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NearFriend *nearfriend = nil;
    if (_isShowNearFriend) {
        nearfriend = [_nearfriendlist objectAtIndex:indexPath.row];
    } else {
        nearfriend = [_communitylist objectAtIndex:indexPath.row];
    }
    
    NSLog(@"nearfriend.nickName: %@", nearfriend.nickName);
    
}

@end
