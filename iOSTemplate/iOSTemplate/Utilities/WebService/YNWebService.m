//
//  YNWebService.m
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import "YNWebService.h"

#import "YNBaseWebService.h"

// Pod Module
#import "YNAppDeviceHelper.h"
#import "YNAppConfig.h"
#import "NSString+Addition.h"

// Third Framework
#import <AlicloudHttpDNS/AlicloudHttpDNS.h>


// sync response
#define SYNC_RESPONSE_MSG               @"msg"
#define SYNC_RESPONSE_STATUS            @"status"
#define SYNC_RESPONSE_DATA              @"data"


#define kSecret   @""

@implementation YNWebService

#pragma mark - Initial Methods

+ (YNBaseWebService *)webService
{
    static YNBaseWebService *webService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *userAgent = [NSString stringWithFormat:@"%@/%@; iOS %@; %.0fX%.0f/%0.1f", [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleNameKey] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleIdentifierKey], [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleVersionKey], [[UIDevice currentDevice] systemVersion], SCREEN_WIDTH*[[UIScreen mainScreen] scale],SCREEN_HEIGHT*[[UIScreen mainScreen] scale], [[UIScreen mainScreen] scale]];
        if (userAgent) {
            if (![userAgent canBeConvertedToEncoding:NSASCIIStringEncoding]) {
                NSMutableString *mutableUserAgent = [userAgent mutableCopy];
                if (CFStringTransform((__bridge CFMutableStringRef)(mutableUserAgent), NULL, (__bridge CFStringRef)@"Any-Latin; Latin-ASCII; [:^ASCII:] Remove", false)) {
                    userAgent = mutableUserAgent;
                }
            }
        }
        
        UIWebView *tempWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
        NSString *originalUserAgent = [tempWebView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
        NSString *userAgentStr = [NSString stringWithFormat:@"%@\\%@; %@; %@", originalUserAgent, [YNAppDeviceHelper modelString], userAgent,[NSString stringWithFormat:@"IsJailbroken/%d",[YNAppDeviceHelper isJailbroken]]];
        NSString *deviceIDStr = [YNAppDeviceHelper uniqueDeviceIdentifier];
        
        webService = [[YNBaseWebService alloc] createWebServiceWithUserAgent:userAgentStr
                                                                deviceID:deviceIDStr];
    });
    
    return webService;
}


#pragma mark - Core

+ (void)handleSuccess:(BOOL)isPost
                 path:(NSString*)path
           parameters:(NSDictionary*)parameters
            operation:(NSURLSessionDataTask *)op
                 json:(id)json
              success:(void (^)(ErrorCode status, NSString * msg, NSDictionary * data))success
              failure:(void (^)(ErrorCode status, NSString *msg, NSDictionary * data))failure
{
    DLog(@"%@ handleSuccess", path);
    
    [YNWebService onResponseData:json
                              success:success
                              failure:failure];
    
}

+ (void)handleFailure:(BOOL)isPost
                 path:(NSString*)path
           parameters:(NSDictionary*)parameters
            operation:(NSURLSessionDataTask *)op
                error:(NSError*)error
              success:(void (^)(ErrorCode status, NSString * msg, NSDictionary * data))success
              failure:(void (^)(ErrorCode status, NSString *msg, NSDictionary * data))failure
{
    if([error.domain isEqualToString:@"NSURLErrorDomain"]
       && error.code == kNetworkingCancelError)
    {//增加上传取消操作后的error code 判断
        failure(kNetworkingCancelError, @"网络请求取消", nil);
        return;
    }
    failure(kNetWorkError, @"网络错误", nil);
}


#pragma mark - Public Methods

#pragma mark - POST

+ (NSURLSessionDataTask *)postRequest:(NSString*)path
                           parameters:(id)parameters
                             progress:(void (^)(NSProgress * _Nonnull))uploadProgress
                              success:(void (^)(ErrorCode status, NSString * msg, NSDictionary * data))success
                              failure:(void (^)(ErrorCode status, NSString *msg, NSDictionary * data))failure

