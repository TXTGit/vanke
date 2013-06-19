//
//  CalloutMapAnnotation.h
//  vanke
//
//  Created by pig on 13-6-15.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMapKit.h"
#import "NearFriend.h"

@interface CalloutMapAnnotation : NSObject<BMKAnnotation>

@property (nonatomic) CLLocationDegrees latitude;
@property (nonatomic) CLLocationDegrees longitude;

@property (nonatomic, retain) NearFriend *nearFriend;

-(id)initWithLatitude:(CLLocationDegrees)lat andLongitude:(CLLocationDegrees)lon;

@end
