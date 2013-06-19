//
//  CalloutMapAnnotation.m
//  vanke
//
//  Created by pig on 13-6-15.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "CalloutMapAnnotation.h"

@implementation CalloutMapAnnotation

@synthesize latitude = _latitude;
@synthesize longitude = _longitude;
@synthesize nearFriend = _nearFriend;

-(id)initWithLatitude:(CLLocationDegrees)lat andLongitude:(CLLocationDegrees)lon{
    
    if (self = [super init]) {
        _latitude = lat;
        _longitude = lon;
    }
    return self;
}

-(CLLocationCoordinate2D)coordinate{
    
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = _latitude;
    coordinate.longitude = _longitude;
    
    return coordinate;
}

@end
