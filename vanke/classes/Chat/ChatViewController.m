//
//  ChatViewController.m
//  vanke
//
//  Created by pig on 13-6-10.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "ChatViewController.h"
#import "UIImage+PImageCategory.h"
#import "UserSessionManager.h"
#import "VankeAPI.h"
#import "AFJSONRequestOperation.h"
#import "ChatMessage.h"
#import "PCommonUtil.h"

@interface ChatViewController ()

@end

@implementation ChatViewController

@synthesize navView = _navView;

@synthesize chatTableView = _chatTableView;
@synthesize sendMessageView = _sendMessageView;
@synthesize messageField = _messageField;
@synthesize btnSend = _btnSend;

@synthesize chatMessageList = _chatMessageList;
@synthesize lastMessageId = _lastMessageId;

@synthesize friendInfo = _friendInfo;
@synthesize getMsgTimer = _getMsgTimer;

@synthesize chatType = _chatType;

@synthesize isChatViewShow = _isChatViewShow;

@synthesize egoRefreshHeaderView = _egoRefreshHeaderView;
@synthesize reloading = _reloading;

@synthesize currentPage = _currentPage;
@synthesize rows = _rows;

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
    
    //监听键盘高度的变换
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    // 键盘高度变化通知，ios5.0新增的
#ifdef __IPHONE_5_0
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 5.0) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
#endif
    
    float height = [UIScreen mainScreen].bounds.size.height - 20;
    
    //bg
    UIImageView *bgImageView = [[UIImageView alloc] init];
    [bgImageView setFrame:CGRectMake(0, 44, 320, height - 44)];
    [bgImageView setImage:[UIImage imageWithName:@"run_bg" type:@"png"]];
    [self.view addSubview:bgImageView];
    
    //tableview
    _chatTableView.backgroundColor = [UIColor clearColor];
    _chatTableView.backgroundView = bgImageView;
    _chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //如果是邀请列表页，则隐藏发送窗口
    if (_chatType == chatTypeInviteCheck) {
        [self.sendMessageView setHidden:YES];
        _chatTableView.frame = CGRectMake(0, 44, 320, height - 44);
    }else{
        _chatTableView.frame = CGRectMake(0, 44, 320, height - 44 - 45);
        
        //下拉刷新
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f-_chatTableView.bounds.size.height, self.view.frame.size.width, _chatTableView.bounds.size.height)];
        view.delegate = self;
        [_chatTableView addSubview:view];
        _egoRefreshHeaderView = view;
    }
    
    //send view
    _sendMessageView.frame = CGRectMake(0, height - 45, 320, 45);
    [self.view addSubview:_sendMessageView];
    
    
    //data
    _chatMessageList = [[NSMutableArray alloc] init];
    _lastMessageId = 0;
    
    //
    [self initData];
    
    _currentPage = 1;
    _rows = 50;
    
    //nav bar
    NSString *title = [[NSString alloc]init];
    switch (_chatType) {
        case chatTypeDefault:
            title = @"聊天";
            [self reloadTableViewDataSource:YES];
            break;
        case chatTypeInvite:
            title = @"约跑";
            break;
        case chatTypeInviteCheck:
            title = @"信箱";
            break;
        default:
            break;
    }
    _navView = [[PCustomNavigationBarView alloc] initWithTitle:title bgImageView:@"index_nav_bg"];
    [self.view addSubview:_navView];
    
    UIImage *indexBack = [UIImage imageWithName:@"main_back" type:@"png"];
    [_navView.leftButton setBackgroundImage:indexBack forState:UIControlStateNormal];
    [_navView.leftButton setHidden:NO];
    [_navView.leftButton addTarget:self action:@selector(doBack) forControlEvents:UIControlEventTouchUpInside];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if (_chatType!=chatTypeInviteCheck) {
//        [self timerStart];
        [self getInviteData];
    }
    _isChatViewShow = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    _isChatViewShow = NO;
    
    [self timerStop];
    
}

- (void)viewDidUnload {
	_egoRefreshHeaderView=nil;
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
    if(_chatType == chatTypeInviteCheck){
        [self showInviteData];
    }else if(_chatType == chatTypeDefault)
    {
        [self getDefaultData];
    }
}

