//
//  TaskInfo.m
//  vanke
//
//  Created by pig on 13-6-12.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "TaskInfo.h"
#import "PCommonUtil.h"

@implementation TaskInfo

@synthesize taskID = _taskID;
@synthesize taskGroup = _taskGroup;
@synthesize taskName = _taskName;
@synthesize taskDesc = _taskDesc;
@synthesize needEnergy = _needEnergy;
@synthesize taskStatus = _taskStatus;
@synthesize finishTime = _finishTime;
@synthesize getTime = _getTime;

+(TaskInfo *)initWithNSDictionary:(NSDictionary *)dict{
    
    TaskInfo *taskInfo = nil;
    
    @try {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            taskInfo = [[TaskInfo alloc] init];
            taskInfo.taskID = [[dict objectForKey:@"taskID"] longValue];
            taskInfo.taskGroup = [dict objectForKey:@"taskGroup"];
            taskInfo.taskName = [dict objectForKey:@"taskName"];
            taskInfo.taskDesc = [dict objectForKey:@"taskDesc"];
            taskInfo.needEnergy = [[dict objectForKey:@"needEnergy"] floatValue];
            taskInfo.taskStatus = [PCommonUtil checkDataIsNull:[dict objectForKey:@"taskStatus"]];
            taskInfo.finishTime = [PCommonUtil checkDataIsNull:[dict objectForKey:@"finishTime"]];
            taskInfo.getTime = [PCommonUtil checkDataIsNull:[dict objectForKey:@"getTime"]];
            
        }
    }
    @catch (NSException *exception) {
        NSLog(@"parser TaskInfo failed...please check");
    }
    
    return taskInfo;
}

-(void)Log{
    NSLog(@"taskID(%ld), taskGroup(%@), taskName(%@), taskDesc(%@), needEnergy(%f), taskStatus(%@), finishTime(%@), getTime(%@)", _taskID, _taskGroup, _taskName, _taskDesc, _needEnergy, _taskStatus, _finishTime, _getTime);
}

@end