{
    DLog(@"Request Start %@", [NSDate date]);
    DLog(@"Request %@", path);
    DLog(@"Params %@", parameters);
    
    YNWebServiceModel *model = [YNWebService createWebServiceModelWithPath:path];
    parameters = [YNWebService signDictionary:parameters];
    
    NSURLSessionDataTask *task = [[YNWebService webService]
                                  postWithWebServiceModel:model
                                  parameters:parameters
                                  progress:uploadProgress
                                  success:^(NSURLSessionDataTask *task, id responseObject) {
                                      [YNWebService handleSuccess:YES
                                                                  path:path
                                                            parameters:parameters
                                                             operation:task
                                                                  json:responseObject
                                                               success:success
                                                               failure:failure];
                                  } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                      DLog(@"Request End Faile %@", [NSDate date]);
                                      [YNWebService handleFailure:YES
                                                                  path:path
                                                            parameters:parameters
                                                             operation:task
                                                                 error:error
                                                               success:success
                                                               failure:failure];
                                  }];
    
    
    return task;
}


#pragma mark - GET

+ (NSURLSessionDataTask *)getRequest:(NSString*)path
                          parameters:(NSDictionary*)parameters
                            progress:(void (^)(NSProgress * _Nonnull))downloadProgress
                             success:(void (^)(ErrorCode status, NSString * msg, NSDictionary * data))success
                             failure:(void (^)(ErrorCode status, NSString *msg, NSDictionary * data))failure
{
    DLog(@"Request Start %@", [NSDate date]);
    DLog(@"Request %@", path);
    DLog(@"Params %@", parameters);
    
    YNWebServiceModel *model = [YNWebService createWebServiceModelWithPath:path];
    
    parameters = [YNWebService signDictionary:parameters];
    
    NSURLSessionDataTask *task = [[YNWebService webService]
                                  getWithWebServiceModel:model
                                  parameters:parameters
                                  progress:downloadProgress
                                  success:^(NSURLSessionDataTask *task, id responseObject) {
                                      [YNWebService handleSuccess:NO
                                                                  path:path
                                                            parameters:parameters
                                                             operation:task
                                                                  json:responseObject
                                                               success:success
                                                               failure:failure];
                                  } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                      DLog(@"Request End Faile %@", [NSDate date]);
                                      
                                      [YNWebService handleFailure:NO
                                                                  path:path
                                                            parameters:parameters
                                                             operation:task
                                                                 error:error
                                                               success:success
                                                               failure:failure];
                                  }];
    
    return task;
}


#pragma mark - UPLOAD

+ (NSURLSessionDataTask *)uploadRequest:(NSString*)path
                             parameters:(NSDictionary*)parameters
                          formDataArray:(NSArray *)formDataArray
                               progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                                success:(void (^)(ErrorCode status, NSString *msg, NSDictionary *data))success
                                failure:(void (^)(ErrorCode status, NSString *msg, NSDictionary *data))failure
{
    DLog(@"Request Start %@", [NSDate date]);
    DLog(@"Request %@", path);
    DLog(@"Params %@", parameters);
    
    YNWebServiceModel *model = [YNWebService createWebServiceModelWithPath:path];
    
    parameters = nil; // Don't send paramenter, If send parameters, the server returns error
    
    NSURLSessionDataTask *task = [[YNWebService webService]
                                  uploadWithWebServiceModel:model
                                  parameters:parameters
                                  formDataArray:formDataArray
                                  progress:uploadProgress
                                  success:^(NSURLSessionDataTask *task, id responseObject) {
                                      DLog(@"Request End Success %@", [NSDate date]);
                                      
                                      [YNWebService handleSuccess:YES
                                                                  path:path
                                                            parameters:parameters
                                                             operation:task
                                                                  json:responseObject
                                                               success:success
                                                               failure:failure];
                                  } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                      DLog(@"Request End Faile %@", [NSDate date]);
                                      [YNWebService handleFailure:YES
                                                                  path:path
                                                            parameters:parameters
                                                             operation:task
                                                                 error:error
                                                               success:success
                                                               failure:failure];
                                  }];
    
    
    
    
    return task;
}



