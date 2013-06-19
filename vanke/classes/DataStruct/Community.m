//
//  Community.m
//  vanke
//
//  Created by pig on 13-6-12.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "Community.h"

@implementation Community

@synthesize communityID = _communityID;
@synthesize communityGroup = _communityGroup;
@synthesize communityName = _communityName;
@synthesize communitySort = _communitySort;

+(Community *)initWithNSDictionary:(NSDictionary *)dict{
    
    Community *community = nil;
    
    @try {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            
            community = [[Community alloc] init];
            community.communityID = [[dict objectForKey:@"communityID"] intValue];
            community.communityGroup = [dict objectForKey:@"communityGroup"];
            community.communityName = [dict objectForKey:@"communityName"];
            community.communitySort = [[dict objectForKey:@"communitySort"] intValue];
            
        }
    }
    @catch (NSException *exception) {
        NSLog(@"parser Community failed...pease check");
    }
    
    return community;
}

@end
