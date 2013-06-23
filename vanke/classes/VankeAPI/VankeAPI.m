//
//  VankeAPI.m
//  vanke
//
//  Created by pig on 13-6-11.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "VankeAPI.h"
#import "VankeConfig.h"
#import "PCommonUtil.h"

@implementation VankeAPI

/*
 注册（2013-6-22）
 •	地址：
 http://www.4000757888.com:880/i.aspx?type=signup&mobile=18818801116&password=131313&nickName=sing大6&fullName=sing大6&idCard=440682198601011116
 •	参数：
 mobile：手机，唯一标识
 password：密码
 nickName：昵称
 fullName：全名
 idCard：身份证
 •	返回：
 memberID：会员ID
 */
+(NSString *)getRegisterUrl:(NSString *)mobile password:(NSString *)password nickname:(NSString *)nickname fullname:(NSString *)fullname idCard:(NSString *)idCard{
    
    NSString *tempnickname = [PCommonUtil encodeUrlParameter:nickname];
    NSString *tempfullname = [PCommonUtil encodeUrlParameter:fullname];
    
    return [NSString stringWithFormat:@"%@?type=signup&mobile=%@&password=%@&nickName=%@&fullName=%@&idCard=%@", VANKE_DOMAIN, mobile, password, tempnickname, tempfullname, idCard];
}

/*
 登录
 •	地址：
 http://www.4000757888.com:880/i.aspx?type=login&mobile=18818801116&password=131313
 •	参数：
 mobile：手机，唯一标识
 password：密码
 •	返回：
 memberID：会员ID
 communityID：会员的社区ID，为0则要求其绑定社区，不为0则已经绑定
 */
+(NSString *)getLoginUrl:(NSString *)mobile password:(NSString *)password{
    
    return [NSString stringWithFormat:@"%@?type=login&mobile=%@&password=%@", VANKE_DOMAIN, mobile, password];
}

/*
 获取社区列表
 •	地址：
 http://www.4000757888.com:880/i.aspx?type=getCommunityList
 •	参数：
 无
 •	返回：
 list：社区列表
 */
+(NSString *)getCommunityListUrl{
    
    return [NSString stringWithFormat:@"%@?type=getCommunityList", VANKE_DOMAIN];
}


/*
 绑定社区
 •	地址：
 http://www.4000757888.com:880/i.aspx?type=setCommunity&memberID=23&communityID=2
 •	参数：
 memberID：会员ID
 communityID：社区ID
 •	返回：
 */
+(NSString *)getSetCommunityUrl:(NSString *)memberid communityId:(NSString *)communityid{
    
    return [NSString stringWithFormat:@"%@?type=setCommunity&memberID=%@&communityID=%@", VANKE_DOMAIN, memberid, communityid];
}

/*
 设置GPS位置
 •	地址：
 http://www.4000757888.com:880/i.aspx?type=setGps&memberID=23&gps=113.314046,23.115895
 •	参数：
 memberID：会员ID
 gps：gps
 •	返回：
 */
+(NSString *)getSetGPSUrl:(NSString *)memberid gpsData:(NSString *)gpsdata{
    
    return [NSString stringWithFormat:@"%@?type=setGps&memberID=%@&gps=%@", VANKE_DOMAIN, memberid, gpsdata];
}

/*
 设置个人信息
 •	地址：
 http://www.4000757888.com:880/i.aspx?type=setInfo&memberID=23&height=183&weight=65&birthday=1986-01-01
 •	参数：
 memberID：会员ID
 height：身高，单位米
 weight：体重，单位公斤
 birthday：生日，格式：1986-01-01
 •	返回：
 */
+(NSString *)getSetInfoUrl:(NSString *)memberid height:(NSString *)height weight:(NSString *)weight birthday:(NSString *)birthday{
    
    NSString *tempBirthday = [PCommonUtil encodeUrlParameter:birthday];
    
    return [NSString stringWithFormat:@"%@?type=setInfo&memberID=%@&height=%@&weight=%@&birthday=%@", VANKE_DOMAIN, memberid, height, weight, tempBirthday];
}

/*
 获取会员资料（2013-6-22）
 •	地址：
 http://www.4000757888.com:880/i.aspx?type=getMember&memberID=23
 •	参数：
 memberID：会员ID
 •	返回：
 imgPath：头像图片文件夹路径
 ent：会员资料对象
 */
+(NSString *)getGetMemberUrl:(NSString *)memberid{
    
    return [NSString stringWithFormat:@"%@?type=getMember&memberID=%@", VANKE_DOMAIN, memberid];
}

