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
    
    //nav bar
    NSString *title = [[NSString alloc]init];
    switch (_chatType) {
        case chatTypeDefault:
            title = @"聊天";
            break;
        case chatTypeInvite:
            title = @"约跑";
            break;
        case chatTYpeInviteCheck:
            title = @"查看约跑记录";
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
    
    UIImage *indexHeadBg = [UIImage imageWithName:@"main_head" type:@"png"];
    [_navView.rightButton setBackgroundImage:indexHeadBg forState:UIControlStateNormal];
    [_navView.rightButton setHidden:NO];
//    [_navView.rightButton addTarget:self action:@selector(touchMenuAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *messageTip = [UIImage imageWithName:@"index_button_new" type:@"png"];
    [_navView.messageTipImageView setImage:messageTip];
    [_navView.messageTipImageView setHidden:NO];
    
    //bg
    UIImageView *bgImageView = [[UIImageView alloc] init];
    [bgImageView setFrame:CGRectMake(0, 44, 320, height - 44)];
    [bgImageView setImage:[UIImage imageWithName:@"run_bg" type:@"png"]];
    [self.view addSubview:bgImageView];
    
    //tableview
    _chatTableView.backgroundColor = [UIColor clearColor];
    _chatTableView.backgroundView = bgImageView;
    _chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _chatTableView.frame = CGRectMake(0, 44, 320, height - 44 - 45);
    
    //send view
    _sendMessageView.frame = CGRectMake(0, height - 45, 320, 45);
    [self.view addSubview:_sendMessageView];
    
    
    //data
    _chatMessageList = [[NSMutableArray alloc] init];
    _lastMessageId = 0;
    
    //
    [self initData];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if (_chatType!=chatTYpeInviteCheck) {
//        [self timerStart];
        [self getInviteData];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [self timerStop];
    
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
    if(_chatType == chatTYpeInviteCheck){
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
            for (int i=0; i<datalistCount; i++) {
                NSDictionary *dicrecord = [datalist objectAtIndex:i];
                
                ChatMessage *chatmessage = [ChatMessage initWithNSDictionary:dicrecord];
                [_chatMessageList addObject:chatmessage];
                if (i == datalistCount - 1) {
                    _lastMessageId = chatmessage.msgID;
                }
            }
            if (datalistCount>0) {
                [_chatTableView reloadData];
            }
        }
        
        [self performSelector:@selector(initData) withObject:nil afterDelay:5.0f];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"failure: %@", error);
        [self performSelector:@selector(initData) withObject:nil afterDelay:5.0f];
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
        [chatViewController setChatType:chatTYpeInviteCheck];
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
                NSLog(@"chatMessageRecord:%@",dicrecord);
                [_chatMessageList addObject:chatmessage];
                if (i == datalistCount - 1) {
                    _lastMessageId = chatmessage.msgID;
                }
            }
            
            [_chatTableView reloadData];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"failure: %@", error);
    }];
    [operation start];
}

-(IBAction)doSend:(id)sender{
    
//    NSLog(@"doSend: %@", _messageField.text);
    
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

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
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

@end
