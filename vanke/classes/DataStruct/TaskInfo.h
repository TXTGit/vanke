//
//  TaskInfo.h
//  vanke
//
//  Created by pig on 13-6-12.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskInfo : NSObject

@property (nonatomic, assign) long taskID;
@property (nonatomic, retain) NSString *taskGroup;
@property (nonatomic, retain) NSString *taskName;
@property (nonatomic, retain) NSString *taskDesc;
@property (nonatomic, assign) float needEnergy;
@property (nonatomic, retain) NSString *taskStatus;
@property (nonatomic, retain) NSString *finishTime;
@property (nonatomic, retain) NSString *getTime;

+(TaskInfo *)initWithNSDictionary:(NSDictionary *)dict;
-(void)Log;

@end
