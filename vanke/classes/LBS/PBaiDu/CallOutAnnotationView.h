//
//  CallOutAnnotationView.h
//  vanke
//
//  Created by pig on 13-6-15.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "BMKAnnotationView.h"
#import "BusPointCell.h"

@interface CallOutAnnotationView : BMKAnnotationView

@property (nonatomic, retain) UIView *contentView;

//在创建calloutView Annotation时，把contentView add的 subview赋值给businfoView
@property (nonatomic, retain) BusPointCell *busInfoView;

@end
