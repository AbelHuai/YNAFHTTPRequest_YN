//
//  Url.h
//  YNAFHTTPRequest
//
//  Created by Abel on 16/9/5.
//  Copyright © 2016年 杨南. All rights reserved.
//

#ifndef YNAFHTTPRequest_Url_h
#define YNAFHTTPRequest_Url_h

/*接口服务器地址*/
#ifdef DEBUG
#define kAppServerURL @"https://www.baidu.com"
#else
#define kAppServerURL @"https://www.baidu.com"
#endif

/*图片基础地址*/
#ifdef DEBUG
#define kImageBaseURL @"https://www.baidu.com"
#else
#define kImageBaseURL @"https://www.baidu.com"
#endif

//登录
#define kLOGIN_URL  [NSString stringWithFormat:@"%@/member/login", kAppServerURL]

#endif


