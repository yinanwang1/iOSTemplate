//
//  YNWebService.m
//  Pods
//
//  Created by ArthurWang on 16/6/6.
//
//

#import "YNBaseWebService.h"

#import "AFNetworking.h"


#define DEFAULT_BASE_URL @"base_url"

@interface YNBaseWebService ()

/** key is urlString, value is AFHTTPSessionManager */
@property (nonatomic, strong) NSMutableDictionary *sessionManagerMDic;

@property (nonatomic, strong) NSString *userAgentStr;
@property (nonatomic, strong) NSString *deviceIDStr;

@end

@implementation YNBaseWebService

#pragma mark - Initial Methods

- (instancetype)createWebServiceWithUserAgent:(NSString *)userAgentStr
                                     deviceID:(NSString *)deviceIDStr
{
    YNBaseWebService *webService = [[YNBaseWebService alloc] init];
    
    webService.userAgentStr = userAgentStr;
    webService.deviceIDStr  = deviceIDStr;
    
    return webService;
}

- (AFHTTPSessionManager *)createSessionManagerWithModel:(YNWebServiceModel *)model
{
    // If has saved the sessin manager by ip address, return the value
    AFHTTPSessionManager *sessionManager = [self.sessionManagerMDic objectForKey:model.ipAddressStr];
    
    if (nil != sessionManager) {
        return sessionManager;
    }
    
    // When ip address is null, so the session manager was only saved by base url
    // If has saved the sessin manager by ip address, return the value
    if (0 >= [model.ipAddressStr length]) {
        sessionManager = [self.sessionManagerMDic objectForKey:model.baseURLStr];
        
        if (nil != sessionManager) {
            return sessionManager;
        }
    }
    
    NSString *urlString = nil;
    
    if (0 < [model.ipAddressStr length]) {
        NSURL *url = [NSURL URLWithString:model.baseURLStr];
        NSRange hostFirstRange = [model.baseURLStr rangeOfString:url.host];
        if (NSNotFound != hostFirstRange.location) {
            urlString = [model.baseURLStr stringByReplacingCharactersInRange:hostFirstRange
                                                                  withString:model.ipAddressStr];
        } else {
           urlString = model.baseURLStr;
        }
        
    } else if (0 < [model.baseURLStr length]) {
        urlString = model.baseURLStr;
    } else {
        urlString = DEFAULT_BASE_URL;
        
        // If has saved the sessin manager by DEFAULT_BASE_URL, return the value
        sessionManager = [self.sessionManagerMDic objectForKey:DEFAULT_BASE_URL];
        
        if (nil != sessionManager) {
            return sessionManager;
        }
    }
    
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    //设置我们的缓存大小 其中内存缓存大小设置10M  磁盘缓存5M
    NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:10 * 1024 * 1024
                                                      diskCapacity:50 * 1024 * 1024
                                                          diskPath:nil];
    
    [config setURLCache:cache];
    
    AFHTTPSessionManager *sharedClient = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:urlString]
                                             sessionConfiguration:config];
    
    // response
    AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
    response.removesKeysWithNullValues = YES;
    NSMutableSet *acceptContentTypes = [NSMutableSet setWithSet:response.acceptableContentTypes];
    [acceptContentTypes addObject:@"text/plain"];
    response.acceptableContentTypes = acceptContentTypes;
    sharedClient.responseSerializer = response;
    
    // request
    sharedClient.requestSerializer = [AFHTTPRequestSerializer serializer];
    [sharedClient.requestSerializer setValue:self.userAgentStr forHTTPHeaderField:@"User-Agent"];
    [sharedClient.requestSerializer setValue:self.deviceIDStr forHTTPHeaderField:@"device_id"];
    NSURL *url = [NSURL URLWithString:model.baseURLStr];
    if (0 < [url.host length]) {
        [sharedClient.requestSerializer setValue:url.host forHTTPHeaderField:@"host"];
    }
    
    sharedClient.securityPolicy.allowInvalidCertificates = YES;
    
    // set key & value
    [self.sessionManagerMDic setObject:sharedClient forKey:urlString];
    
    return sharedClient;
    
}