-(void)getDefaultData{
    NSString *memberid = [UserSessionManager GetInstance].currentRunUser.userid;
    NSString *tomemberid = [NSString stringWithFormat:@"%ld", _friendInfo.fromMemberID];
    NSString *msgListUrl = [VankeAPI getGetMsgListUrl:memberid fromMemberID:tomemberid lastMsgId:_lastMessageId];
    NSLog(@"msgList:%@",msgListUrl);
    NSURL *url = [NSURL URLWithString:msgListUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"App.net Global Stream: %@", JSON);
        NSDictionary *dicResult = JSON;
        NSString *status = [dicResult objectForKey:@"status"];
        NSLog(@"status: %@", status);
        if ([status isEqual:@"0"]) {
            
            NSArray *datalist = [dicResult objectForKey:@"list"];
            int datalistCount = [datalist count];
            NSMutableArray *tempListArray = [[NSMutableArray alloc]init];
            for (int i=0; i<datalistCount; i++) {
                NSDictionary *dicrecord = [datalist objectAtIndex:i];
                
                ChatMessage *chatmessage = [ChatMessage initWithNSDictionary:dicrecord];
                
                if (_chatMessageList && [_chatMessageList count]>0) {
                    //过滤相同的MSGID，显示过的消息不再显示
                    NSPredicate *inputPredicate=[NSPredicate predicateWithFormat:@"%K == %ld",@"msgID", chatmessage.msgID];
                    NSMutableArray *newMutableArray = [NSMutableArray arrayWithArray:[_chatMessageList filteredArrayUsingPredicate:inputPredicate]];
                    if ([newMutableArray count]<=0) {
                        [tempListArray insertObject:chatmessage atIndex:0];
                    }
                }else{
                    [tempListArray insertObject:chatmessage atIndex:0];
                }
                if (i == 0) {
                    _lastMessageId = chatmessage.msgID;
                }
            }
            if ([tempListArray count]>0) {
                for (ChatMessage *chatmessage in tempListArray) {
                    [_chatMessageList addObject:chatmessage];
                }
                [UserSessionManager GetInstance].unreadMessageCount = 0;
            }
            if (datalistCount>0) {
                [_chatTableView reloadData];
            }
        }else{
//            NSString *errMsg = [dicResult objectForKey:@"msg"];
//            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
//            
//            // Configure for text only and offset down
//            hud.mode = MBProgressHUDModeText;
//            hud.labelText = errMsg;
//            hud.margin = 10.f;
//            hud.yOffset = 150.0f;
//            hud.removeFromSuperViewOnHide = YES;
//            [hud hide:YES afterDelay:2];
        }
        
        if (_isChatViewShow) {
            [self performSelector:@selector(initData) withObject:nil afterDelay:8.0f];
        }
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"failure: %@", error);
        if (_isChatViewShow) {
            [self performSelector:@selector(initData) withObject:nil afterDelay:8.0f];
        }
        
    }];
    [operation start];
}

-(void)getInviteData{
    NSString *memberid = [UserSessionManager GetInstance].currentRunUser.userid;
    NSString *msgListUrl = [VankeAPI getInviteListUrl:memberid :1 :10];
    NSLog(@"msgList:%@",msgListUrl);
    NSURL *url = [NSURL URLWithString:msgListUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"App.net Global Stream: %@", JSON);
        NSDictionary *dicResult = JSON;
        NSString *status = [dicResult objectForKey:@"status"];
        NSLog(@"status: %@", status);
        if ([status isEqual:@"0"]) {
            NSArray *datalist = [dicResult objectForKey:@"list"];
            int datalistCount = [datalist count];
            if (datalistCount>0) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"您有%d条邀请，请查看！",datalistCount] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"查看", nil];
                [alert show];
            }
            
//            ChatViewController *chatViewController = [[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil];
//            [chatViewController setChatType:chatTYpeInviteCheck];
//            [self.navigationController pushViewController:chatViewController animated:YES];
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIndex:%d",buttonIndex);
    if (buttonIndex==1) {
        ChatViewController *chatViewController = [[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil];
        [chatViewController setChatType:chatTypeInviteCheck];
        [self.navigationController pushViewController:chatViewController animated:YES];
    }
}

