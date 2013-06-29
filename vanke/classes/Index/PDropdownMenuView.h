//
//  PDropdownMenuView.h
//  vanke
//
//  Created by apple on 13-6-28.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDropdownMenuView : UIView

@property (nonatomic, retain) UIImageView *bgImageView;
@property (nonatomic, retain) UIButton *btnMenu1;
@property (nonatomic, retain) UIButton *btnMenu2;
@property (nonatomic, retain) UIButton *btnMenu3;
@property (nonatomic, retain) UIButton *btnMenu4;

-(id)initDropdownMenuOfHead:(CGRect)frame;

@end
