//
//  PShapMenuView.h
//  vanke
//
//  Created by pig on 13-6-12.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OBShapedButton.h"

@interface PShapMenuView : UIView

@property (nonatomic, retain) UIImageView *bgImageView;
@property (nonatomic, retain) OBShapedButton *btnMenuFirst;
@property (nonatomic, retain) OBShapedButton *btnMenuSecond;
@property (nonatomic, retain) UIImageView *btnRedArraw;
@property (nonatomic, retain) OBShapedButton *btnMenuThird;
@property (nonatomic, retain) OBShapedButton *btnMenuFourth;
@property (nonatomic, retain) OBShapedButton *btnMenuCenter;

-(id)initShapMenuOfRun:(CGRect)frame;
-(id)initShapMenuOfLBS:(CGRect)frame;

@end
