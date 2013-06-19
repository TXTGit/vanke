//
//  BusPointCell.h
//  vanke
//
//  Created by pig on 13-6-15.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageButton.h"
#import "NearFriend.h"

@interface BusPointCell : UIView

@property (nonatomic, retain) IBOutlet EGOImageButton *btnUserTip;
@property (nonatomic, retain) IBOutlet UILabel *lblNickName;
@property (nonatomic, retain) IBOutlet UILabel *lblDistance;
@property (nonatomic, retain) IBOutlet UILabel *lblLoginTime;

@property (nonatomic, retain) NearFriend *nearFriend;

@end
