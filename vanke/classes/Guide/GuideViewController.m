//
//  GuideViewController.m
//  vanke
//
//  Created by pig on 13-6-9.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "GuideViewController.h"
#import "UIImage+PImageCategory.h"
#import "LoginViewController.h"
#import "PCommonUtil.h"

@interface GuideViewController ()

@end

@implementation GuideViewController

@synthesize guideScrollView = _guideScrollView;
@synthesize guidePageControl = _guidePageControl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    float height = [UIScreen mainScreen].bounds.size.height - 20;
    int photoCount = 4;
    
    _guideScrollView = [[UIScrollView alloc] init];
    if ([PCommonUtil isIPhone5]) {
        _guideScrollView.frame = CGRectMake(0, 0, 320, 568);
    }else{
        _guideScrollView.frame = CGRectMake(0, -30, 320, 568);
    }
    _guideScrollView.scrollEnabled = YES;
    _guideScrollView.showsHorizontalScrollIndicator = NO;
    _guideScrollView.pagingEnabled = YES;
    _guideScrollView.delegate = self;
    
    _guideScrollView.contentSize = CGSizeMake(320 * photoCount, 568);
    for (int i=0; i<photoCount; i++) {
        
        NSString *fsImageName = [NSString stringWithFormat:@"fs0%d", i];
        UIImageView *fsImageView = [[UIImageView alloc] init];
        fsImageView.frame = CGRectMake(320 * i, 0, 320, 568);
        fsImageView.image = [UIImage imageWithName:fsImageName type:@"png"];
        [_guideScrollView addSubview:fsImageView];
    }
    
    UIButton *btnStart = [UIButton buttonWithType:UIButtonTypeCustom];
    btnStart.frame = CGRectMake(320 * 3 + 60, 568 - 150, 200, 100);
    btnStart.backgroundColor = [UIColor clearColor];
    btnStart.alpha = 0.4f;
    [btnStart addTarget:self action:@selector(gotoNextView) forControlEvents:UIControlEventTouchUpInside];
    [_guideScrollView addSubview:btnStart];
    
    [self.view addSubview:_guideScrollView];
    
    _guidePageControl = [[UIPageControl alloc] init];
    _guidePageControl.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 40, 320, 16);
    _guidePageControl.numberOfPages = photoCount;
    _guidePageControl.currentPage = 0;
    _guidePageControl.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_guidePageControl];
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    int page = 0;
    CGFloat pageWidth = scrollView.frame.size.width;
    page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _guidePageControl.currentPage = page;
    
}

-(void)gotoNextView{
    
    LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [self.navigationController pushViewController:loginViewController animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
