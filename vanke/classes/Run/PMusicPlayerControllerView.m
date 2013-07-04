//
//  PMusicPlayerControllerView.m
//  vanke
//
//  Created by pig on 13-6-13.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "PMusicPlayerControllerView.h"
#import "UIImage+PImageCategory.h"
#import "PCommonUtil.h"

@implementation PMusicPlayerControllerView

@synthesize musicImageView = _musicImageView;
@synthesize btnMusic = _btnMusic;
@synthesize btnLast = _btnLast;
@synthesize btnStart = _btnStart;
@synthesize soundImaegView = _soundImaegView;
@synthesize btnSound = _btnSound;
@synthesize sliderVolume = _sliderVolume;
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
        
        _musicImageView = [[UIImageView alloc] init];
        _musicImageView.frame = CGRectMake(20, 29, 12, 15);
        UIImage *musicImage = [UIImage imageNamed:@"run_music.png"];
        _musicImageView.image = musicImage;
        [self addSubview:_musicImageView];
        
        _btnMusic = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnMusic.frame = CGRectMake(3, 15, 44, 44);
        [self addSubview:_btnMusic];
        
        //last
        _btnLast = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnLast.frame = CGRectMake(55, 10, 53, 53);
        UIImage *lastImage = [UIImage imageNamed:@"run_last.png"];
        [_btnLast setImage:lastImage forState:UIControlStateNormal];
        [self addSubview:_btnLast];
        
        //start
//        _startBgImageView = [[UIImageView alloc] init];
//        _startBgImageView.frame = CGRectMake(124, 0, 72, 72);
//        UIImage *startBgImage = [UIImage imageNamed:@"run_begin_black.png"];
//        _startBgImageView.image = startBgImage;
//        [self addSubview:_startBgImageView];
//        
//        _playProcessImageView = [[UIImageView alloc] init];
//        _playProcessImageView.frame = CGRectMake(128, 4, 65, 65);
//        UIImage *playProcessImage = [UIImage imageNamed:@"run_begin_yellow130_1.png"];
//        _playProcessImageView.image = playProcessImage;
//        [self addSubview:_playProcessImageView];
//        
//        _btnStart = [UIButton buttonWithType:UIButtonTypeCustom];
//        _btnStart.frame = CGRectMake(130, 7, 60, 60);
//        UIImage *startImage = [UIImage imageNamed:@"run_begin_29.png"];
//        [_btnStart setImage:startImage forState:UIControlStateNormal];
//        [self addSubview:_btnStart];
        
        _btnStart = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnStart.frame = CGRectMake(124, 0, 72, 72);
        UIImage *palyImage = [UIImage imageNamed:@"run_player_play.png"];
        [_btnStart setImage:palyImage forState:UIControlStateNormal];
        [self addSubview:_btnStart];
        
        //next
        _btnNext = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnNext.frame = CGRectMake(213, 10, 53, 53);
        UIImage *nextImage = [UIImage imageNamed:@"run_next.png"];
        [_btnNext setImage:nextImage forState:UIControlStateNormal];
        [self addSubview:_btnNext];
        
        //sound
        _soundImaegView = [[UIImageView alloc] init];
        _soundImaegView.frame = CGRectMake(289, 29, 11, 15);
        UIImage *soundImage = [UIImage imageNamed:@"run_sound.png"];
        _soundImaegView.image = soundImage;
        [self addSubview:_soundImaegView];
        
        _btnSound = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnSound.frame = CGRectMake(273, 15, 44, 44);
        [self addSubview:_btnSound];
        
        _sliderVolume = [[UISlider alloc] init];
        _sliderVolume.frame = CGRectMake(204, 71, 118, 23);
        _sliderVolume.minimumTrackTintColor = [UIColor colorWithRed:249.0f/255.0f green:66.0f/255.0f blue:3.0f/255.0f alpha:1.0f];
        _sliderVolume.maximumTrackTintColor = [UIColor grayColor];
        _sliderVolume.maximumValue = 1;
        _sliderVolume.minimumValue = 0;
        _sliderVolume.value = 0.5;
        _sliderVolume.hidden = YES;
//        _sliderVolume.transform = CGAffineTransformMakeRotation(-90 * M_PI / 180);
        [self addSubview:_sliderVolume];
        
        _sliderMusicProcess = [[UISlider alloc] init];
        _sliderMusicProcess.frame = CGRectMake(10, 78, 300, 23);
        _sliderMusicProcess.minimumTrackTintColor = [UIColor orangeColor];
        _sliderMusicProcess.maximumTrackTintColor = [UIColor grayColor];
        [self addSubview:_sliderMusicProcess];
        
    }
    return self;
}

-(void)updatePlayingProcess:(float)playProcess{
    
    if (playProcess < 0.1) {
        playProcess = 0.01;
    }
    
    float width = 65.0f;
    float height = 65.0f;
    CGSize imageSize = CGSizeMake(width, height);
    UIImage *circleProcess = [UIImage imageWithName:@"run_begin_yellow130_1" type:@"png"];
    UIImage *processMask = [PCommonUtil getCircleProcessImageWithNoneAlpha:imageSize progress:playProcess];
    UIImage *currentProcessImage = [PCommonUtil maskImage:circleProcess withImage:processMask];
    _playProcessImageView.image = currentProcessImage;
    
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
