//
//  AFHTTPRequest.m
//  YNAFHTTPRequest
//
//  Created by Abel on 16/9/5.
//  Copyright © 2016年 杨南. All rights reserved.
//

#import "AFHTTPRequest.h"
#import "Url.h"


#define _SHOW_DEBUG_LOG_
#ifdef _SHOW_DEBUG_LOG_
#define DebugLog(...) NSLog(__VA_ARGS__)
#else
#define DebugLog(...)
#endif

@implementation AFHTTPRequest


+ (AFHTTPRequest *)sharedInstance {
    static AFHTTPRequest *_sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        _sharedInstance = [[AFHTTPRequest alloc] init];
    });
    return _sharedInstance;
}

- (void)AFHTTPRequest:(NSString *)url andParameters:(NSMutableDictionary *)parameters andUserInfo:(NSMutableDictionary *)userInfo andHttpRequestType:(NSString *)reqType andIEncrypt:(BOOL)isEncrypt andTimeOut:(int)seconds success:(void (^)(BOOL success, NSString *msg,id responseObject))success failure:(void (^)(NSString *msg))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];//这个是json解析
    manager.requestSerializer.timeoutInterval = seconds;
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    if([reqType isEqualToString:@"GET"]){
        [manager GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *status = [NSString stringWithFormat:@"%@",responseObject[@"status"]];
            NSString *info = [NSString stringWithFormat:@"%@",responseObject[@"info"]];
            if ([status isEqualToString:@"1"]) {
                success(YES,info,responseObject);
            }else{
                success(NO,info,responseObject);
            }
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //可以根据具体的code值区分是什么原因导致失败
             NSString *msg = @"其他原因";
            if(error.code == -1009){
               msg = @"网络原因";
            }
            failure(msg);
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }];
    }else{
        [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *status = [NSString stringWithFormat:@"%@",responseObject[@"status"]];
            NSString *info = [NSString stringWithFormat:@"%@",responseObject[@"info"]];
            if ([status isEqualToString:@"1"]) {
                success(YES,info,responseObject);
            }else{
                success(NO,info,responseObject);
            }
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //可以根据具体的code值区分是什么原因导致失败
            NSString *msg = @"其他原因";
            if(error.code == -1009){
                msg = @"网络原因";
            }
            failure(msg);
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }];
    }
}
//上传图片
- (void)AFUploadFile:(NSString *)url andParameters:(NSMutableDictionary *)parameters andData:(NSData *)imageData andUserInfo:(NSMutableDictionary *) userInfo andTimeoutInterval:(NSTimeInterval)timeInterval success:(void (^)(BOOL success, NSString *msg,id responseObject))success failure:(void (^)(NSString *msg))failure{
    
    if (!self.fileManager) {
        self.fileManager = [AFHTTPSessionManager manager];
    }
    self.fileManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    self.fileManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.fileManager.securityPolicy.allowInvalidCertificates = YES;
    self.fileManager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:imageData name:@"image" fileName:@"header.png" mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSString *status = [NSString stringWithFormat:@"%@",responseObject[@"status"]];
        NSString *info = [NSString stringWithFormat:@"%@",responseObject[@"info"]];
        if ([status isEqualToString:@"1"]) {
            success(YES,info,responseObject);
        }else{
            success(NO,info,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            //可以根据具体的code值区分是什么原因导致失败
            NSString *msg = @"其他原因";
            if(error.code == -1009){
                msg = @"网络原因";
            }
            failure(msg);
        }
    }];
}

//上传多张图片
- (void)AFUploadFile:(NSString *)url andParameters:(NSMutableDictionary *)parameters andDatas:(NSArray *)imageDatas andUserInfo:(NSMutableDictionary *) userInfo andTimeoutInterval:(NSTimeInterval)timeInterval success:(void (^)(BOOL success, NSString *msg,id responseObject))success failure:(void (^)(NSString *msg))failure{
    
    if (!self.fileManager) {
        self.fileManager = [AFHTTPSessionManager manager];
    }
    self.fileManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    self.fileManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.fileManager.securityPolicy.allowInvalidCertificates = YES;
    self.fileManager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSData *jsonBody = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:jsonBody
                                    name:@"param"
                                fileName:@"file"
                                mimeType:@"application/octet-stream"];
        
        [formData appendPartWithFileData:imageDatas[0]
                                    name:@"holding_pic"
                                fileName:@"file"
                                mimeType:@"image/png"];
        
        [formData appendPartWithFileData:imageDatas[1]
                                    name:@"right_side_pic"
                                fileName:@"file"
                                mimeType:@"image/png"];
        
        [formData appendPartWithFileData:imageDatas[2]
                                    name:@"other_side_pic"
                                fileName:@"file"
                                mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSString *status = [NSString stringWithFormat:@"%@",responseObject[@"status"]];
        NSString *info = [NSString stringWithFormat:@"%@",responseObject[@"info"]];
        if ([status isEqualToString:@"1"]) {
            success(YES,info,responseObject);
        }else{
            success(NO,info,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            //可以根据具体的code值区分是什么原因导致失败
            NSString *msg = @"其他原因";
            if(error.code == -1009){
                msg = @"网络原因";
            }
            failure(msg);
        }
    }];
}

#pragma mark HTTP Block

- (void)ASyncGET:(NSString *)url andParameters:(NSMutableDictionary *)parameters andUserInfo:(NSMutableDictionary *)userInfo andTimeOut:(int)seconds success:(void (^)(BOOL success, NSString *msg,id responseObject))success failure:(void (^)(NSString *msg))failure {
    [self AFHTTPRequest:url andParameters:parameters andUserInfo:userInfo andHttpRequestType:HttpRequestTypeGET andIEncrypt:NO andTimeOut:seconds success:(void (^)(BOOL success, NSString *msg,id responseObject))success failure:(void (^)(NSString *msg))failure];
}
- (void)ASyncPOST:(NSString *)url andParameters:(NSMutableDictionary *)parameters andUserInfo:(NSMutableDictionary *)userInfo andTimeOut:(int)seconds success:(void (^)(BOOL success, NSString *msg,id responseObject))success failure:(void (^)(NSString *msg))failure {
    
    [self AFHTTPRequest:url andParameters:parameters andUserInfo:userInfo andHttpRequestType:HttpRequestTypePOST andIEncrypt:NO andTimeOut:seconds success:(void (^)(BOOL success, NSString *msg,id responseObject))success failure:(void (^)(NSString *msg))failure];
    
}





@end
