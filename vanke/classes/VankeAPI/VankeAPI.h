//
//  VankeAPI.h
//  vanke
//
//  Created by pig on 13-6-11.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VankeAPI : NSObject

//注册（2013-6-22）
+(NSString *)getRegisterUrl:(NSString *)mobile password:(NSString *)password nickname:(NSString *)nickname fullname:(NSString *)fullname idCard:(NSString *)idCard;

//登陆
+(NSString *)getLoginUrl:(NSString *)mobile password:(NSString *)password;

//获取社区列表
+(NSString *)getCommunityListUrl;

//绑定社区
+(NSString *)getSetCommunityUrl:(NSString *)memberid communityId:(NSString *)communityid;

//设置gps位置
+(NSString *)getSetGPSUrl:(NSString *)memberid gpsData:(NSString *)gpsdata;

//设置个人信息
+(NSString *)getSetInfoUrl:(NSString *)memberid height:(NSString *)height weight:(NSString *)weight birthday:(NSString *)birthday;

//获取会员资料（2013-6-22）
+(NSString *)getGetMemberUrl:(NSString *)memberid;

//获取会员详细资料（2013-6-22）
+(NSString *)getGetMemberDetailUrl:(NSString *)memberid;

//上传头像（2013-6-22）
+(NSString *)getSetHeadImgUrl:(NSString*)memberid;

//跑步（2013-6-22）
+(NSString *)getRunUrl:(NSString *)memberid mileage:(NSString *)mileage minute:(int)minute speed:(float)speed calorie:(float)calorie line:(NSString *)line runTime:(NSString *)runtime;

//分享（2013-6-22）
+(NSString *)getSendShareUrl:(NSString*)memberid shareContent:(NSString*)shareContent;

//获取分享列表（2013-6-22）
+(NSString *)getShareListUrl:(NSString*)memberid page:(NSInteger)page rows:(NSInteger)pageCount;

//获取分享的图片地址
+(NSString *)getSharePicUrl:(NSString*)imageName;

//获取跑步记录列表（2013-6-22）
+(NSString *)getGetRunListUrl:(NSString *)memberid page:(int)page rows:(int)rows;

//获取本周跑步记录列表（2013-6-17）
+(NSString *)getGetWeekRunListUrl:(NSString *)memberid;

//获取任务列表（2013-6-22）
+(NSString *)getGetTaskListUrl:(NSString *)memberid;

//获取附近跑友列表（2013-6-22）
+(NSString *)getGetLbsListUrl:(NSString *)memberid gpsData:(NSString *)gps radius:(long)radius;

//获取社区跑友列表（2013-6-22）
+(NSString *)getLbsCommunityList:(NSString *)memberid communityID:(int)communityid gpsData:(NSString *)gps radius:(long)radius;

//获取好友列表（2013-6-22）
+(NSString *)getGetFanListUrl:(NSString *)memberid;

//获取是否好友（2013-6-22）
+(NSString *)getIsFanUrl:(NSString*)memberid :(NSString*)fromMemberID;

//发送约跑邀请（2013-6-17）
+(NSString *)getSendInviteUrl:(NSString *)memberid toMemberId:(NSString *)tomemberid msgText:(NSString *)msgtext;

//获取约跑邀请列表(2013-6-17)
+(NSString *)getInviteListUrl:(NSString*)memberid :(NSInteger)page :(NSInteger)pageCount;

//加为好友（2013-6-22）
+(NSString *)getAddFanUrl:(NSString*)memberid :(NSString*)toMemberID :(NSString*)inviteId;

//拒绝邀请（2013-6-22）
+(NSString *)getRejectInviteUrl:(NSString *)inviteid;

//发送普通信息（2013-6-22）
+(NSString *)getSendMsgUrl:(NSString *)memberid toMemberId:(NSString *)tomemberid msgText:(NSString *)msgtext;

//获取所有未读信息数量（2013-6-17）
+(NSString *)getGetUnreadListUrl:(NSString *)memberid;

//获取聊天记录列表（2013-6-22）
+(NSString *)getGetMsgListUrl:(NSString *)memberid fromMemberID:(NSString *)fromMemberID lastMsgId:(long)lastmsgid;

//获取好友排名列表（2013-6-17）
+(NSString *)getGetFanRankListUrl:(NSString *)memberid rankType:(int)ranktype;

//获取社区排名列表（2013-6-17）
+(NSString *)getGetCommunityRankListUrl:(NSString *)memberid rankType:(int)ranktype;

//长轮询通知接口（2013-6-17）
+(NSString *)getUnreadUrl:(NSString *)memberid;




@end
