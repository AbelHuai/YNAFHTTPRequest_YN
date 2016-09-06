//
//  AFHTTPRequest.h
//  YNAFHTTPRequest
//
//  Created by Abel on 16/9/5.
//  Copyright © 2016年 杨南. All rights reserved.
//

#import <Foundation/Foundation.h>

//添加AFNetworking包预编译头
#import <SystemConfiguration/SystemConfiguration.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "AFNetworking.h"


#define HttpRequestTypeGET      @"GET"
#define HttpRequestTypePOST     @"POST"

@interface AFHTTPRequest : NSObject

@property (nonatomic, assign) SEL successSelector;
@property (nonatomic, assign) SEL failureSelector;
@property (nonatomic, assign) NSObject *delegate;
@property (nonatomic, retain) AFHTTPSessionManager *fileManager;

+ (AFHTTPRequest *)sharedInstance;

//上传图片
- (void)AFUploadFile:(NSString *)url andParameters:(NSMutableDictionary *)parameters andData:(NSData *)imageData andUserInfo:(NSMutableDictionary *) userInfo andTimeoutInterval:(NSTimeInterval)timeInterval success:(void (^)(BOOL success, NSString *msg,id responseObject))success failure:(void (^)(NSString *msg))failure;

//上传多张图片
- (void)AFUploadFile:(NSString *)url andParameters:(NSMutableDictionary *)parameters andDatas:(NSArray *)imageDatas andUserInfo:(NSMutableDictionary *) userInfo andTimeoutInterval:(NSTimeInterval)timeInterval success:(void (^)(BOOL success, NSString *msg,id responseObject))success failure:(void (^)(NSString *msg))failure;



#pragma mark HTTP Block

//get
- (void)ASyncGET:(NSString *)url andParameters:(NSMutableDictionary *)parameters andUserInfo:(NSMutableDictionary *)userInfo andTimeOut:(int)seconds success:(void (^)(BOOL success, NSString *msg,id responseObject))success failure:(void (^)(NSString *msg))failure;
//post
- (void)ASyncPOST:(NSString *)url andParameters:(NSMutableDictionary *)parameters andUserInfo:(NSMutableDictionary *)userInfo andTimeOut:(int)seconds success:(void (^)(BOOL success, NSString *msg,id responseObject))success failure:(void (^)(NSString *msg))failure;



@end