-(void)showInviteData
{
    NSString *memberid = [UserSessionManager GetInstance].currentRunUser.userid;
    NSString *msgListUrl = [VankeAPI getInviteListUrl:memberid :1 :10];
    NSLog(@"msgList:%@",msgListUrl);
    NSURL *url = [NSURL URLWithString:msgListUrl];
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
                
                ChatMessage *chatmessage = [ChatMessage initWithNSDictionary:dicrecord];
//                chatmessage.fromMemberID = [[dicrecord objectForKey:@"memberID"] longValue];
//                chatmessage.memberID = [[dicrecord objectForKey:@"fromMemberID"] longValue];
                chatmessage.msgText = [NSString stringWithFormat:@"来自%@的邀请：%@",[dicrecord objectForKey:@"fromNickName"],[dicrecord objectForKey:@"inviteText"]];
//                NSLog(@"chatMessageRecord:%@",dicrecord);
//                [_chatMessageList addObject:chatmessage];
                [_chatMessageList insertObject:chatmessage atIndex:0];
                if (i == 0) {
                    _lastMessageId = chatmessage.msgID;
                }
            }
            
            [_chatTableView reloadData];
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

-(IBAction)doSend:(id)sender{
    
//    NSLog(@"doSend: %@", _messageField.text);
    if ([_messageField.text isEqualToString:@""]) {
        return;
    }
    
    NSString *msgText = _messageField.text;
    NSString *memberid = [UserSessionManager GetInstance].currentRunUser.userid;
    NSString *tomemberid = [NSString stringWithFormat:@"%ld", _friendInfo.fromMemberID];
    NSString *msgListUrl = [VankeAPI getSendMsgUrl:memberid toMemberId:tomemberid msgText:_messageField.text];
    if (_chatType == chatTypeInvite) {
        NSLog(@"tomemberid:%@,memberid;%@",tomemberid,memberid);
        msgListUrl = [VankeAPI getSendInviteUrl:memberid toMemberId:tomemberid msgText:msgText];
    }
    NSURL *url = [NSURL URLWithString:msgListUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"App.net Global Stream: %@", JSON);
        NSDictionary *dicResult = JSON;
        NSString *status = [dicResult objectForKey:@"status"];
        NSLog(@"status: %@", status);
        if ([status isEqual:@"0"]) {
            
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
    
    ChatMessage *chatmessage = [[ChatMessage alloc]init];
    chatmessage.msgText = msgText;
    //            NSLog(@"chatmessageText:%@",chatmessage.msgText);
    NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    chatmessage.sendTime = [dateFormatter stringFromDate:[NSDate date]];
    chatmessage.memberID = (long)memberid;
    chatmessage.fromMemberID = (long)tomemberid;
    [_chatMessageList addObject:chatmessage];
    [_chatTableView reloadData];
//    NSIndexPath *indexPath = [[NSIndexPath alloc]initWithIndex:[_chatMessageList count]-1];
//    [_chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    NSIndexPath *lastRow = [NSIndexPath indexPathForRow:([_chatMessageList count]-1) inSection:0];
    [_chatTableView scrollToRowAtIndexPath:lastRow
                                atScrollPosition:UITableViewScrollPositionBottom
                                        animated:YES];
    
    //发送后清理
    _messageField.text = @"";
    
}

#pragma mark - UITableView datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"_chatMessageListCount:%d",[_chatMessageList count]);
    return [_chatMessageList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"RecordTableCell";
	ChatCell *cell = (ChatCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"ChatCell" owner:self options:nil];
        cell = (ChatCell *)[nibContents objectAtIndex:0];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
    cell.chatType = self.chatType;
    
    ChatMessage *tempmessage = [_chatMessageList objectAtIndex:indexPath.row];
    
//    NSLog(@"%ld,%ld",tempmessage.fromMemberID,tempmessage.toMemberID);
    cell.chatmessage = tempmessage;
    cell.friendinfo = _friendInfo;
    
    NSString *headImg = [UserSessionManager GetInstance].currentRunUser.headImg;
    if (headImg && ![headImg isEqual:@""]) {
        cell.rightHeadImageView.imageURL = [NSURL URLWithString:headImg];
    }
    if ([PCommonUtil checkDataIsNull:_friendInfo.fromHeadImg] && ![_friendInfo.fromHeadImg isEqualToString:@""]) {
        cell.leftHeadImageView.imageURL = [NSURL URLWithString:[PCommonUtil getHeadImgUrl:_friendInfo.fromHeadImg]];
    }
    
    [cell updateView];
	return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ChatCell *cell = (ChatCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
//    NSLog(@"cell.frame.size.height: %f", cell.frame.size.height);
    return cell.frame.size.height;
    
//    return 57;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [_messageField resignFirstResponder];
}

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    [[UIApplication sharedApplication].keyWindow endEditing:YES];
//}
#pragma textfield delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    float height = [UIScreen mainScreen].bounds.size.height - 20;
    _chatTableView.frame = CGRectMake(0, 0, 320, height - 210);
    [self scrollTableToFoot:YES];
}

-(IBAction)resiginTextField:(id)sender{
    float height = [UIScreen mainScreen].bounds.size.height - 20;
    _chatTableView.frame = CGRectMake(0, 20, 320, height);
}

#pragma mark -
#pragma mark Responding to keyboard events
- (void)keyboardWillShow:(NSNotification *)notification {
    
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
    
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    [self autoMovekeyBoard:keyboardRect.size.height];
}


- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary* userInfo = [notification userInfo];
    
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    
    [self autoMovekeyBoard:0];
}

