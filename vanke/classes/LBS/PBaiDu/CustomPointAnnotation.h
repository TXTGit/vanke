//
//  CustomPointAnnotation.h
//  vanke
//
//  Created by pig on 13-6-15.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "BMKPointAnnotation.h"
#import "NearFriend.h"

@interface CustomPointAnnotation : BMKPointAnnotation

@property (nonatomic, retain) NearFriend *nearFriend;

@end
