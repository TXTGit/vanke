//
//  ScoreListViewController.m
//  vanke
//
//  Created by pig on 13-7-2.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "ScoreListViewController.h"
#import "UIImage+PImageCategory.h"
#import "UserSessionManager.h"
#import "AFJSONRequestOperation.h"
#import "ScoreCell.h"
#import "VankeAPI.h"
#import "ScoreInfo.h"
#import "PCommonUtil.h"

@interface ScoreListViewController ()

@end

@implementation ScoreListViewController

@synthesize navView = _navView;
@synthesize scoreTableView = _scoreTableView;
@synthesize indicatorView = _indicatorView;

@synthesize scoreList = _scoreList;

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
    _navView = [[PCustomNavigationBarView alloc] initWithTitle:@"动态信息圈" bgImageView:@"index_nav_bg"];
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
    
    UIImageView *bgImageView = [[UIImageView alloc] init];
    [bgImageView setFrame:CGRectMake(0, 44, 320, height - 44)];
    [bgImageView setImage:[UIImage imageWithName:@"share_list_bg" type:@"png"]];
    [self.view insertSubview:bgImageView atIndex:0];
    
    //tableview
    _scoreTableView.backgroundColor = [UIColor clearColor];
    _scoreTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _scoreTableView.frame = CGRectMake(0, 44, 320, height - 44);
    _scoreTableView.delegate = self;
    
    [self initData];
    
    //data
    _scoreList = [[NSMutableArray alloc] init];
    
    
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
    
    NSString *memberid = [UserSessionManager GetInstance].currentRunUser.userid;
    NSString *getScoreListUrl = [VankeAPI getGetScoreListUrl:memberid page:1 rows:20];
    NSURL *url = [NSURL URLWithString:getScoreListUrl];
    NSLog(@"getScoreListUrl: %@",url);
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
                
                ScoreInfo *scoreInfo = [ScoreInfo initWithNSDictionary:dicrecord];
                [_scoreList addObject:scoreInfo];
            }
            
            [_scoreTableView reloadData];
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
    NSLog(@"_scoreList: %d",[_scoreList count]);
    return [_scoreList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ScoreTableCell";
	ScoreCell *cell = (ScoreCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"ScoreCell" owner:self options:nil];
        cell = (ScoreCell *)[nibContents objectAtIndex:0];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
    
    ScoreInfo *scoreInfo = [_scoreList objectAtIndex:indexPath.row];
    NSLog(@"indePah.row: %d",indexPath.row);
    
    cell.lblTime.text = scoreInfo.scoreTime;
    int tempmileage = scoreInfo.mileage;
    cell.lblDistance.text = [NSString stringWithFormat:@"%.d公里", tempmileage];
    cell.lblScore.text = [NSString stringWithFormat:@"%d分", scoreInfo.score];
    
	return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}

@end
