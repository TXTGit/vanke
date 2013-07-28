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
@synthesize newsID = _newsID;
@synthesize title = _title;
@synthesize subTitle = _subTitle;
@synthesize smallText = _smallText;
@synthesize titleUrl = _titleUrl;
@synthesize titleImg = _titleImg;
@synthesize newsTime = _newsTime;
@synthesize className = _className;
@synthesize newsText = _newsText;

+(NewsInfo *)initWithNSDictionary:(NSDictionary *)dict{
    
    NewsInfo *newsInfo = nil;
    
    @try {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            newsInfo = [[NewsInfo alloc] init];
            newsInfo.classID = [[dict objectForKey:@"classID"] intValue];
            newsInfo.newsID = [[dict objectForKey:@"newsID"] intValue];
            newsInfo.title = [dict objectForKey:@"title"];
            newsInfo.subTitle = [dict objectForKey:@"subTitle"];
            newsInfo.smallText = [dict objectForKey:@"smallText"];
            newsInfo.titleUrl = [dict objectForKey:@"titleUrl"];
            newsInfo.titleImg = [dict objectForKey:@"titleImg"];
            newsInfo.newsTime = [dict objectForKey:@"newsTime"];
            newsInfo.className = [dict objectForKey:@"className"];
            newsInfo.newsText = [dict objectForKey:@"newsText"];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"parser NewsInfo failed...please check");
    }
    
    return newsInfo;
}

@end