/*
 上传头像（2013-6-22）
 •	地址：
 http://www.4000757888.com:880/i.aspx?type=setHeadImg&memberID=23&headImg=Post的Base64字符串
 •	参数：
 memberID：会员ID
 headImg：图片文件转换成Base64字符串，用Post方式提交
 •	返回：
 */
+(NSString *)getSetHeadImgUrl:(NSString*)memberid{
    return [NSString stringWithFormat:@"%@?type=setHeadImg&memberID=%@", VANKE_DOMAIN, memberid];
}

/*
 跑步（2013-6-22）
 •	地址：
 http://www.4000757888.com:880/i.aspx?type=run&memberID=23&mileage=3&minute=20&speed=15&calorie=50&runTime=2013-06-22 12:10:10&line=113.316166,23.116726;113.316166,23.116726;
 •	参数：
 memberID：会员ID
 mileage：里程，单位公里
 minute：耗时，单位分钟
 speed：速度，单位米/秒
 calorie：卡路里，单位卡
 runTime：跑步时间，格式：2013-06-10 12:10:20
 line：路线，多个gps点之间用分号分割，用Post方式提交
 •	返回：
 */
+(NSString *)getRunUrl:(NSString *)memberid mileage:(NSString *)mileage minute:(int)minute speed:(float)speed calorie:(float)calorie line:(NSString *)line runTime:(NSString *)runtime{
    
    NSString *tempRunTime = [PCommonUtil encodeUrlParameter:runtime];
    
    return [NSString stringWithFormat:@"%@?type=run&memberID=%@&mileage=%@&minute=%d&speed=%f&calorie=%f&line=%@&runTime=%@", VANKE_DOMAIN, memberid, mileage, minute, speed, calorie, line, tempRunTime];
}

/*
 分享（2013-6-22）
 •	地址：
 http://www.4000757888.com:880/i.aspx?type=share&memberID=23&shareContent=我是一只小青蛙，呱呱呱呱呱&shareImg=Post的Base64字符串
 •	参数：
 memberID：会员ID
 shareContent：分享内容
 shareImg：图片文件转换成Base64字符串，用Post方式提交
 •	返回：
 */
+(NSString *)getSendShareUrl:(NSString*)memberid shareContent:(NSString*)shareContent{
    return [NSString stringWithFormat:@"%@?type=share&memberID=%@&shareContent=%@",VANKE_DOMAIN,memberid,[PCommonUtil encodeUrlParameter:shareContent]];
}

/*
 获取分享列表（2013-6-22）
 •	地址：
 http://www.4000757888.com:880/i.aspx?type=getShareList&memberID=23&page=1&rows=5
 •	参数：
 memberID：会员ID
 page：当前页数
 rows：每页显示记录数
 •	返回：
 imgPath：分享图片文件夹路径
 list：当前页的分享列表
 */
+(NSString *)getShareListUrl:(NSString*)memberid :(NSInteger)page :(NSInteger)pageCount
{
    return [NSString stringWithFormat:@"%@?type=getShareList&memberID=%@&page=%d&rows=%d",VANKE_DOMAIN,memberid,page,pageCount];
}

//获取分享的图片地址
+(NSString *)getSharePicUrl:(NSString*)imageName
{
    return [NSString stringWithFormat:@"%@/upload/share/%@", VANKE_DOMAINBase, imageName];
}

/*
 获取跑步记录列表（2013-6-22）
 •	地址：
 http://www.4000757888.com:880/i.aspx?type=getRunList&memberID=23&page=1&rows=20
 •	参数：
 memberID：会员ID
 page：当前页数
 rows：每页显示记录数
 •	返回：
 list：当前页的跑步记录列表
 */
+(NSString *)getGetRunListUrl:(NSString *)memberid page:(int)page rows:(int)rows{
    
    return [NSString stringWithFormat:@"%@?type=getRunList&memberID=%@&page=%d&rows=%d", VANKE_DOMAIN, memberid, page, rows];
}

/*
 获取本周跑步记录列表
 •	地址：
 http://www.4000757888.com:880/i.aspx?type=getWeekRunList&memberID=23
 •	参数：
 memberID：会员ID
 •	返回：
 list：本周跑步记录列表，从周一开始
 */
+(NSString *)getGetWeekRunListUrl:(NSString *)memberid{
    
    return [NSString stringWithFormat:@"%@?type=getWeekRunList&memberID=%@", VANKE_DOMAIN, memberid];
}

/*
 获取任务列表（2013-6-22）
 •	地址：
 http://www.4000757888.com:880/i.aspx?type=getTaskList&memberID=23
 •	参数：
 memberID：会员ID
 •	返回：
 list：任务列表，字段taskStatus代表状态，已完成=1，已申领=2，已领取=3
 */
