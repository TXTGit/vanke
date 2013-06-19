//
//  FriendViewController.m
//  vanke
//
//  Created by pig on 13-6-12.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "FriendViewController.h"
#import "UIImage+PImageCategory.h"
#import "FriendCell.h"
#import "RunUser.h"
#import "UserSessionManager.h"
#import "VankeAPI.h"
#import "AFJSONRequestOperation.h"
#import "ChatViewController.h"
#import "FriendInfo.h"
#import "SettingViewController.h"

@interface FriendViewController ()

@end

@implementation FriendViewController

@synthesize navView = _navView;
@synthesize friendTableView = _friendTableView;

@synthesize friendList = _friendList;

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
    
    float height = [UIScreen mainScreen].bounds.size.height - 20;
    
    //nav bar
    _navView = [[PCustomNavigationBarView alloc] initWithTitle:@"好友列表" bgImageView:@"index_nav_bg"];
    [self.view addSubview:_navView];
    
    UIImage *indexBack = [UIImage imageWithName:@"main_back" type:@"png"];
    [_navView.leftButton setBackgroundImage:indexBack forState:UIControlStateNormal];
    [_navView.leftButton setHidden:NO];
    [_navView.leftButton addTarget:self action:@selector(doBack) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *indexHeadBg = [UIImage imageWithName:@"run_share" type:@"png"];
    [_navView.rightButton setBackgroundImage:indexHeadBg forState:UIControlStateNormal];
    [_navView.rightButton setHidden:NO];
    
    //tableview
    UIImageView *bgImageView = [[UIImageView alloc] init];
    [bgImageView setFrame:CGRectMake(0, 0, 320, height - 44)];
    [bgImageView setImage:[UIImage imageWithName:@"run_bg" type:@"png"]];
    _friendTableView.backgroundColor = [UIColor clearColor];
    _friendTableView.backgroundView = bgImageView;
    _friendTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _friendTableView.frame = CGRectMake(0, 44, 320, height - 44);
    
    //data
    _friendList = [[NSMutableArray alloc] init];
    
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
    
    NSString *memberid = [UserSessionManager GetInstance].currentRunUser.userid;
    NSString *fanListUrl = [VankeAPI getGetFanListUrl:memberid];
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
                FriendInfo *friendinfo = [FriendInfo initWithNSDictionary:dicrecord];
                [_friendList addObject:friendinfo];
            }
            
            [_friendTableView reloadData];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"failure: %@", error);
    }];
    [operation start];
    
}

#pragma mark - UITableView datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_friendList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"FriendTableCell";
	FriendCell *cell = (FriendCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"FriendCell" owner:self options:nil];
        cell = (FriendCell *)[nibContents objectAtIndex:0];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
    
    FriendInfo *friendinfo = [_friendList objectAtIndex:indexPath.row];
    
    cell.lblNickname.text = friendinfo.fromNickName;
    cell.lblTime.text = friendinfo.fromLoginTime;
    cell.btnChat.tag = indexPath.row;
    [cell.btnChat addTarget:self action:@selector(doGotoChat:) forControlEvents:UIControlEventTouchUpInside];
    
	return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 57;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FriendInfo *friendinfo = [_friendList objectAtIndex:indexPath.row];
    
    SettingViewController *settingViewController = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
    [settingViewController setMemberid:friendinfo.fromMemberID];
    [self.navigationController pushViewController:settingViewController animated:YES];
    
}

-(void)doGotoChat:(id)sender{
    
    UIButton *chatButton = sender;
    FriendInfo *friendinfo = [_friendList objectAtIndex:chatButton.tag];
    
    ChatViewController *chatViewController = [[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil];
    [chatViewController setFriendInfo:friendinfo];
    [self.navigationController pushViewController:chatViewController animated:YES];
    
}

@end
