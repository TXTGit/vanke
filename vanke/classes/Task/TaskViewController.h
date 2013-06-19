//
//  TaskViewController.h
//  vanke
//
//  Created by pig on 13-6-12.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCustomNavigationBarView.h"

@interface TaskViewController : UIViewController

@property (nonatomic, retain) PCustomNavigationBarView *navView;

@property (nonatomic, retain) UIScrollView *tempScroll;
@property (nonatomic, retain) IBOutlet UIView *broadView;

@property (nonatomic, retain) IBOutlet UIImageView *ivTask1;
@property (nonatomic, retain) IBOutlet UIImageView *ivTask2;
@property (nonatomic, retain) IBOutlet UIImageView *ivTask3;
@property (nonatomic, retain) IBOutlet UIImageView *ivTask4;
@property (nonatomic, retain) IBOutlet UIImageView *ivTask5;
@property (nonatomic, retain) IBOutlet UIImageView *ivTask6;
@property (nonatomic, retain) IBOutlet UIImageView *ivTask7;
@property (nonatomic, retain) IBOutlet UIImageView *ivTask8;
@property (nonatomic, retain) IBOutlet UIImageView *ivTask9;

@property (nonatomic, retain) IBOutlet UIImageView *ivTaskText1;
@property (nonatomic, retain) IBOutlet UIImageView *ivTaskText2;
@property (nonatomic, retain) IBOutlet UIImageView *ivTaskText3;
@property (nonatomic, retain) IBOutlet UIImageView *ivTaskText4;
@property (nonatomic, retain) IBOutlet UIImageView *ivTaskText5;
@property (nonatomic, retain) IBOutlet UIImageView *ivTaskText6;
@property (nonatomic, retain) IBOutlet UIImageView *ivTaskText7;
@property (nonatomic, retain) IBOutlet UIImageView *ivTaskText8;
@property (nonatomic, retain) IBOutlet UIImageView *ivTaskText9;

@property (nonatomic, retain) IBOutlet UIButton *btnTaskCanTask1;
@property (nonatomic, retain) IBOutlet UIButton *btnTaskCanTask2;
@property (nonatomic, retain) IBOutlet UIButton *btnTaskCanTask3;
@property (nonatomic, retain) IBOutlet UIButton *btnTaskCanTask4;
@property (nonatomic, retain) IBOutlet UIButton *btnTaskCanTask5;
@property (nonatomic, retain) IBOutlet UIButton *btnTaskCanTask6;
@property (nonatomic, retain) IBOutlet UIButton *btnTaskCanTask7;
@property (nonatomic, retain) IBOutlet UIButton *btnTaskCanTask8;
@property (nonatomic, retain) IBOutlet UIButton *btnTaskCanTask9;

@property (nonatomic, retain) NSMutableArray *taskList;

-(void)doBack;
-(void)initData;
-(void)updateTaskState;

@end
