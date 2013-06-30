//
//  BindViewController.m
//  vanke
//
//  Created by pig on 13-6-12.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "BindViewController.h"
#import "UIImage+PImageCategory.h"
#import "IndexViewController.h"
#import "VankeAPI.h"
#import "AFJSONRequestOperation.h"
#import "UserSessionManager.h"

@interface BindViewController ()

@end

@implementation BindViewController

@synthesize navView = _navView;

@synthesize lblArea = _lblArea;
@synthesize btnAreaSelect = _btnAreaSelect;
@synthesize btnFinish = _btnFinish;

@synthesize achtionSheet = _achtionSheet;

@synthesize currentSelectedCommunityId = _currentSelectedCommunityId;
@synthesize runUser = _runUser;
@synthesize communityList = _communityList;

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
    _navView = [[PCustomNavigationBarView alloc] initWithTitle:@"绑定社区" bgImageView:@"index_nav_bg"];
    [self.view addSubview:_navView];
    
    UIImage *indexBack = [UIImage imageWithName:@"main_back" type:@"png"];
    [_navView.leftButton setBackgroundImage:indexBack forState:UIControlStateNormal];
    [_navView.leftButton setHidden:NO];
    [_navView.leftButton addTarget:self action:@selector(doBack) forControlEvents:UIControlEventTouchUpInside];
    
    //
    _communityList = [[NSMutableArray alloc] init];
    [self initData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initData{
    
    NSString *communityListUrl = [VankeAPI getCommunityListUrl];
    NSURL *url = [NSURL URLWithString:communityListUrl];
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
                NSDictionary *dicCom = [datalist objectAtIndex:i];
                Community *community = [Community initWithNSDictionary:dicCom];
                [_communityList addObject:community];
            }
            
            if (datalistCount > 1) {
                Community *tempCom = [_communityList objectAtIndex:0];
                _currentSelectedCommunityId = tempCom.communityID;
                _lblArea.text = tempCom.communityName;
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
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"failure: %@", error);
    }];
    [operation start];
    
}

-(void)doBack{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(IBAction)doSelect:(id)sender{
    
    NSLog(@"doSelect...");
    
    _achtionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    [_achtionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, 320, 150)];
    [pickerView setBackgroundColor:[UIColor blueColor]];
    pickerView.tag = 101;
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.showsSelectionIndicator = YES;
    
    [_achtionSheet addSubview:pickerView];
    
    UISegmentedControl *button = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"完成", nil]];
    [button setSegmentedControlStyle:UISegmentedControlStyleBar];
    [button setFrame:CGRectMake(270, 20, 50, 30)];
    [button addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    [_achtionSheet addSubview:button];
    
    [_achtionSheet showInView:self.view];
    [_achtionSheet setBounds:CGRectMake(0, 0, 320, 400)];
    [_achtionSheet setBackgroundColor:[UIColor whiteColor]];
    
}

-(void)segmentAction:(UISegmentedControl *)seg{
    NSInteger index = seg.selectedSegmentIndex;
    NSLog(@"index: %d", index);
    [_achtionSheet dismissWithClickedButtonIndex:index animated:YES];
}

-(IBAction)doFinish:(id)sender{
    
    [self doBind];
    
}

#pragma delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSLog(@"actionSheet clickedButtonAtIndex...");
    
}

#pragma delegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSLog(@"communityListCount:%d",[_communityList count]);
    return [_communityList count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    Community *community = [_communityList objectAtIndex:row];
    _currentSelectedCommunityId = community.communityID;
    return community.communityName;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    Community *community = [_communityList objectAtIndex:row];
    _currentSelectedCommunityId = community.communityID;
    
    _lblArea.text = community.communityName;
    
}

-(void)doBind{
    
    NSString *memberid = [UserSessionManager GetInstance].currentRunUser.userid;
    NSString *communityid = [NSString stringWithFormat:@"%d", _currentSelectedCommunityId];
    NSString *bindUrl = [VankeAPI getSetCommunityUrl:memberid communityId:communityid];
    NSURL *url = [NSURL URLWithString:bindUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"App.net Global Stream: %@", JSON);
        NSDictionary *dicResult = JSON;
        NSString *status = [dicResult objectForKey:@"status"];
        NSLog(@"status: %@", status);
        if ([status isEqual:@"0"]) {
            
            IndexViewController *indexViewController = [[IndexViewController alloc] initWithNibName:@"IndexViewController" bundle:nil];
            [self.navigationController pushViewController:indexViewController animated:YES];
            
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
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"failure: %@", error);
    }];
    [operation start];
    
}

@end
