//
//  AAPlayerController.h
//  vanke
//
//  Created by pig on 13-6-10.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol AAPlayerControllerDelegete <NSObject>

- (void) aaPlayerStoped;

@end

@interface AAPlayerController : NSObject<AVAudioPlayerDelegate>

@property (nonatomic, retain) UISlider *musicProgressSlider;
@property (nonatomic, retain) UIButton *playerPlayPauseButton;

@property (nonatomic, assign) id<AAPlayerControllerDelegete> delegate;

@property (nonatomic, retain) AVAudioPlayer *avplayer;
@property (nonatomic, retain) NSTimer *playerTimer;
@property (nonatomic, retain) NSURL *sourceUrl;
@property (nonatomic) BOOL playerDestoried;

- (void) setSourcePath:(NSString *)sourcePath;
- (void) playerInit;
- (void) playerDestory;

- (BOOL) play;
- (void) playAtTime:(NSTimeInterval)time;
- (void) pause;
- (void) stop;

- (BOOL) isReadyToPlay;
- (BOOL) isPlaying;

- (void) setSingleLoop;

- (void) setSinglePlay;

- (IBAction)playerPlayPause;

- (NSTimeInterval) getCurrenttime;
- (NSTimeInterval) getDuration;

@end
