//
//  PShapMenuView.m
//  vanke
//
//  Created by pig on 13-6-12.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "PShapMenuView.h"

@implementation PShapMenuView

@synthesize bgImageView = _bgImageView;
@synthesize btnMenuFirst = _btnMenuFirst;
@synthesize btnMenuSecond = _btnMenuSecond;
@synthesize btnRedArraw = _btnRedArraw;
@synthesize btnMenuThird = _btnMenuThird;
@synthesize btnMenuFourth = _btnMenuFourth;
@synthesize btnMenuCenter = _btnMenuCenter;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initShapMenuOfRun:(CGRect)frame{
    
//    self = [super initWithFrame:CGRectMake(0, 0, 320, 160)];
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *bgimage = [UIImage imageNamed:@"menu_bottom_bg.png"];
        _bgImageView = [[UIImageView alloc] initWithImage:bgimage];
        _bgImageView.frame = CGRectMake(0, 0, 320, 160);
        [self addSubview:_bgImageView];
        
        _btnMenuFirst = [[OBShapedButton alloc] initWithFrame:CGRectMake(36, 87, 101, 72)];
        UIImage *firstImage = [UIImage imageNamed:@"btn1_1.png"];
        [_btnMenuFirst setImage:firstImage forState:UIControlStateNormal];
        [self addSubview:_btnMenuFirst];
        
        _btnMenuSecond = [[OBShapedButton alloc] initWithFrame:CGRectMake(72, 51, 105, 98)];
        UIImage *secondImage = [UIImage imageNamed:@"btn2_1.png"];
        [_btnMenuSecond setImage:secondImage forState:UIControlStateNormal];
        [self addSubview:_btnMenuSecond];
        
        _btnMenuThird = [[OBShapedButton alloc] initWithFrame:CGRectMake(161, 51, 97, 96)];
        UIImage *thirdImage = [UIImage imageNamed:@"btn3_1.png"];
        [_btnMenuThird setImage:thirdImage forState:UIControlStateNormal];
        [self addSubview:_btnMenuThird];
        
        _btnMenuFourth = [[OBShapedButton alloc] initWithFrame:CGRectMake(185, 94, 102, 68)];
        UIImage *fourthImage = [UIImage imageNamed:@"btn4_1.png"];
        [_btnMenuFourth setImage:fourthImage forState:UIControlStateNormal];
        [self addSubview:_btnMenuFourth];
        
        _btnMenuCenter = [[OBShapedButton alloc] initWithFrame:CGRectMake(0, 125, 320, 35)];
        UIImage *centerImage = [UIImage imageNamed:@"menu_bottom_center.png"];
        [_btnMenuCenter setImage:centerImage forState:UIControlStateNormal];
        [self addSubview:_btnMenuCenter];
        
        
    }
    return self;
}

-(id)initShapMenuOfLBS:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *bgimage = [UIImage imageNamed:@"menu_bottom_bg.png"];
        _bgImageView = [[UIImageView alloc] initWithImage:bgimage];
        _bgImageView.frame = CGRectMake(0, 0, 320, 160);
        [self addSubview:_bgImageView];
        
        _btnMenuFirst = [[OBShapedButton alloc] initWithFrame:CGRectMake(32, 82, 157, 78)];
        UIImage *firstImage = [UIImage imageNamed:@"circle_menu_11.png"];
        [_btnMenuFirst setImage:firstImage forState:UIControlStateNormal];
        [self addSubview:_btnMenuFirst];
        
        _btnMenuSecond = [[OBShapedButton alloc] initWithFrame:CGRectMake(75, 50, 100, 96)];
        UIImage *secondImage = [UIImage imageNamed:@"circle_menu_20.png"];
        [_btnMenuSecond setImage:secondImage forState:UIControlStateNormal];
        [self addSubview:_btnMenuSecond];
        
        _btnMenuThird = [[OBShapedButton alloc] initWithFrame:CGRectMake(156, 50, 101, 110)];
        UIImage *thirdImage = [UIImage imageNamed:@"circle_menu_30.png"];
        [_btnMenuThird setImage:thirdImage forState:UIControlStateNormal];
        [self addSubview:_btnMenuThird];
        
        _btnMenuFourth = [[OBShapedButton alloc] initWithFrame:CGRectMake(156, 92, 135, 68)];
        UIImage *fourthImage = [UIImage imageNamed:@"circle_menu_40.png"];
        [_btnMenuFourth setImage:fourthImage forState:UIControlStateNormal];
        [self addSubview:_btnMenuFourth];
        
        _btnMenuCenter = [[OBShapedButton alloc] initWithFrame:CGRectMake(125, 133, 71, 27)];
        UIImage *centerImage = [UIImage imageNamed:@"circle_menu_center.png"];
        [_btnMenuCenter setImage:centerImage forState:UIControlStateNormal];
        [self addSubview:_btnMenuCenter];
        
        
    }
    return self;
}

