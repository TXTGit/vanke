//
//  MusicPlayerView.h
//  vanke
//
//  Created by pig on 13-6-10.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicPlayerView : UIView

@property (nonatomic, retain) IBOutlet UIButton *btnMusic;
@property (nonatomic, retain) IBOutlet UIButton *btnLast;
@property (nonatomic, retain) IBOutlet UIButton *btnBegin;
@property (nonatomic, retain) IBOutlet UIButton *btnNext;
@property (nonatomic, retain) IBOutlet UIButton *btnSound;
@property (nonatomic, retain) IBOutlet UISlider *sliderMusic;

-(IBAction)doMusic:(id)sender;
-(IBAction)doLast:(id)sender;
-(IBAction)doBegin:(id)sender;
-(IBAction)doNext:(id)sender;
-(IBAction)doSound:(id)sender;

@end