#pragma mark - Public Methods

- (void)updateRequestSerializerHeadFieldWithDic:(NSDictionary *)dic model:(YNWebServiceModel *)model
{
    AFHTTPSessionManager *manager = [self createSessionManagerWithModel:model];
    
    for (NSString *key in [dic allKeys]) {
        [manager.requestSerializer setValue:[dic objectForKey:key]
                         forHTTPHeaderField:key];
    }
}

#pragma mark - POST

- (NSURLSessionDataTask *)postWithWebServiceModel:(YNWebServiceModel *)model
                                       parameters:(NSDictionary * _Nullable)parameters
                                         progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                                          success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                          failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    AFHTTPSessionManager *manager = [self createSessionManagerWithModel:model];
    
    if (nil == parameters) {
        parameters = [[NSDictionary alloc] init];
    }
    
    NSURLSessionDataTask *task = [manager POST:model.pathStr
                                    parameters:parameters
                                      progress:uploadProgress
                                       success:success
                                       failure:failure];
    
    return task;
}


#pragma mark - GET

- (NSURLSessionDataTask *)getWithWebServiceModel:(YNWebServiceModel *)model
                                      parameters:(NSDictionary * _Nullable)parameters
                                        progress:(nullable void (^)(NSProgress * _Nonnull))downloadProgress
                                         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                         failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    AFHTTPSessionManager *manager = [self createSessionManagerWithModel:model];
    
    if (nil == parameters) {
        parameters = [[NSDictionary alloc] init];
    }
    
    NSURLSessionDataTask *task = [manager GET:model.pathStr
                                   parameters:parameters
                                     progress:downloadProgress
                                      success:success
                                      failure:failure];
    
    return task;
}


#pragma mark - UPLOAD

- (NSURLSessionDataTask *)uploadWithWebServiceModel:(YNWebServiceModel *)model
                                         parameters:(NSDictionary * _Nullable)parameters
                                      formDataArray:(NSArray *)formDataArray
                                           progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                                            success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                            failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    AFHTTPSessionManager *manager = [self createSessionManagerWithModel:model];
    
    if (nil == parameters) {
        parameters = [[NSDictionary alloc] init];
    }
    
    NSURLSessionDataTask *task = [manager POST:model.pathStr
                                    parameters:parameters
                     constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                         
                         [formData appendPartWithFileData:[formDataArray objectAtIndex:0]
                                                     name:[formDataArray objectAtIndex:1]
                                                 fileName:[formDataArray objectAtIndex:2]
                                                 mimeType:[formDataArray objectAtIndex:3]];
                     }
                                      progress:uploadProgress
                                       success:success
                                       failure:failure];
    
    return task;
}


#pragma mark - PUT

- (NSURLSessionDataTask * )putWithWebServiceModel:(YNWebServiceModel *)model
                                       parameters:(NSDictionary * _Nullable)parameters
                                          success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                          failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    AFHTTPSessionManager *manager = [self createSessionManagerWithModel:model];
    
    if (nil == parameters) {
        parameters = [[NSDictionary alloc] init];
    }
    
    NSURLSessionDataTask *task = [manager PUT:model.pathStr
                                   parameters:parameters
                                      success:success
                                      failure:failure];
    
    return task;
    
}


#pragma mark - DELETE

- (NSURLSessionDataTask *)deleteWithWebServiceModel:(YNWebServiceModel *)model
                                         parameters:(NSDictionary * _Nullable)parameters
                                            success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                            failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    AFHTTPSessionManager *manager = [self createSessionManagerWithModel:model];
    
    if (nil == parameters) {
        parameters = [[NSDictionary alloc] init];
    }
    
    NSURLSessionDataTask *task = [manager DELETE:model.pathStr
                                      parameters:parameters
                                         success:success
                                         failure:failure];
    
    return task;
    
}


#pragma mark - Setter Getter Methods

- (NSMutableDictionary *)sessionManagerMDic
{
    if (nil == _sessionManagerMDic) {
        _sessionManagerMDic = [[NSMutableDictionary alloc] initWithCapacity:5];
    }
    
    return _sessionManagerMDic;
}



@end
