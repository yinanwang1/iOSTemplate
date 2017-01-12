//
//  YNWebService.h
//  Pods
//
//  Created by ArthurWang on 16/6/6.
//
//

#import <Foundation/Foundation.h>

#import "YNWebServiceModel.h"

NS_ASSUME_NONNULL_BEGIN
@interface YNBaseWebService : NSObject

- (instancetype)createWebServiceWithUserAgent:(NSString *)userAgentStr
                                     deviceID:(NSString *)deviceIDStr;

- (void)updateRequestSerializerHeadFieldWithDic:(NSDictionary *)dic model:(YNWebServiceModel *)model;

- (NSURLSessionDataTask *)postWithWebServiceModel:(YNWebServiceModel *)model
                                       parameters:(NSDictionary * _Nullable)parameters
                                         progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                                          success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                          failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (NSURLSessionDataTask *)getWithWebServiceModel:(YNWebServiceModel *)model
                                      parameters:(NSDictionary * _Nullable)parameters
                                        progress:(nullable void (^)(NSProgress * _Nonnull))downloadProgress
                                         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                         failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (NSURLSessionDataTask *)uploadWithWebServiceModel:(YNWebServiceModel *)model
                                         parameters:(NSDictionary * _Nullable)parameters
                                      formDataArray:(NSArray *)formDataArray
                                           progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                                            success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                            failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (NSURLSessionDataTask * )putWithWebServiceModel:(YNWebServiceModel *)model
                                       parameters:(NSDictionary * _Nullable)parameters
                                          success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                          failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (NSURLSessionDataTask *)deleteWithWebServiceModel:(YNWebServiceModel *)model
                                         parameters:(NSDictionary * _Nullable)parameters
                                            success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                            failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
NS_ASSUME_NONNULL_END

@end