-(void) autoMovekeyBoard: (float) h{
    
    float height = [UIScreen mainScreen].bounds.size.height - 20;
	_sendMessageView.frame = CGRectMake(0.0f, (float)(height-h-45), 320.0f, 45.0f);
	_chatTableView.frame = CGRectMake(0.0f, 44.0f, 320.0f,(float)(height-h-44-45));
    
}

- (void) timerStart
{
    [self timerStop];
    _getMsgTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(initData) userInfo:nil repeats:YES];
}

- (void) timerStop
{
    @synchronized(self)
    {
        if (_getMsgTimer != nil)
        {
            if([_getMsgTimer isValid])
            {
                [_getMsgTimer invalidate];
            }
            _getMsgTimer = nil;
        }
    }
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource:(BOOL)toFoot{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
    
    NSString *memberid = [UserSessionManager GetInstance].currentRunUser.userid;
    NSString *tomemberid = [NSString stringWithFormat:@"%ld", _friendInfo.fromMemberID];
    NSString *msgHistoryListUrl = [VankeAPI getMsgHistoryList:memberid fromMemberID:tomemberid page:_currentPage rows:_rows];
    NSLog(@"msgHistoryListUrl:%@",msgHistoryListUrl);
    NSURL *url = [NSURL URLWithString:msgHistoryListUrl];
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
                
                ChatMessage *chatmessage = [ChatMessage initWithNSDictionary:dicrecord];
                
                //过滤相同的MSGID，显示过的消息不再显示
                if (_chatMessageList && [_chatMessageList count]>0) {
                    NSPredicate *inputPredicate=[NSPredicate predicateWithFormat:@"%K == %ld",@"msgID", chatmessage.msgID];
                    NSMutableArray *newMutableArray = [NSMutableArray arrayWithArray:[_chatMessageList filteredArrayUsingPredicate:inputPredicate]];
                    
                    if ([newMutableArray count]<=0) {
                        [_chatMessageList insertObject:chatmessage atIndex:0];
                    }
                }else{
                    [_chatMessageList insertObject:chatmessage atIndex:0];
                }
            }
            if (datalistCount>0) {
                [_chatTableView reloadData];
                _currentPage +=1;
            }else{
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
                // Configure for text only and offset down
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"没有更多历史消息";
                hud.margin = 10.f;
                hud.yOffset = 150.0f;
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:2];
            }
            if (toFoot) {
                [self scrollTableToFoot:NO];
            }
        }else if([status isEqual:@"1"]){
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
        
        [self doneLoadingTableViewData];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"failure: %@", error);
        [self doneLoadingTableViewData];
    }];
    [operation start];
}

- (void)scrollTableToFoot:(BOOL)animated {
    NSInteger s = [_chatTableView numberOfSections];
    if (s<1) return;
    NSInteger r = [_chatTableView numberOfRowsInSection:s-1];
    if (r<1) return;
    
    NSIndexPath *ip = [NSIndexPath indexPathForRow:r-1 inSection:s-1];
    
    [_chatTableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:animated];
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	[_egoRefreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_chatTableView];
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	[_egoRefreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	[_egoRefreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource:NO];
//	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

@end
