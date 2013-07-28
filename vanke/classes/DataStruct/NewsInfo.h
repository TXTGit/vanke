//
//  NewsInfo.h
//  vanke
//
//  Created by pig on 13-6-27.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsInfo : NSObject

@property (nonatomic, assign) int classID;
@property (nonatomic, assign) int newsID;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *subTitle;
@property (nonatomic, retain) NSString *smallText;
@property (nonatomic, retain) NSString *titleUrl;
@property (nonatomic, retain) NSString *titleImg;
@property (nonatomic, retain) NSString *newsTime;
@property (nonatomic, retain) NSString *className;
@property (nonatomic, retain) NSString *newsText;

//活动信息
+(NewsInfo *)initWithNSDictionary:(NSDictionary *)dict;

@end
