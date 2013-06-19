//
//  ChatCell.m
//  vanke
//
//  Created by pig on 13-6-13.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "ChatCell.h"
#import "UIImage+PImageCategory.h"

@implementation ChatCell

@synthesize leftHeadImageView = _leftHeadImageView;
@synthesize rightHeadImageView = _rightHeadImageView;
@synthesize textBgImageView = _textBgImageView;
@synthesize lblChatText = _lblChatText;

@synthesize chatmessage = _chatmessage;
@synthesize friendinfo = _friendinfo;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)updateView{
    
    BOOL isFromSelf = NO;
    //如果是对方发的消息
    if (_chatmessage.fromMemberID == _friendinfo.fromMemberID) {
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
    
    CGRect cellframe = self.frame;
    cellframe.size.height = _textBgImageView.frame.size.height + 20;
    self.frame = cellframe;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
