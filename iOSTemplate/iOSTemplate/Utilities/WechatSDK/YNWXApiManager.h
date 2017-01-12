//
//  YNWXApiManager.h
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WXApi.h"
#import "YNMacrosEnum.h"
#import "YNOrderActivityInfo.h"

typedef void (^YNShareCallbackBlock)(YNShareResult shareResult, NSString * msg);

typedef enum : NSInteger {
    YNWechatPayStatusSuccess = 0,
    YNWechatPayStatusFailed  = -1,
    YNWechatPayStatusExit    = -2,
    
    YNWechatPayStatusParamError = 100,
} YNWechatPayStatus;

@protocol YNWechatPayDelegate <NSObject>

@required
- (void)wechatPayCallBack:(YNWechatPayStatus)status message:(NSString *)message result:(NSDictionary *)result;

@end

@interface YNWXApiManager : NSObject<WXApiDelegate>

@property (copy, nonatomic) NSString *userID;
@property (copy, nonatomic) NSString *accessToken;
@property (copy, nonatomic) NSDate   *expirationDate;
@property (copy, nonatomic) NSString *refresh_token;

@property (nonatomic, weak) id<YNWechatPayDelegate> wechatPayDelegate;
@property (nonatomic, copy) YNShareCallbackBlock shareCallBack;

+ (YNWXApiManager *) sharedManager;

- (BOOL)handleOpenURL:(NSURL *)url;

- (BOOL)isWechatInstalled;

- (void)shareAppToWeixinFriends:(BOOL)isTimeLine callback:(YNShareCallbackBlock)callback;
- (void)shareToWeixinWithTitle:(NSString *)title text:(NSString *)text image:(UIImage *)image url:(NSString *)url timeLine:(BOOL)isTimeLine  callback:(YNShareCallbackBlock)callback;

// box
- (void)shareAppToWeixinFriends:(BOOL)isTimeLine
               withActivityInfo:(YNOrderActivityInfo *)shareInfoEntity
                          image:(UIImage *)image
                       callback:(YNShareCallbackBlock)callback;
- (void)shareAppToWeixin:(BOOL)isTimeLine
        withActivityInfo:(YNOrderActivityInfo *)shareInfo
                   image:(UIImage *)image
                callback:(YNShareCallbackBlock)callback;

// pay
- (void)wechatPay:(NSDictionary *)orderInfoDic delegate:(id)delegate;

@end
