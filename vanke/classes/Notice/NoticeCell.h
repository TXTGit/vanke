//
//  NoticeCell.h
//  vanke
//
//  Created by pig on 13-6-27.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@interface NoticeCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *lblTime;
@property (nonatomic, retain) IBOutlet EGOImageView *egoTitleImg;
@property (nonatomic, retain) IBOutlet UILabel *lblSmallText;
@property (nonatomic, retain) IBOutlet UILabel *lblTitle;

@end
