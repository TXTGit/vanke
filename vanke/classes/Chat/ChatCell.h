//
//  ChatCell.h
//  vanke
//
//  Created by pig on 13-6-13.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendInfo.h"
#import "ChatMessage.h"
#import "EGOImageView.h"

typedef enum {
    chatTypeDefault,
    chatTypeInvite,
    chatTypeInviteCheck,
    chtTypeList
}ChatType;

@interface ChatCell : UITableViewCell

@property (nonatomic, retain) IBOutlet EGOImageView *leftHeadImageView;
@property (nonatomic, retain) IBOutlet EGOImageView *rightHeadImageView;
@property (nonatomic, retain) IBOutlet UIImageView *textBgImageView;
@property (nonatomic, retain) IBOutlet UILabel *lblChatText;
@property (nonatomic, assign) ChatType chatType;

@property (nonatomic, retain) ChatMessage *chatmessage;
@property (nonatomic, retain) FriendInfo *friendinfo;

-(void)updateView;

@end