#pragma mark - PUT

+ (NSURLSessionDataTask *)putRequest:(NSString*)path
                          parameters:(NSDictionary*)parameters
                             success:(void (^)(ErrorCode status, NSString * msg, NSDictionary * data))success
                             failure:(void (^)(ErrorCode status, NSString *msg, NSDictionary * data))failure
{
    DLog(@"Request Start %@", [NSDate date]);
    DLog(@"Request %@", path);
    DLog(@"Params %@", parameters);
    
    YNWebServiceModel *model = [YNWebService createWebServiceModelWithPath:path];
    
    parameters = [YNWebService signDictionary:parameters];
    
    NSURLSessionDataTask *task = [[YNWebService webService]
                                  putWithWebServiceModel:model
                                  parameters:parameters
                                  success:^(NSURLSessionDataTask *task, id responseObject) {
                                      [YNWebService handleSuccess:YES
                                                                  path:path
                                                            parameters:parameters
                                                             operation:task
                                                                  json:responseObject
                                                               success:success
                                                               failure:failure];
                                  } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                      DLog(@"Request End Faile %@", [NSDate date]);
                                      [YNWebService handleFailure:YES
                                                                  path:path
                                                            parameters:parameters
                                                             operation:task
                                                                 error:error
                                                               success:success
                                                               failure:failure];
                                  }];
    
    
    return task;
}


#pragma mark - DELETE

+ (NSURLSessionDataTask *)deleteRequest:(NSString*)path
                             parameters:(NSDictionary*)parameters
                                success:(void (^)(ErrorCode status, NSString * msg, NSDictionary * data))success
                                failure:(void (^)(ErrorCode status, NSString *msg, NSDictionary * data))failure
{
    DLog(@"Request Start %@", [NSDate date]);
    DLog(@"Request %@", path);
    DLog(@"Params %@", parameters);
    
    YNWebServiceModel *model = [YNWebService createWebServiceModelWithPath:path];
    
    parameters = [YNWebService signDictionary:parameters];
    
    NSURLSessionDataTask *task = [[YNWebService webService]
                                  deleteWithWebServiceModel:model
                                  parameters:parameters
                                  success:^(NSURLSessionDataTask *task, id responseObject) {
                                      [YNWebService handleSuccess:YES
                                                                  path:path
                                                            parameters:parameters
                                                             operation:task
                                                                  json:responseObject
                                                               success:success
                                                               failure:failure];
                                  } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                      DLog(@"Request End Faile %@", [NSDate date]);
                                      [YNWebService handleFailure:YES
                                                                  path:path
                                                            parameters:parameters
                                                             operation:task
                                                                 error:error
                                                               success:success
                                                               failure:failure];
                                  }];
    
    return task;
}


#pragma mark - Private Methods

