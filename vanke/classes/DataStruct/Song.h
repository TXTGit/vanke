//
//  Song.h
//  vanke
//
//  Created by pig on 13-6-15.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Song : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *artist;
@property (nonatomic, retain) NSString *music;
@property (nonatomic, retain) NSURL *musicUrl;

@end
