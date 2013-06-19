//
//  NearFriendCell.h
//  vanke
//
//  Created by pig on 13-6-13.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@interface NearFriendCell : UITableViewCell

@property (nonatomic, retain) IBOutlet EGOImageView *headImageView;
@property (nonatomic, retain) IBOutlet UILabel *lblNickname;
@property (nonatomic, retain) IBOutlet UILabel *lblNearDistance;
@property (nonatomic, retain) IBOutlet UIImageView *isFriendImageView;

@end
