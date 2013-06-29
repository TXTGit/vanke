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
@synthesize btnMenu1 = _btnMenu1;
@synthesize btnMenu2 = _btnMenu2;
@synthesize btnMenu3 = _btnMenu3;
@synthesize btnMenu4 = _btnMenu4;

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
        
        _btnMenu1 = [[UIButton alloc] initWithFrame:CGRectMake(8, 10, 40, 40)];
        UIImage *firstImage = [UIImage imageNamed:@"dropdown_menu1.png"];
        [_btnMenu1 setImage:firstImage forState:UIControlStateNormal];
        [self addSubview:_btnMenu1];
        
        _btnMenu2 = [[UIButton alloc] initWithFrame:CGRectMake(8, 58, 40, 40)];
        UIImage *secondImage = [UIImage imageNamed:@"dropdown_menu2.png"];
        [_btnMenu2 setImage:secondImage forState:UIControlStateNormal];
        [self addSubview:_btnMenu2];
        
        _btnMenu3 = [[UIButton alloc] initWithFrame:CGRectMake(8, 105, 40, 40)];
        UIImage *thirdImage = [UIImage imageNamed:@"dropdown_menu3.png"];
        [_btnMenu3 setImage:thirdImage forState:UIControlStateNormal];
        [self addSubview:_btnMenu3];
        
        _btnMenu4 = [[UIButton alloc] initWithFrame:CGRectMake(8, 152, 40, 40)];
        UIImage *fourthImage = [UIImage imageNamed:@"dropdown_menu4.png"];
        [_btnMenu4 setImage:fourthImage forState:UIControlStateNormal];
        [self addSubview:_btnMenu4];
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
