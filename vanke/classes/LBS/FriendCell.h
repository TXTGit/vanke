//
//  FriendCell.h
//  vanke
//
//  Created by pig on 13-6-12.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@interface FriendCell : UITableViewCell

@property (nonatomic, retain) IBOutlet EGOImageView *headImageView;
@property (nonatomic, retain) IBOutlet UILabel *lblNickname;
@property (nonatomic, retain) IBOutlet UILabel *lblTime;
@property (nonatomic, retain) IBOutlet UIButton *btnChat;

@end
