//
//  IndexViewController.h
//  vanke
//
//  Created by pig on 13-6-9.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCustomNavigationBarView.h"
#import "EGOImageView.h"

@interface IndexViewController : UIViewController

@property (nonatomic, retain) PCustomNavigationBarView *navView;
@property (nonatomic, retain) IBOutlet UIButton *btnIndexRun;
@property (nonatomic, retain) IBOutlet UIButton *btnIndexVanke;
@property (nonatomic, retain) IBOutlet UIButton *btnIndexStore;

-(IBAction)doIndexRun:(id)sender;
-(IBAction)doIndexVanke:(id)sender;
-(IBAction)doIndexStore:(id)sender;

@end