+(NSString *)getGetTaskListUrl:(NSString *)memberid{
    
    return [NSString stringWithFormat:@"%@?type=getTaskList&memberID=%@", VANKE_DOMAIN, memberid];
}

/*
 获取附近跑友列表（2013-6-22）
 •	地址：
 http://www.4000757888.com:880/i.aspx?type=getLbsList&memberID=23&gps=113.316166,23.116726&radius=1000
 •	参数：
 memberID：会员ID
 gps：gps
 radius：搜索半径，单位米
 •	返回：
 list：跑友列表，字段isFan为1代表好友，字段distance代表距离，单位米
 */
+(NSString *)getGetLbsListUrl:(NSString *)memberid gpsData:(NSString *)gps radius:(long)radius{
    
    return [NSString stringWithFormat:@"%@?type=getLbsList&memberID=%@&gps=%@&radius=%ld", VANKE_DOMAIN, memberid, gps, radius];
}

/*
 获取社区跑友列表（2013-6-22）
 •	地址：
 http://www.4000757888.com:880/i.aspx?type=getCommunityLbsList&memberID=23&gps=113.316166,23.116726&radius=1000&communityID=3
 •	参数：
 memberID：会员ID
 gps：gps
 radius：搜索半径，单位米
 communityID：社区ID
 •	返回：
 list：跑友列表，字段isFan为1代表好友，字段distance代表距离，单位米
 */
+(NSString *)getLbsCommunityList:(NSString *)memberid communityID:(int)communityid gpsData:(NSString *)gps radius:(long)radius{
    
    return [NSString stringWithFormat:@"%@?type=getLbsCommunityList&memberID=%@&communityID=%d&gps=%@&radius=%ld", VANKE_DOMAIN, memberid, communityid, gps, radius];
}

/*
 获取好友列表（2013-6-22）
 •	地址：
 http://www.4000757888.com:880/i.aspx?type=getFanList&memberID=23
 •	参数：
 memberID：会员ID
 •	返回：
 list：好友列表，字段fromMemberID代表好友的会员ID
 */
+(NSString *)getGetFanListUrl:(NSString *)memberid{
    
    return [NSString stringWithFormat:@"%@?type=getFanList&memberID=%@", VANKE_DOMAIN, memberid];
}

/*
 获取是否好友（2013-6-22）
 •	地址：
 http://www.4000757888.com:880/i.aspx?type=getIsFan&memberID=23&fromMemberID=33
 •	参数：
 memberID：会员ID
 fromMemberID：对方会员ID
 •	返回：
 isFan：1代表好友，0代表非好友
 */
+(NSString *)getIsFanUrl:(NSString*)memberid :(NSString*)fromMemberID{
    return [NSString stringWithFormat:@"%@?type=getIsFan&memberID=%@&fromMemberID=%@",VANKE_DOMAIN,memberid,fromMemberID];
}

/*
 发送约跑邀请
 •	地址：
 http://www.4000757888.com:880/i.aspx?type=sendInvite&memberID=23&toMemberID=33&inviteText=adfsad
 •	参数：
 memberID：自己会员ID
 toMemberID：对方会员ID
 inviteText：邀请内容
 •	返回：
 */
+(NSString *)getSendInviteUrl:(NSString *)memberid toMemberId:(NSString *)tomemberid msgText:(NSString *)msgtext{
    
    NSString *tempmessage = [PCommonUtil encodeUrlParameter:msgtext];
    return [NSString stringWithFormat:@"%@?type=sendInvite&memberID=%@&toMemberID=%@&inviteText=%@", VANKE_DOMAIN, memberid, tomemberid, tempmessage];
}

/*
 获取邀请列表
 •	地址：
 http://www.4000757888.com:880/i.aspx?type=getInviteList&memberID=33&page=1&rows=5
 •	参数：
 memberID：自己会员ID
 page：当前页数
 rows：每页显示记录数
 •	返回：
 */
+(NSString *)getInviteListUrl:(NSString*)memberid :(NSInteger)page :(NSInteger)pageCount
{
    return [NSString stringWithFormat:@"%@?type=getInviteList&memberID=%@&page=%d&rows=%d", VANKE_DOMAIN, memberid, page, pageCount];
}

/*
 加为好友（2013-6-22）
 •	地址：
 http://www.4000757888.com:880/i.aspx?type=addFan&inviteID=5
 •	参数：
 inviteID：邀请ID
 •	返回：
 */
+(NSString *)getAddFanUrl:(NSString*)memberid :(NSString*)toMemberID :(NSString*)inviteId{
    return [NSString stringWithFormat:@"%@?type=addFan&memberID=%@&toMemberID=%@&inviteID=%@",VANKE_DOMAIN,memberid,toMemberID,inviteId];
}

