//
//  RunUser.m
//  vanke
//
//  Created by pig on 13-6-11.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "RunUser.h"
#import "PCommonUtil.h"

@implementation RunUser

@synthesize userid = _userid;
@synthesize tall = _tall;
@synthesize weight = _weight;
@synthesize area = _area;
@synthesize address = _address;
@synthesize tel = _tel;

@synthesize nickname = _nickname;
@synthesize password = _password;
@synthesize fullname = _fullname;
@synthesize idcard = _idcard;
@synthesize communityid = _communityid;
@synthesize score = _score;
@synthesize birthday = _birthday;
@synthesize headImg = _headImg;

@synthesize mobile = _mobile;
@synthesize phone = _phone;
@synthesize imei = _imei;
@synthesize longitude = _longitude;
@synthesize latitude = _latitude;
@synthesize gps = _gps;
@synthesize gpsAddress = _gpsAddress;
@synthesize loginTime = _loginTime;
@synthesize addTime = _addTime;
@synthesize communityName = _communityName;
@synthesize rank = _rank;
@synthesize mileage = _mileage;
@synthesize minute = _minute;
@synthesize speed = _speed;
@synthesize calorie = _calorie;
@synthesize energy = _energy;
@synthesize runTimes = _runTimes;
@synthesize fanCount = _fanCount;
@synthesize mileageUsed = _mileageUsed;
@synthesize isPublic = _isPublic;
@synthesize isPosition = _isPosition;

+(RunUser *)initWithNSDictionary:(NSDictionary *)dict{
    
    RunUser *runner = nil;
    
    @try {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            
            runner = [[RunUser alloc] init];
            runner.userid = [PCommonUtil checkDataIsNull:[dict objectForKey:@"memberID"]];
            runner.nickname = [PCommonUtil checkDataIsNull:[dict objectForKey:@"nickName"]];
            runner.password = [PCommonUtil checkDataIsNull:[dict objectForKey:@"password"]];
            runner.fullname = [PCommonUtil checkDataIsNull:[dict objectForKey:@"fullName"]];
            runner.idcard = [PCommonUtil checkDataIsNull:[dict objectForKey:@"idCard"]];
            runner.tel = [PCommonUtil checkDataIsNull:[dict objectForKey:@"mobile"]];
            runner.communityid = [[PCommonUtil checkDataIsNull:[dict objectForKey:@"communityID"]] intValue];
            runner.headImg = [PCommonUtil checkDataIsNull:[dict objectForKey:@"headImg"]];
            runner.address = [PCommonUtil checkDataIsNull:[dict objectForKey:@"address"]];
            runner.birthday = [PCommonUtil checkDataIsNull:[dict objectForKey:@"birthday"]];
            if ([PCommonUtil checkDataIsNull:[dict objectForKey:@"weight"]]) {
                runner.weight = [[dict objectForKey:@"weight"] floatValue];
            }
            if (runner.weight < 10) {
                runner.weight = 60;//如果小于10kg，默认修改为60kg
            }
            if ([PCommonUtil checkDataIsNull:[dict objectForKey:@"height"]]) {
                runner.tall = [[dict objectForKey:@"height"] floatValue];
            }
            if ([PCommonUtil checkDataIsNull:[dict objectForKey:@"score"]]) {
                runner.score = [[dict objectForKey:@"score"] longValue];
            }
            runner.mobile = [PCommonUtil checkDataIsNull:[dict objectForKey:@"mobile"]];
            runner.phone = [PCommonUtil checkDataIsNull:[dict objectForKey:@"phone"]];
            runner.imei = [PCommonUtil checkDataIsNull:[dict objectForKey:@"imei"]];
            runner.longitude = [PCommonUtil checkDataIsNull:[dict objectForKey:@"longitude"]];
            runner.latitude = [PCommonUtil checkDataIsNull:[dict objectForKey:@"latitude"]];
            runner.gps = [PCommonUtil checkDataIsNull:[dict objectForKey:@"gps"]];
            runner.gpsAddress = [PCommonUtil checkDataIsNull:[dict objectForKey:@"gpsAddress"]];
            runner.loginTime = [dict objectForKey:@"loginTime"];
            runner.addTime = [dict objectForKey:@"addTime"];
            runner.communityName = [PCommonUtil checkDataIsNull:[dict objectForKey:@"communityName"]];
            if ([PCommonUtil checkDataIsNull:[dict objectForKey:@"rank"]]) {
                runner.rank = [[dict objectForKey:@"rank"] intValue];
            }
            if ([PCommonUtil checkDataIsNull:[dict objectForKey:@"mileage"]]) {
                runner.mileage = [[dict objectForKey:@"mileage"] floatValue];
            }
            if ([PCommonUtil checkDataIsNull:[dict objectForKey:@"minute"]]) {
                runner.minute = [[dict objectForKey:@"minute"] floatValue];
            }
            if ([PCommonUtil checkDataIsNull:[dict objectForKey:@"speed"]]) {
                runner.speed = [[dict objectForKey:@"speed"] floatValue];
            }
            if ([PCommonUtil checkDataIsNull:[dict objectForKey:@"calorie"]]) {
                runner.calorie = [[dict objectForKey:@"calorie"] floatValue];
            }
            if ([PCommonUtil checkDataIsNull:[dict objectForKey:@"energy"]]) {
                runner.energy = [[dict objectForKey:@"energy"] floatValue];
            }
            
            id tempruntimes = [PCommonUtil checkDataIsNull:[dict objectForKey:@"runTimes"]];
            if (tempruntimes) {
                runner.runTimes = [tempruntimes intValue];
            }
            
            id tempfancount = [PCommonUtil checkDataIsNull:[dict objectForKey:@"fanCount"]];
            if (tempfancount) {
                runner.fanCount = [tempfancount intValue];
            }
            
            if ([PCommonUtil checkDataIsNull:[dict objectForKey:@"mileageUsed"]]) {
                runner.mileageUsed = [[dict objectForKey:@"mileageUsed"] floatValue];
            }
            
            id tempispublic = [PCommonUtil checkDataIsNull:[dict objectForKey:@"isPublic"]];
            if (tempispublic) {
                runner.isPublic = [tempispublic intValue];
            } else {
                runner.isPublic = 0;
            }
            
            id tempisposition = [PCommonUtil checkDataIsNull:[dict objectForKey:@"isPosition"]];
            if (tempisposition) {
                runner.isPosition = [tempisposition intValue];
            } else {
                runner.isPosition = 0;
            }
            
        }
    }
    @catch (NSException *exception) {
        NSLog(@"parser RunUser failed...pease check");
    }
    
    return runner;
}

@end
