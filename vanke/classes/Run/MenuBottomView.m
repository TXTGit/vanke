//
//  MenuBottomView.m
//  vanke
//
//  Created by pig on 13-6-10.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "MenuBottomView.h"

@implementation MenuBottomView

@synthesize ivMenuBg = _ivMenuBg;
@synthesize btnMenuCenter = _btnMenuCenter;
@synthesize btnMenuFirst = _btnMenuFirst;
@synthesize btnMenuSecond = _btnMenuSecond;
@synthesize btnMenuThird = _btnMenuThird;
@synthesize btnMenuFourth = _btnMenuFourth;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