/*
 拒绝邀请（2013-6-22）
 •	地址：
 http://www.4000757888.com:880/i.aspx?type=rejectInvite&inviteID=5
 •	参数：
 inviteID：邀请ID
 •	返回：
 */
+(NSString *)getRejectInviteUrl:(NSString *)inviteid{
    return [NSString stringWithFormat:@"%@?type=rejectInvite&inviteID=%@", VANKE_DOMAIN, inviteid];
}

/*
 发送普通信息（2013-6-22）
 •	地址：
 http://www.4000757888.com:880/i.aspx?type=sendMsg&memberID=33&toMemberID=23&msgText=adfsad
 •	参数：
 memberID：自己会员ID
 toMemberID：对方会员ID
 msgText：信息内容
 •	返回：
 */
+(NSString *)getSendMsgUrl:(NSString *)memberid toMemberId:(NSString *)tomemberid msgText:(NSString *)msgtext{
    
    NSString *tempmessage = [PCommonUtil encodeUrlParameter:msgtext];
    return [NSString stringWithFormat:@"%@?type=sendMsg&memberID=%@&toMemberID=%@&msgText=%@", VANKE_DOMAIN, memberid, tomemberid, tempmessage];
}

/*
 获取所有未读信息的好友列表
 •	地址：
 http://www.4000757888.com:880/i.aspx?type=getUnreadList&memberID=23
 •	参数：
 memberID：会员ID
 •	返回：
 list：所有未读信息的好友列表
 */
+(NSString *)getGetUnreadListUrl:(NSString *)memberid{
    
    return [NSString stringWithFormat:@"%@?type=getUnreadList&memberID=%@", VANKE_DOMAIN, memberid];
}

/*
 获取聊天记录列表（2013-6-22）
 •	地址：
 http://www.4000757888.com:880/i.aspx?type=getMsgList&memberID=23&fromMemberID=33&page=1&rows=5
 •	参数：
 memberID：自己会员ID
 fromMemberID：对方会员ID
 page：当前页数
 rows：每页显示记录数
 •	返回：
 list：聊天记录列表
 */
+(NSString *)getGetMsgListUrl:(NSString *)memberid fromMemberID:(NSString *)fromMemberID lastMsgId:(long)lastmsgid{
    
    return [NSString stringWithFormat:@"%@?type=getMsgList&memberID=%@&fromMemberID=%@&lastMsgID=%ld", VANKE_DOMAIN, memberid, fromMemberID, lastmsgid];
}

/*
 获取好友排名列表
 •	地址：
 http://www.4000757888.com:880/i.aspx?type=getFanRankList&memberID=23&rankType=4
 •	参数：
 memberID：自己会员ID
 rankType：排名类型，总排名=1，年度排名=2，季度排名=3，月排名=4，周排名=5，日排名=6
 •	返回：
 list：好友排名列表
 */
+(NSString *)getGetFanRankListUrl:(NSString *)memberid rankType:(int)ranktype{
    
    return [NSString stringWithFormat:@"%@?type=getFanRankList&memberID=%@&rankType=%d", VANKE_DOMAIN, memberid, ranktype];
}

/*
 获取社区排名列表
 •	地址：
 http://www.4000757888.com:880/i.aspx?type=getCommunityRankList&memberID=23&rankType=4
 •	参数：
 memberID：自己会员ID
 rankType：排名类型，总排名=1，年度排名=2，季度排名=3，月排名=4，周排名=5，日排名=6
 •	返回：
 list：社区排名列表
 */
+(NSString *)getGetCommunityRankListUrl:(NSString *)memberid rankType:(int)ranktype{
    
    return [NSString stringWithFormat:@"%@?type=getCommunityRankList&memberID=%@&rankType=%d", VANKE_DOMAIN, memberid, ranktype];
}

/*
 长轮询通知接口
 •	地址：
 http://www.4000757888.com:880/comet.aspx?type=unread&memberID=23
 •	说明：
 客户端独立线程发送请求，当服务器有新消息提示的时候，将会返回结果，如果没有新消息，则一直挂起，直到有新消息为止。
 客户端接收到返回结果后隔1秒再从新发送请求。
 •	参数：
 memberID：自己会员ID
 •	返回：
 unread：提示消息数目，可以调用“获取所有未读信息数量”接口来获取具体信息
 */
+(NSString *)getUnreadUrl:(NSString *)memberid{
    
    return [NSString stringWithFormat:@"%@?type=unread&memberID=%@", VANKE_DOMAIN, memberid];
}




@end
