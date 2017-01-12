//
//  YNUserAccount.m
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import "YNUserAccount.h"

#import "YNAppDeviceHelper.h"
#import "OpenUDID.h"
#import "NSString+Addition.h"
#import "YNUpdateGeTuiClientID.h"
#import "YNAppConfig.h"
#import "YNUserInfoModel.h"

//NSUserDefaults keys
static NSString * const kToken                        = @"kToken";
static NSString * const kUserPhone                    = @"kUserPhone";
static NSString * const kYNUserInfoModel                = @"kYNUserInfoModel";
static NSString * const kRideOngoing                      = @"kRideOngoing";

NSString * const kLoginCompleteNotification          = @"kLoginCompleteNotification";
NSString * const kLogoutCompleteNotification         = @"kLogoutCompleteNotification";

#define TOKEN_CREATE          @"userapi/token/create"
#define COMMON_SENDCODE       @"userapi/common/appsendcode"
#define URDER_PHONE_LOGIN     @"userapi/user/login"
#define USER_INFO             @"userapi/user/info"
#define USER_LOGOUT           @"userapi/user/logout"

#define SYNC_REQUEST_DEVICE_ID          @"device_id"
#define SYNC_RESPONSE_TOKEN             @"token"

@interface YNUserAccount()<UIAlertViewDelegate>

@end

@implementation YNUserAccount

+ (YNUserAccount *)currentAccount
{
    static YNUserAccount *_currentAccount = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _currentAccount = [[YNUserAccount alloc] init];
        [_currentAccount revertUserInfoModel];
    });
    return _currentAccount;
}

- (BOOL)isLogin
{
    // 只要有uid就算登录
    return  ((0 < [self.userInfoModel.uidStr length])
             && (0 < [self.strToken length]));
}


#pragma mark - 数据请求

- (void)updateToken
{
    NSString *deviceID = [YNAppDeviceHelper uniqueDeviceIdentifier];
    __weak typeof(self) weakSelf = self;
    [YNWebService getRequest:TOKEN_CREATE
                    parameters:@{SYNC_REQUEST_DEVICE_ID:deviceID, @"DO_NOT_NEED_TOKEN":@YES}
                      progress:nil
                       success:^(ErrorCode status, NSString *msg, NSDictionary *data) {
                           weakSelf.strToken = data[SYNC_RESPONSE_TOKEN];
                       } failure:^(ErrorCode status, NSString *msg, NSDictionary *data) {
                           DLog(@"token请求报错 %@ code:%d", msg,(int)status);
                       }];
}

- (void)fetchUserInfoCompleted:(void (^)(ErrorCode status, NSString *message, NSDictionary *dic))block
{
    
    if (nil == [YNUserAccount currentAccount].strToken) {
        if (nil != block) {
            block(kDidNotLoginError, @"token为空", nil);
        }
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    static NSUInteger tryTimes = 3;
    static NSUInteger currentTime = 1;
    
    [YNWebService getRequest:USER_INFO
                   parameters:nil
                     progress:nil
                      success:^(ErrorCode status, NSString *msg, NSDictionary *data) {
                          if (kNoError == status) {
                              YNUserInfoModel *model = [[YNUserInfoModel alloc] initWithDictionary:data error:nil];
                              
                              weakSelf.userInfoModel = model;
                              
                              [weakSelf saveUserInfoModel];
                              
                              [[NSNotificationCenter defaultCenter] postNotificationName:kLoginCompleteNotification object:nil];
                              
                              [[YNUpdateGeTuiClientID currentRequest] startUpdate];
                              
                              currentTime = 0;
                          }
                          
                          if (nil != block) {
                              block(status, msg, data);
                          }
                      } failure:^(ErrorCode status, NSString *msg, NSDictionary *data) {
                          if (kDidNotLoginError != status) {
                              if (currentTime == tryTimes) {
                                  if (nil != block) {
                                      block(status, msg, data);
                                  }
                                  return ;
                              }
                              
                              dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                  [weakSelf fetchUserInfoCompleted:nil];
                                  
                                  currentTime++;
                              });
                          } else {
                              if (nil != block) {
                                  block(status, msg, data);
                              }
                          }
                      }];
}

- (void)logout
{
    self.userInfoModel = nil;
    [self clearUserInfoModel];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kLogoutCompleteNotification object:nil];
    
    [[YNUpdateGeTuiClientID currentRequest] cleanCaches];
}


#pragma mark - Save UserInfoModel in local

- (void)saveUserInfoModel
{
    NSDictionary *userInfoModelDic = [self.userInfoModel toDictionary];
    
    USER_DEFAULTS_SET(userInfoModelDic, kYNUserInfoModel);
}

- (void)revertUserInfoModel
{
    NSDictionary *userInfoModelDic = USER_DEFAULTS_OBJECT_FOR_KEY(kYNUserInfoModel);
    self.userInfoModel = [[YNUserInfoModel alloc] initWithDictionary:userInfoModelDic
                                                                error:nil];
}

- (void)clearUserInfoModel
{
    USER_DEFAULTS_SET(nil, kYNUserInfoModel);
}

#pragma mark - setters & getters

- (NSString *)phone
{
    return USER_DEFAULTS_OBJECT_FOR_KEY(kUserPhone);
}

- (void)setPhone:(NSString *)phone
{
    USER_DEFAULTS_SET(phone, kUserPhone);
}

- (NSString *)strToken
{
    return USER_DEFAULTS_OBJECT_FOR_KEY(kToken);
}

- (void)setStrToken:(NSString *)strToken
{
    USER_DEFAULTS_SET(strToken, kToken);
}

- (BOOL)rideOngoing {
    NSNumber *ongoing = USER_DEFAULTS_OBJECT_FOR_KEY(kRideOngoing);
    return ongoing.boolValue;
}

- (void)setRideOngoing:(BOOL)rideOngoing {
    NSNumber *ongoing = [NSNumber numberWithBool:rideOngoing];
    USER_DEFAULTS_SET(ongoing, kRideOngoing);
}

@end
