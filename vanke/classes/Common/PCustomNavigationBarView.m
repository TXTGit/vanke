//
//  PCustomNavigationBarView.m
//  itime
//
//  Created by pig on 13-4-19.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "PCustomNavigationBarView.h"
#import "UIImage+PImageCategory.h"
#import "PCommonUtil.h"
#import "UserSessionManager.h"

@implementation PCustomNavigationBarView

@synthesize bgImageView = _bgImageView;
@synthesize titleLabel = _titleLabel;
@synthesize leftButton = _leftButton;
@synthesize rightButton = _rightButton;
@synthesize messageTipImageView = _messageTipImageView;

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

- (id)initWithTitle:(NSString *)tTitle bgImageView:(NSString *)tImageName
{
    self = [super initWithFrame:CGRectMake(0, 0, 320, 44)];
    if (self) {
        UIImage *bgimage = [UIImage imageNamed:tImageName];
        _bgImageView = [[UIImageView alloc] initWithImage:bgimage];
        _bgImageView.frame = CGRectMake(0, 0, 320, 44);
        [self addSubview:_bgImageView];
        
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFrame:CGRectMake(40, 10, 240, 21)];
        [_titleLabel setText:tTitle];
        [_titleLabel setTextAlignment:kTextAlignmentCenter];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [_titleLabel setFont:[UIFont systemFontOfSize:20.0f]];
        [_titleLabel setTextColor:[UIColor whiteColor]];
        [_titleLabel setShadowOffset:CGSizeMake(0, 1)];
        [self addSubview:_titleLabel];
        
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftButton setFrame:CGRectMake(5, 2, 40, 40)];
        [_leftButton setHidden:YES];
        [self addSubview:_leftButton];
        
        _rightButton = [EGOImageButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setFrame:CGRectMake(274, 2, 40, 40)];
        [_rightButton setHidden:YES];
        _rightButton.delegate = self;
        [self addSubview:_rightButton];
        
        _messageTipImageView = [[UIImageView alloc] init];
        [_messageTipImageView setFrame:CGRectMake(300, 2, 18, 18)];
        UIImage *messageTip = [UIImage imageWithName:@"index_button_new" type:@"png"];
        [_messageTipImageView setImage:messageTip];
        [_messageTipImageView setHidden:YES];
        [self addSubview:_messageTipImageView];
        
        //添加监听，判断是否有未读消息
        [[NSNotificationCenter defaultCenter]
         addObserver:self selector:@selector(updateUnreadTips) name:UpdateUnreadMessageCount object:nil];
    }
    return self;
}

-(void)updateUnreadTips
{
    if ([UserSessionManager GetInstance].unreadMessageCount > 0) {
        [self.messageTipImageView setHidden:NO];
    } else {
        [self.messageTipImageView setHidden:YES];
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]
     removeObserver:self name:UpdateUnreadMessageCount object:nil];
}

#pragma EGOImageButtonDelegate

//合并图片
-(UIImage *)mergerImage:(UIImage *)firstImage secodImage:(UIImage *)secondImage{
    
    CGSize imageSize = CGSizeMake(90, 90);
    UIGraphicsBeginImageContext(imageSize);
    
    [firstImage drawInRect:CGRectMake(0, 0, firstImage.size.width, firstImage.size.height)];
    [secondImage drawInRect:CGRectMake(-1.5, -1.5, secondImage.size.width, secondImage.size.height)];
    
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
}

- (void)imageButtonLoadedImage:(EGOImageButton*)imageButton{
    
    if (imageButton) {
        
        UIImage *image = [imageButton imageForState:UIControlStateNormal];
        NSLog(@"image.size.width: %f, image.size.height: %f", image.size.width, image.size.height);
        /*
        UIImage *avatarImage = [UIImage scaleImage:image scaleToSize:CGSizeMake(90, 90)];
        NSLog(@"avatarImage.size.width: %f, avatarImage.size.height: %f", avatarImage.size.width, avatarImage.size.height);
        
        UIImage *whiteCircle = [UIImage imageWithName:@"white_circle" type:@"png"];
        NSLog(@"whiteCircle.size.width: %f, whiteCircle.size.height: %f", whiteCircle.size.width, whiteCircle.size.height);
        
        image = [self mergerImage:avatarImage secodImage:whiteCircle];
        NSLog(@"image.size.width: %f, image.size.height: %f", image.size.width, image.size.height);
        */
        [imageButton setImage:image forState:UIControlStateNormal];
        
    }
    
}

- (void)imageButtonFailedToLoadImage:(EGOImageButton*)imageButton error:(NSError*)error{
    
    UIImage *defaultAvatarImage = [UIImage imageWithName:@"main_head" type:@"png"];
    [imageButton setImage:defaultAvatarImage forState:UIControlStateNormal];
    
}

@end
