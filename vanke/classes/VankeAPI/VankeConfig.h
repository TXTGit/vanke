//
//  VankeConfig.h
//  vanke
//
//  Created by pig on 13-6-11.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#ifndef vanke_VankeConfig_h
#define vanke_VankeConfig_h

/*
 * 用于切换不同域名地址
 */
#define IS_DEBUG_SERVER 1

#if (0 == IS_DEBUG_SERVER)

#define VANKE_DOMAIN                        @"http://ciriis2013b.cn22.zridc.net/i.aspx"

#elif (1 == IS_DEBUG_SERVER)

//#define VANKE_DOMAIN                        @"http://www.4000757888.com:880/i.aspx"
#define VANKE_DOMAIN                        @"http://api.4000757888.com/i.aspx"

#endif

//若返回：{result=”-1”,msg=”服务器异常的提示信息”}，则表示服务器异常
#define VANKE_ERROR_CODE_SERVER             @"服务器异常的提示信息"
//若返回：{result=”1”,msg=”操作不成功的提示信息”}，表示操作不成功；
#define VANKE_ERROR_CODE_FAILED             @"操作不成功的提示信息"
//若返回：{result=”0”,msg=”操作成功的提示信息”,……}，表示操作成功；
#define VANKE_ERROR_CODE_SUCCESS            @"操作成功的提示信息"

#endif
