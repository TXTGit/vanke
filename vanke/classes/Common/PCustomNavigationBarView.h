//
//  PCustomNavigationBarView.h
//  itime
//
//  Created by pig on 13-4-19.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageButton.h"

@interface PCustomNavigationBarView : UIView<EGOImageButtonDelegate>

@property (nonatomic, retain) UIImageView *bgImageView;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UIButton *leftButton;
@property (nonatomic, retain) EGOImageButton *rightButton;
@property (nonatomic, retain) UIImageView *messageTipImageView;

- (id)initWithTitle:(NSString *)tTitle bgImageView:(NSString *)tImageName;

@end
