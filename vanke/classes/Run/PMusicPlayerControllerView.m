//
//  PMusicPlayerControllerView.m
//  vanke
//
//  Created by pig on 13-6-13.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "PMusicPlayerControllerView.h"

@implementation PMusicPlayerControllerView

@synthesize btnMusic = _btnMusic;
@synthesize btnLast = _btnLast;
@synthesize btnStart = _btnStart;
@synthesize btnSound = _btnSound;
@synthesize sliderMusicProcess = _sliderMusicProcess;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initMusicPlayerController:(CGRect)frame{
    
//    self = [super initWithFrame:CGRectMake(0, 0, 320, 100)];
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _btnMusic = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnMusic.frame = CGRectMake(20, 29, 12, 15);
        UIImage *musicImage = [UIImage imageNamed:@"run_music.png"];
        [_btnMusic setImage:musicImage forState:UIControlStateNormal];
        [self addSubview:_btnMusic];
        
        _btnLast = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnLast.frame = CGRectMake(55, 10, 53, 53);
        UIImage *lastImage = [UIImage imageNamed:@"run_last.png"];
        [_btnLast setImage:lastImage forState:UIControlStateNormal];
        [self addSubview:_btnLast];
        
        _btnStart = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnStart.frame = CGRectMake(124, 0, 72, 72);
        UIImage *startImage = [UIImage imageNamed:@"run_begin.png"];
        [_btnStart setImage:startImage forState:UIControlStateNormal];
        [self addSubview:_btnStart];
        
        _btnNext = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnNext.frame = CGRectMake(213, 10, 53, 53);
        UIImage *nextImage = [UIImage imageNamed:@"run_next.png"];
        [_btnNext setImage:nextImage forState:UIControlStateNormal];
        [self addSubview:_btnNext];
        
        _btnSound = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnSound.frame = CGRectMake(289, 29, 11, 15);
        UIImage *soundImage = [UIImage imageNamed:@"run_sound.png"];
        [_btnSound setImage:soundImage forState:UIControlStateNormal];
        [self addSubview:_btnSound];
        
        _sliderMusicProcess = [[UISlider alloc] init];
        _sliderMusicProcess.frame = CGRectMake(10, 78, 300, 23);
        _sliderMusicProcess.minimumTrackTintColor = [UIColor orangeColor];
        _sliderMusicProcess.maximumTrackTintColor = [UIColor grayColor];
        [self addSubview:_sliderMusicProcess];
        
        
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
