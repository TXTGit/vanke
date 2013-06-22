//
//  PMusicPlayerControllerView.h
//  vanke
//
//  Created by pig on 13-6-13.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PMusicPlayerControllerView : UIView

@property (nonatomic, retain) UIButton *btnMusic;
@property (nonatomic, retain) UIButton *btnLast;
@property (nonatomic, retain) UIButton *btnStart;
@property (nonatomic, retain) UIButton *btnNext;
@property (nonatomic, retain) UIButton *btnSound;
@property (nonatomic, retain) UISlider *sliderMusicProcess;
@property (nonatomic, retain) UISlider *sliderVolume;

-(id)initMusicPlayerController:(CGRect)frame;

@end