/*
-(id)initShapMenuOfRun:(CGRect)frame{
    
    //    self = [super initWithFrame:CGRectMake(0, 0, 320, 160)];
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *bgimage = [UIImage imageNamed:@"menu_bottom_bg.png"];
        _bgImageView = [[UIImageView alloc] initWithImage:bgimage];
        _bgImageView.frame = CGRectMake(0, 0, 320, 160);
        [self addSubview:_bgImageView];
        
        _btnMenuFirst = [[OBShapedButton alloc] initWithFrame:CGRectMake(36, 87, 101, 72)];
        UIImage *firstImage = [UIImage imageNamed:@"btn1_1.png"];
        [_btnMenuFirst setImage:firstImage forState:UIControlStateNormal];
        [self addSubview:_btnMenuFirst];
        
        _btnMenuSecond = [[OBShapedButton alloc] initWithFrame:CGRectMake(72, 51, 105, 98)];
        UIImage *secondImage = [UIImage imageNamed:@"btn2_1.png"];
        [_btnMenuSecond setImage:secondImage forState:UIControlStateNormal];
        [self addSubview:_btnMenuSecond];
        
        _btnMenuThird = [[OBShapedButton alloc] initWithFrame:CGRectMake(161, 51, 97, 96)];
        UIImage *thirdImage = [UIImage imageNamed:@"btn3_1.png"];
        [_btnMenuThird setImage:thirdImage forState:UIControlStateNormal];
        [self addSubview:_btnMenuThird];
        
        _btnMenuFourth = [[OBShapedButton alloc] initWithFrame:CGRectMake(185, 94, 102, 68)];
        UIImage *fourthImage = [UIImage imageNamed:@"btn4_1.png"];
        [_btnMenuFourth setImage:fourthImage forState:UIControlStateNormal];
        [self addSubview:_btnMenuFourth];
        
        _btnMenuCenter = [[OBShapedButton alloc] initWithFrame:CGRectMake(0, 125, 320, 35)];
        UIImage *centerImage = [UIImage imageNamed:@"menu_bottom_center.png"];
        [_btnMenuCenter setImage:centerImage forState:UIControlStateNormal];
        [self addSubview:_btnMenuCenter];
        
        
    }
    return self;
}
*/

/*
-(id)initShapMenuOfLBS:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *bgimage = [UIImage imageNamed:@"menu_bottom_bg.png"];
        _bgImageView = [[UIImageView alloc] initWithImage:bgimage];
        _bgImageView.frame = CGRectMake(0, 0, 320, 160);
        [self addSubview:_bgImageView];
        
        _btnMenuFirst = [[OBShapedButton alloc] initWithFrame:CGRectMake(32, 79, 160, 81)];
        UIImage *firstImage = [UIImage imageNamed:@"lbs_button1_1.png"];
        [_btnMenuFirst setImage:firstImage forState:UIControlStateNormal];
        [self addSubview:_btnMenuFirst];
        
        _btnMenuSecond = [[OBShapedButton alloc] initWithFrame:CGRectMake(77, 50, 90, 97)];
        UIImage *secondImage = [UIImage imageNamed:@"lbs_button2_2.png"];
        [_btnMenuSecond setImage:secondImage forState:UIControlStateNormal];
        [self addSubview:_btnMenuSecond];
        
        UIImage *redArrawImage = [UIImage imageNamed:@"lbs_button2_3.png"];
        _btnRedArraw = [[UIImageView alloc] initWithImage:redArrawImage];
        _btnRedArraw.frame = CGRectMake(109, 55, 20, 15);
        [self addSubview:_btnRedArraw];
        
        _btnMenuThird = [[OBShapedButton alloc] initWithFrame:CGRectMake(148, 50, 108, 109)];
        UIImage *thirdImage = [UIImage imageNamed:@"lbs_button3_1.png"];
        [_btnMenuThird setImage:thirdImage forState:UIControlStateNormal];
        [self addSubview:_btnMenuThird];
        
        _btnMenuFourth = [[OBShapedButton alloc] initWithFrame:CGRectMake(129, 87, 160, 73)];
        UIImage *fourthImage = [UIImage imageNamed:@"lbs_button4_1.png"];
        [_btnMenuFourth setImage:fourthImage forState:UIControlStateNormal];
        [self addSubview:_btnMenuFourth];
        
        _btnMenuCenter = [[OBShapedButton alloc] initWithFrame:CGRectMake(125, 132, 71, 27)];
        UIImage *centerImage = [UIImage imageNamed:@"lbs_button_center.png"];
        [_btnMenuCenter setImage:centerImage forState:UIControlStateNormal];
        [self addSubview:_btnMenuCenter];
        
        
    }
    return self;
}
*/

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
