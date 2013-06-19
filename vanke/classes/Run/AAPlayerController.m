//
//  AAPlayerController.m
//  vanke
//
//  Created by pig on 13-6-10.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "AAPlayerController.h"

@implementation AAPlayerController

@synthesize musicProgressSlider = _musicProgressSlider;
@synthesize playerPlayPauseButton = _playerPlayPauseButton;

@synthesize delegate = _delegate;

@synthesize avplayer = _avplayer;
@synthesize playerTimer = _playerTimer;
@synthesize sourceUrl = _sourceUrl;
@synthesize playerDestoried = _playerDestoried;

- (void) setSourcePath:(NSString *)sourcePath
{
    if (sourcePath == nil || ![sourcePath isKindOfClass:[NSString class]]) sourcePath = @"";
    
    _sourceUrl = [[NSURL alloc] initFileURLWithPath:sourcePath];
    
}

- (void) playerInit
{
    if (_playerDestoried) return;
    
    NSError *perror = nil;
    _avplayer = [[AVAudioPlayer alloc] initWithContentsOfURL:_sourceUrl error:&perror];
    _avplayer.delegate = self;
}

- (void) playerDestory
{
    _playerDestoried = YES;
    [self timerStop];
    if (self.isPlaying) [self stop];
    
}

- (void) playerTimerFunction
{
    //播放数据刷新
    _musicProgressSlider.maximumValue = [self getDuration];
    _musicProgressSlider.value = [self getCurrenttime];
    
}

- (void) setSingleLoop
{
    _avplayer.numberOfLoops = 100000;
}

- (void) setSinglePlay
{
    _avplayer.numberOfLoops = 0;
}

- (IBAction)playerPlayPause
{
    if ([self isPlaying])
    {
        [self pause];
    }
    else
    {
        [self play];
    }
}

#pragma mark - player functions

- (BOOL) isReadyToPlay
{
    if (_avplayer == nil)
        return NO;
    
    return [_avplayer prepareToPlay];
}

- (BOOL) isPlaying
{
    if (_avplayer == nil)
        return NO;
    
    return _avplayer.playing;
}

- (BOOL) play
{
    [self playerTimerFunction];
    
    if (_avplayer == nil)
        return NO;
    
    BOOL isplayed = [_avplayer play];
    
    if (isplayed)
    {
        _avplayer.volume = 0.0f;
        [self timerStart];
    }
    
    return isplayed;
}

- (void) playAtTime:(NSTimeInterval)time
{
    if (_avplayer == nil)
        return;
    _avplayer.currentTime = time;
}

- (void) pause
{
    [self playerTimerFunction];
    
    if (_avplayer) [_avplayer pause];
    [self timerStop];
}

- (void) stop
{
    if (_avplayer) [_avplayer stop];
    [self timerStop];
}

- (NSTimeInterval) getCurrenttime
{
    if (_avplayer == nil)
        return 0;
    
    return [_avplayer currentTime];
}

- (NSTimeInterval) getDuration
{
    if (_avplayer == nil)
        return 0;
    
    return [_avplayer duration];
}

- (void) timerStart
{
    [self timerStop];
    _playerTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(playerTimerFunction) userInfo:nil repeats:YES];
}

- (void) timerStop
{
    @synchronized(self)
    {
        if (_playerTimer != nil)
        {
            if([_playerTimer isValid])
            {
                [_playerTimer invalidate];
            }
            _playerTimer = nil;
        }
    }
}

#pragma mark 
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (_delegate && [_delegate respondsToSelector:@selector(aaPlayerStoped)])
    {
        [_delegate aaPlayerStoped];
    }
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
    //change ui
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags
{
    if (player) [player play];
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withFlags:(NSUInteger)flags
{
    if (player) [player play];
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player
{
    if (player) [player play];
}

@end
