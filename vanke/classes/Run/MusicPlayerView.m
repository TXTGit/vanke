//
//  MusicPlayerView.m
//  vanke
//
//  Created by pig on 13-6-10.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "MusicPlayerView.h"

@implementation MusicPlayerView

@synthesize btnMusic = _btnMusic;
@synthesize btnLast = _btnLast;
@synthesize btnBegin = _btnBegin;
@synthesize btnNext = _btnNext;
@synthesize btnSound = _btnSound;
@synthesize sliderMusic = _sliderMusic;

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

-(IBAction)doMusic:(id)sender{
    
}

-(IBAction)doLast:(id)sender{
    
}

-(IBAction)doBegin:(id)sender{
    
}

-(IBAction)doNext:(id)sender{
    
}

-(IBAction)doSound:(id)sender{
    
}

@end
