//
//  TaskViewController.m
//  vanke
//
//  Created by pig on 13-6-12.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "TaskViewController.h"
#import "UIImage+PImageCategory.h"
#import "UserSessionManager.h"
#import "VankeAPI.h"
#import "AFJSONRequestOperation.h"
#import "TaskInfo.h"

@interface TaskViewController ()

@end

@implementation TaskViewController

@synthesize navView = _navView;

@synthesize tempScroll = _tempScroll;
@synthesize broadView = _broadView;

@synthesize ivTask1 = _ivTask1;
@synthesize ivTask2 = _ivTask2;
@synthesize ivTask3 = _ivTask3;
@synthesize ivTask4 = _ivTask4;
@synthesize ivTask5 = _ivTask5;
@synthesize ivTask6 = _ivTask6;
@synthesize ivTask7 = _ivTask7;
@synthesize ivTask8 = _ivTask8;
@synthesize ivTask9 = _ivTask9;

@synthesize ivTaskText1 = _ivTaskText1;
@synthesize ivTaskText2 = _ivTaskText2;
@synthesize ivTaskText3 = _ivTaskText3;
@synthesize ivTaskText4 = _ivTaskText4;
@synthesize ivTaskText5 = _ivTaskText5;
@synthesize ivTaskText6 = _ivTaskText6;
@synthesize ivTaskText7 = _ivTaskText7;
@synthesize ivTaskText8 = _ivTaskText8;
@synthesize ivTaskText9 = _ivTaskText9;

@synthesize btnTaskCanTask1 = _btnTaskCanTask1;
@synthesize btnTaskCanTask2 = _btnTaskCanTask2;
@synthesize btnTaskCanTask3 = _btnTaskCanTask3;
@synthesize btnTaskCanTask4 = _btnTaskCanTask4;
@synthesize btnTaskCanTask5 = _btnTaskCanTask5;
@synthesize btnTaskCanTask6 = _btnTaskCanTask6;
@synthesize btnTaskCanTask7 = _btnTaskCanTask7;
@synthesize btnTaskCanTask8 = _btnTaskCanTask8;
@synthesize btnTaskCanTask9 = _btnTaskCanTask9;

@synthesize taskList = _taskList;

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
    
    //bg height
    float height = [UIScreen mainScreen].bounds.size.height - 20;
    
    //bg color
    self.view.backgroundColor = [UIColor clearColor];
    
    //
    _broadView.frame = CGRectMake(0, 0, 320, 548);
    
    _tempScroll = [[UIScrollView alloc] init];
    _tempScroll.frame = CGRectMake(0, 0, 320, height);
    _tempScroll.scrollEnabled = YES;
    _tempScroll.contentSize = CGSizeMake(320, 548);
    [_tempScroll addSubview:_broadView];
    [self.view addSubview:_tempScroll];
    
    //nav bar
    _navView = [[PCustomNavigationBarView alloc] initWithTitle:@"任务列表" bgImageView:@"index_nav_bg"];
    [self.view addSubview:_navView];
    
    UIImage *indexBack = [UIImage imageWithName:@"main_back" type:@"png"];
    [_navView.leftButton setBackgroundImage:indexBack forState:UIControlStateNormal];
    [_navView.leftButton setHidden:NO];
    [_navView.leftButton addTarget:self action:@selector(doBack) forControlEvents:UIControlEventTouchUpInside];
    
//    UIImage *indexHeadBg = [UIImage imageWithName:@"main_head" type:@"png"];
//    [_navView.rightButton setBackgroundImage:indexHeadBg forState:UIControlStateNormal];
//    [_navView.rightButton setHidden:NO];
//    
//    UIImage *messageTip = [UIImage imageWithName:@"index_button_new" type:@"png"];
//    [_navView.messageTipImageView setImage:messageTip];
//    [_navView.messageTipImageView setHidden:NO];
    
    //task init view
    _btnTaskCanTask1.hidden = YES;
    _btnTaskCanTask2.hidden = YES;
    _btnTaskCanTask3.hidden = YES;
    _btnTaskCanTask4.hidden = YES;
    _btnTaskCanTask5.hidden = YES;
    _btnTaskCanTask6.hidden = YES;
    _btnTaskCanTask7.hidden = YES;
    _btnTaskCanTask8.hidden = YES;
    _btnTaskCanTask9.hidden = YES;
    
    //
    _taskList = [[NSMutableArray alloc] init];
    
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
    NSString *taskListUrl = [VankeAPI getGetTaskListUrl:memberid];
    NSLog(@"taskListUrl: %@", taskListUrl);
    
    NSURL *url = [NSURL URLWithString:taskListUrl];
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
                TaskInfo *taskinfo = [TaskInfo initWithNSDictionary:dicrecord];
                [taskinfo Log];
                
                [_taskList addObject:taskinfo];
            }
            
            [self updateTaskState];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"failure: %@", error);
    }];
    [operation start];
    
}

