//
//  RunRecordCell.h
//  vanke
//
//  Created by pig on 13-6-11.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCommonUtil.h"

@interface RunRecordCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *lblCreateTime;
@property (nonatomic, retain) IBOutlet UILabel *lblRunDistance;
@property (nonatomic, retain) IBOutlet UILabel *lblCalorie;
@property (nonatomic, retain) IBOutlet UILabel *lblSpead;

@end
