//
//  RankCell.h
//  vanke
//
//  Created by apple on 13-6-17.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageButton.h"

@interface RankCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *lblRank;
@property (nonatomic, retain) IBOutlet EGOImageButton *headImageView;
@property (nonatomic, retain) IBOutlet UILabel *lblNickname;
@property (nonatomic, retain) IBOutlet UILabel *lblTime;
@property (nonatomic, retain) IBOutlet UILabel *lblEnergy;
@property (nonatomic, retain) IBOutlet UIImageView *isFriendImageView;

@end
