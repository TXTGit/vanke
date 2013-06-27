//
//  NewsInfo.m
//  vanke
//
//  Created by pig on 13-6-27.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "NewsInfo.h"

@implementation NewsInfo

@synthesize classID = _classID;
@synthesize title = _title;
@synthesize subTitle = _subTitle;
@synthesize smallText = _smallText;
@synthesize titleUrl = _titleUrl;
@synthesize titleImg = _titleImg;
@synthesize newsTime = _newsTime;
@synthesize className = _className;

+(NewsInfo *)initWithNSDictionary:(NSDictionary *)dict{
    
    NewsInfo *newsInfo = nil;
    
    @try {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            newsInfo = [[NewsInfo alloc] init];
            newsInfo.classID = [[dict objectForKey:@"classID"] intValue];
            newsInfo.title = [dict objectForKey:@"title"];
            newsInfo.subTitle = [dict objectForKey:@"subTitle"];
            newsInfo.smallText = [dict objectForKey:@"smallText"];
            newsInfo.titleUrl = [dict objectForKey:@"titleUrl"];
            newsInfo.titleImg = [dict objectForKey:@"titleImg"];
            newsInfo.newsTime = [dict objectForKey:@"newsTime"];
            newsInfo.className = [dict objectForKey:@"className"];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"parser NewsInfo failed...please check");
    }
    
    return newsInfo;
}

@end
