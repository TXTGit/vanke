//
//  PDropdownMenuView.m
//  vanke
//
//  Created by apple on 13-6-28.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "PDropdownMenuView.h"

@implementation PDropdownMenuView

@synthesize bgImageView = _bgImageView;
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

-(id)initDropdownMenuOfHead:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *bgimage = [UIImage imageNamed:@"dropdown_menu_bg.png"];
        _bgImageView = [[UIImageView alloc] initWithImage:bgimage];
        _bgImageView.frame = CGRectMake(0, 0, 57, 210);
        [self addSubview:_bgImageView];
        
        _btnMenuFirst = [[UIButton alloc] initWithFrame:CGRectMake(8, 10, 40, 40)];
        UIImage *firstImage = [UIImage imageNamed:@"dropdown_menu1.png"];
        [_btnMenuFirst setImage:firstImage forState:UIControlStateNormal];
        [self addSubview:_btnMenuFirst];
        
        _btnMenuSecond = [[UIButton alloc] initWithFrame:CGRectMake(8, 58, 40, 40)];
        UIImage *secondImage = [UIImage imageNamed:@"dropdown_menu2.png"];
        [_btnMenuSecond setImage:secondImage forState:UIControlStateNormal];
        [self addSubview:_btnMenuSecond];
        
        _btnMenuThird = [[UIButton alloc] initWithFrame:CGRectMake(8, 105, 40, 40)];
        UIImage *thirdImage = [UIImage imageNamed:@"dropdown_menu3.png"];
        [_btnMenuThird setImage:thirdImage forState:UIControlStateNormal];
        [self addSubview:_btnMenuThird];
        
        _btnMenuFourth = [[UIButton alloc] initWithFrame:CGRectMake(8, 152, 40, 40)];
        UIImage *fourthImage = [UIImage imageNamed:@"dropdown_menu4.png"];
        [_btnMenuFourth setImage:fourthImage forState:UIControlStateNormal];
        [self addSubview:_btnMenuFourth];
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
