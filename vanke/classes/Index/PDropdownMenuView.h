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
@property (nonatomic, retain) UIButton *btnMenuFirst;
@property (nonatomic, retain) UIButton *btnMenuSecond;
@property (nonatomic, retain) UIButton *btnMenuThird;
@property (nonatomic, retain) UIButton *btnMenuFourth;

-(id)initDropdownMenuOfHead:(CGRect)frame;

@end
