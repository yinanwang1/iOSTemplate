//
//  YNWebService.h
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import <Foundation/Foundation.h>


// ASYNC
#define SYNC_DEVICE_ID                   @"device_id"
#define SYNC_USER_ID                     @"uid"
#define SYNC_USER_TOKEN                  @"token"
#define SYNC_SITE_ID                     @"site_id"
#define SYNC_DEVICE_TYPE                 @"device_type"
#define SYNC_DEVICE_TOEKN                @"device_token"
#define SYNC_SYSTEM_VERSION              @"system_version"
#define SYNC_APP_VERSION                 @"app_version"

typedef enum
{
    //未知错误
    kUnknownError = -1,
    
    
    //服务器返回的错误
    kNoError = 0,
    
    kParamsError = 1,
    
    kInvalidTokenError = 2,
    
    kDidNotLoginError = 3,
    
    kNetWorkError = 200,
    
    kNetworkingCancelError = -999,
    
}ErrorCode;

@interface YNWebService : NSObject

+ (NSURLSessionDataTask *)postRequest:(NSString*)path
                           parameters:(id)parameters
                             progress:(void (^)(NSProgress *))uploadProgress
                              success:(void (^)(ErrorCode status, NSString *msg, NSDictionary * data))success
                              failure:(void (^)(ErrorCode status, NSString *msg, NSDictionary * data))failure;

+ (NSURLSessionDataTask *)getRequest:(NSString*)path
                          parameters:(NSDictionary*)parameters
                            progress:(void (^)(NSProgress *))downloadProgress
                             success:(void (^)(ErrorCode status, NSString *msg, NSDictionary * data))success
                             failure:(void (^)(ErrorCode status, NSString *msg, NSDictionary * data))failure;

+ (NSURLSessionDataTask *)uploadRequest:(NSString*)path
                             parameters:(NSDictionary*)parameters
                          formDataArray:(NSArray *)formDataArray
                               progress:(void (^)(NSProgress *))uploadProgress
                                success:(void (^)(ErrorCode status, NSString *msg, NSDictionary * data))success
                                failure:(void (^)(ErrorCode status, NSString *msg, NSDictionary * data))failure;

+ (NSURLSessionDataTask *)putRequest:(NSString*)path
                          parameters:(NSDictionary*)parameters
                             success:(void (^)(ErrorCode status, NSString *msg, NSDictionary * data))success
                             failure:(void (^)(ErrorCode status, NSString *msg, NSDictionary * data))failure;

+ (NSURLSessionDataTask *)deleteRequest:(NSString*)path
                             parameters:(NSDictionary*)parameters
                                success:(void (^)(ErrorCode status, NSString *msg, NSDictionary * data))success
                                failure:(void (^)(ErrorCode status, NSString *msg, NSDictionary * data))failure;

@end