+ (NSDictionary *)signDictionary:(NSDictionary *)dic
{
    if ((nil == dic)
        || [dic isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *dicReal = [NSMutableDictionary dictionaryWithDictionary:dic];
        if (dicReal == nil) {
            dicReal = [NSMutableDictionary dictionary];
        }
        
        //addtime
        NSString * timeStr = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
        [dicReal addEntriesFromDictionary:@{@"time":timeStr,
                                            SYNC_DEVICE_TYPE:@0,   //ios 0
                                            SYNC_APP_VERSION:[YNAppConfig sharedInstance].appVersion,
                                            @"protocol_version":@"2.0.0",
                                            SYNC_DEVICE_ID:[YNAppDeviceHelper uniqueDeviceIdentifier],
                                            }];
        
        if ([dic objectForKey:SYNC_USER_TOKEN] == nil) {
            NSString *tokenStr = [[YNUserAccount currentAccount] strToken];
            if (nil != tokenStr) {
                [dicReal setObject:tokenStr forKey:SYNC_USER_TOKEN];
            }
        }
        
        NSString * md5String = [YNWebService calcSignStringWithArr:dicReal];
        [dicReal addEntriesFromDictionary:@{@"sign":md5String}];
        
        return dicReal;
    } else {
        return [NSDictionary dictionary];
    }
}

+ (NSString *)calcSignStringWithArr:(NSDictionary *)dicReal
{
    NSMutableString *start = [[NSMutableString alloc] init];
    NSArray *keys = [dicReal allKeys];
    
    //keys按字母顺序排序
    keys = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
            {
                NSString * str1 = (NSString *)obj1;
                NSString * str2 = (NSString *)obj2;
                return [str1 compare:str2];
            }];
    for (NSString *key in keys) {
        [start appendFormat:@"%@=%@&", key, [dicReal objectForKey:key]];
    }
    
    [start appendFormat:@"%@", kSecret];
    
    NSString * md5String = [NSString md5: start];
    
    return md5String;
}

+ (void)onResponseData:(id)responseObject
               success:(void (^)(ErrorCode status, NSString * msg, NSDictionary * data))success
               failure:(void (^)(ErrorCode status, NSString *msg, NSDictionary * data))failure
{
    id json = responseObject;
    
    if(json && [json isKindOfClass:[NSDictionary class]]) {
        if(DIC_HAS_NUMBER(json, SYNC_RESPONSE_STATUS)) {
            id message = [json objectForKey:SYNC_RESPONSE_MSG];
            NSString * msg = [message isKindOfClass:[NSString class]] ? message : @"";
            int status = [[json objectForKey:SYNC_RESPONSE_STATUS] intValue];
            NSDictionary * data = [json objectForKey:SYNC_RESPONSE_DATA];
            
            if (status == kNoError) {
                if(!data || ![data isKindOfClass:[NSDictionary class]]) {
                    data = [NSDictionary dictionary];
                }
                success(status, msg, data);
                
            }else if (status == kNoError) {
                failure(status, msg, data);
            }else if(status == kInvalidTokenError) {
                failure(status, msg, data);
            }else if(msg != nil) {
                failure(status, msg, data);
            }else {
                failure(kUnknownError, @"未知错误-1000", data);
            }
        }else {
            failure(kUnknownError, @"未知错误-1001", nil);
        }
    }else {
        failure(kUnknownError, @"未知错误-1002", nil);
    }
}

+ (NSString *)webServiceCurrentDateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDate *now = [[NSDate alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    return [dateFormatter stringFromDate:now];
}

+ (YNWebServiceModel *)createWebServiceModelWithPath:(NSString *)pathStr
{
    // base url
    NSString *baseURLStr = [[ApplicationSettings instance] currentServiceURL];
    
    // ip address
    NSString *ipAddressStr = nil;
    if (EnvironmentProduct == [[ApplicationSettings instance] currentEnvironmentType]) {
        ipAddressStr = [YNWebService fetchIPByURLStr:baseURLStr];
    }
    
    // web service model
    YNWebServiceModel *model = [[YNWebServiceModel alloc] init];
    model.baseURLStr = baseURLStr;
    model.ipAddressStr = ipAddressStr;
    model.pathStr = pathStr;
    
    return model;
}

+ (NSString *)fetchIPByURLStr:(NSString *)urlStr
{
    NSURL *url = [NSURL URLWithString:urlStr];
    
    HttpDnsService *httpdns = [HttpDnsService sharedInstance];
    
    NSString *ipStr = [httpdns getIpByHostAsyncInURLFormat:url.host];
    
    return ipStr;
}

@end