-(void)doUpdateTaskStatus:(UIImageView *)iceImageView taskTextImageView:(UIImageView *)textImageView taskCanTake:(UIButton *)btnStatus status:(int)taskStatus{
    
    if (taskStatus == 1) {
        iceImageView.hidden = YES;
        textImageView.hidden = YES;
        btnStatus.hidden = NO;
    } else if (taskStatus == 2) {
        [iceImageView setImage:[UIImage imageNamed:@"task_has_done.png"]];
        textImageView.hidden = NO;
        btnStatus.hidden = YES;
    }
    
}

-(void)updateTaskState{
    
    @try {
        
        int taskCount = [_taskList count];
        for (int i=0; i<taskCount; i++) {
            TaskInfo *taskinfo = [_taskList objectAtIndex:i];
            int tempTaskStatus = 0;
            if (taskinfo.taskStatus) {
                tempTaskStatus = [taskinfo.taskStatus intValue];
            }
            
            //        [self doUpdateTaskStatus:_ivTask1 taskTextImageView:_ivTaskText1 taskCanTake:_btnTaskCanTask1 status:2];
            
            if (tempTaskStatus == 1) {
                
                int temptaskid = taskinfo.taskID;
                switch (temptaskid) {
                    case 11:
                        _ivTask1.hidden = YES;
                        _ivTaskText1.hidden = YES;
                        _btnTaskCanTask1.hidden = NO;
                        break;
                    case 12:
                        _ivTask2.hidden = YES;
                        _ivTaskText2.hidden = YES;
                        _btnTaskCanTask2.hidden = NO;
                        break;
                    case 13:
                        _ivTask3.hidden = YES;
                        _ivTaskText3.hidden = YES;
                        _btnTaskCanTask3.hidden = NO;
                        break;
                    case 14:
                        _ivTask4.hidden = YES;
                        _ivTaskText4.hidden = YES;
                        _btnTaskCanTask4.hidden = NO;
                        break;
                    case 15:
                        _ivTask5.hidden = YES;
                        _ivTaskText5.hidden = YES;
                        _btnTaskCanTask5.hidden = NO;
                        break;
                    case 16:
                        _ivTask6.hidden = YES;
                        _ivTaskText6.hidden = YES;
                        _btnTaskCanTask6.hidden = NO;
                        break;
                    case 17:
                        _ivTask7.hidden = YES;
                        _ivTaskText7.hidden = YES;
                        _btnTaskCanTask7.hidden = NO;
                        break;
                    case 18:
                        _ivTask8.hidden = YES;
                        _ivTaskText8.hidden = YES;
                        _btnTaskCanTask8.hidden = NO;
                        break;
                    case 19:
                        _ivTask9.hidden = YES;
                        _ivTaskText9.hidden = YES;
                        _btnTaskCanTask9.hidden = NO;
                        break;
                        
                    default:
                        break;
                }//switch
                
            } else if (tempTaskStatus == 2 || tempTaskStatus == 3) {
                
                int temptaskid = taskinfo.taskID;
                switch (temptaskid) {
                    case 11:
                        _ivTask1.image = [UIImage imageNamed:@"task_gift_has_done.png"];
                        _ivTaskText1.hidden = NO;
                        _btnTaskCanTask1.hidden = YES;
                        break;
                    case 12:
                        _ivTask2.image = [UIImage imageNamed:@"task_gift_has_done.png"];
                        _ivTaskText2.hidden = NO;
                        _btnTaskCanTask2.hidden = YES;
                        break;
                    case 13:
                        _ivTask3.image = [UIImage imageNamed:@"task_gift_has_done.png"];
                        _ivTaskText3.hidden = NO;
                        _btnTaskCanTask3.hidden = YES;
                        break;
                    case 14:
                        _ivTask4.image = [UIImage imageNamed:@"task_gift_has_done.png"];
                        _ivTaskText4.hidden = NO;
                        _btnTaskCanTask4.hidden = YES;
                        break;
                    case 15:
                        _ivTask5.image = [UIImage imageNamed:@"task_gift_has_done.png"];
                        _ivTaskText5.hidden = NO;
                        _btnTaskCanTask5.hidden = YES;
                        break;
                    case 16:
                        _ivTask6.image = [UIImage imageNamed:@"task_gift_has_done.png"];
                        _ivTaskText6.hidden = NO;
                        _btnTaskCanTask6.hidden = YES;
                        break;
                    case 17:
                        _ivTask7.image = [UIImage imageNamed:@"task_gift_has_done.png"];
                        _ivTaskText7.hidden = NO;
                        _btnTaskCanTask7.hidden = YES;
                        break;
                    case 18:
                        _ivTask8.image = [UIImage imageNamed:@"task_gift_has_done.png"];
                        _ivTaskText8.hidden = NO;
                        _btnTaskCanTask8.hidden = YES;
                        break;
                    case 19:
                        _ivTask9.image = [UIImage imageNamed:@"task_gift_has_done.png"];
                        _ivTaskText9.hidden = NO;
                        _btnTaskCanTask9.hidden = YES;
                        break;
                        
                    default:
                        break;
                }//switch
                
            }//endif
            
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"updateTaskState failed...");
    }
    
}

@end
