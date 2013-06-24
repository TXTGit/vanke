//
//  ChatCell.m
//  vanke
//
//  Created by pig on 13-6-13.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "ChatCell.h"
#import "UIImage+PImageCategory.h"
#import "VankeAPI.h"
#import "AFJSONRequestOperation.h"
#import "MBProgressHUD.h"
#import "UserSessionManager.h"

@implementation ChatCell

@synthesize leftHeadImageView = _leftHeadImageView;
@synthesize rightHeadImageView = _rightHeadImageView;
@synthesize textBgImageView = _textBgImageView;
@synthesize lblChatText = _lblChatText;

@synthesize chatmessage = _chatmessage;
@synthesize friendinfo = _friendinfo;

@synthesize chatType = _chatType;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)updateView{
    
//    NSLog(@"%ld,%ld",_chatmessage.fromMemberID,_chatmessage.toMemberID);
    BOOL isFromSelf = NO;
    //如果是对方发的消息
    if (_chatmessage.memberID == [[UserSessionManager GetInstance].currentRunUser.userid longLongValue]) {
        _leftHeadImageView.hidden = NO;
        _rightHeadImageView.hidden = YES;
        isFromSelf = NO;
    } else {
        _leftHeadImageView.hidden = YES;
        _rightHeadImageView.hidden = NO;
        isFromSelf = YES;
    }
    
    //
//    _chatmessage.msgText = @"msgTex1.跑步的界面，数据调整增加。圆盘效果调整t";
    _lblChatText.lineBreakMode = NSLineBreakByWordWrapping;
    _lblChatText.text = _chatmessage.msgText;
    
    NSString *bubbleImageName = isFromSelf ? @"chat_message_bg_right" : @"chat_message_bg_left";
    UIImage *bubble = [UIImage imageWithName:bubbleImageName type:@"png"];
    _textBgImageView.image = [bubble stretchableImageWithLeftCapWidth:20 topCapHeight:10];
    _textBgImageView.hidden = NO;
    
    if (_chatmessage && _chatmessage.msgText) {
        UIFont *textFont = _lblChatText.font;
        CGSize textSize = [_chatmessage.msgText sizeWithFont:textFont constrainedToSize:CGSizeMake(200.0f, 1000.0f)];
        if (isFromSelf) {
            _lblChatText.frame = CGRectMake(260 - textSize.width, 14, textSize.width, textSize.height);
            _textBgImageView.frame = CGRectMake(250 - textSize.width, 10, textSize.width+20, textSize.height + 10);
        }else{
            _lblChatText.frame = CGRectMake(60, 14, textSize.width, textSize.height);
            _textBgImageView.frame = CGRectMake(50, 10, textSize.width+20, textSize.height + 10);
        }
    }
    
    if (_chatType == chatTYpeInviteCheck) {
        UIButton *btnAccept = [[UIButton alloc]initWithFrame:CGRectMake(_textBgImageView.frame.origin.x + 5, _textBgImageView.frame.size.height + 10, 49, 21)];
        [btnAccept setTitle:@"接受" forState:UIControlStateNormal];
        [btnAccept setBackgroundColor:[UIColor grayColor]];
        [btnAccept addTarget:self action:@selector(acceptInvit:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnAccept];
        
        UIButton *btnReply = [[UIButton alloc]initWithFrame:CGRectMake(_textBgImageView.frame.origin.x + 60, _textBgImageView.frame.size.height + 5, 49, 21)];
        [btnReply setTitle:@"拒绝" forState:UIControlStateNormal];
        [btnReply setBackgroundColor:[UIColor grayColor]];
        [btnAccept addTarget:self action:@selector(rejectInvit:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnReply];
        
        CGRect bgFrame = self.textBgImageView.frame;
        bgFrame.size.height = bgFrame.size.height + 31;
        self.textBgImageView.frame = bgFrame;
    }
    
    CGRect cellframe = self.frame;
    cellframe.size.height = _textBgImageView.frame.size.height + 20;
    self.frame = cellframe;
}

-(IBAction)acceptInvit:(UIButton*)sender
{
    NSString *memberid = [NSString stringWithFormat:@"%ld",_chatmessage.memberID];
    NSString *tomemberid = [NSString stringWithFormat:@"%ld",_chatmessage.fromMemberID];
    NSString *msgListUrl = [VankeAPI getAddFanUrl:memberid :tomemberid :_chatmessage.inviteID];
    NSLog(@"AddFanUrl:%@",msgListUrl);
    NSURL *url = [NSURL URLWithString:msgListUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"App.net Global Stream: %@", JSON);
        NSDictionary *dicResult = JSON;
        NSString *status = [dicResult objectForKey:@"status"];
        NSLog(@"status: %@", status);
        if ([status isEqual:@"0"]) {
            [sender setHidden:YES];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
            
            // Configure for text only and offset down
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"添加好友成功！";
            hud.margin = 10.f;
            hud.yOffset = 0.0f;
            hud.removeFromSuperViewOnHide = YES;
            
            [hud hide:YES afterDelay:2];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"failure: %@", error);
    }];
    [operation start];
}

-(IBAction)rejectInvite:(id)sender
{
    NSString *rejectInviteUrl = [VankeAPI getRejectInviteUrl:_chatmessage.inviteID];
    NSLog(@"rejectInviteUrl: %@", rejectInviteUrl);
    NSURL *url = [NSURL URLWithString:rejectInviteUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"App.net Global Stream: %@", JSON);
        NSDictionary *dicResult = JSON;
        NSString *status = [dicResult objectForKey:@"status"];
        NSLog(@"status: %@", status);
        if ([status isEqual:@"0"]) {
            [sender setHidden:YES];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
            
            // Configure for text only and offset down
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"您已经拒绝该好友的添加请求！";
            hud.margin = 10.f;
            hud.yOffset = 0.0f;
            hud.removeFromSuperViewOnHide = YES;
            
            [hud hide:YES afterDelay:2];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"failure: %@", error);
    }];
    [operation start];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
