//
//  Community.h
//  vanke
//
//  Created by pig on 13-6-12.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Community : NSObject

@property (nonatomic, assign) int communityID;
@property (nonatomic, retain) NSString *communityGroup;
@property (nonatomic, retain) NSString *communityName;
@property (nonatomic, assign) int communitySort;

+(Community *)initWithNSDictionary:(NSDictionary *)dict;

@end
