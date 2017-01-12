//
//  YNGeTuiSdkManager.m
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import "YNGeTuiSdkManager.h"

#import "AppDelegate.h"

//个推
#define kGexinAppId           @""
#define kGexinAppKey          @""
#define kGexinAppSecret       @""

static YNGeTuiSdkManager *geTuiManagerSharedInstance = nil;

@interface YNGeTuiSdkManager ()

@property (copy, nonatomic) NSString *appKey;
@property (copy, nonatomic) NSString *appSecret;
@property (copy, nonatomic) NSString *appID;
@property (copy, nonatomic) NSString *clientId;
@property (assign, nonatomic) SdkStatus sdkStatus;

@property (assign, nonatomic) int lastPayloadIndex;



- (BOOL)setTags:(NSArray *)aTag error:(NSError **)error;
- (NSString *)sendMessage:(NSData *)body error:(NSError **)error;

@end


@implementation YNGeTuiSdkManager

+ (YNGeTuiSdkManager *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        geTuiManagerSharedInstance = [[self alloc]init];
    });
    return geTuiManagerSharedInstance;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)startSdk
{
    [self startSdkWith:kGexinAppId appKey:kGexinAppKey appSecret:kGexinAppSecret];
    
    [self registerRemoteNotification];
}

- (void)registerRemoteNotification
{
    UIUserNotificationSettings *uns = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound) categories:nil];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    [[UIApplication sharedApplication] registerUserNotificationSettings:uns];
}

- (void)startSdkWith:(NSString *)appID appKey:(NSString *)appKey appSecret:(NSString *)appSecret
{
    self.appID = appID;
    self.appKey = appKey;
    self.appSecret = appSecret;
    
    self.clientId = nil;
    
    [GeTuiSdk startSdkWithAppId:self.appID
                         appKey:self.appKey
                      appSecret:self.appSecret
                       delegate:self];
}

- (void)stopSdk
{
    self.clientId = nil;
    
    [GeTuiSdk destroy];
}

- (BOOL)checkSdkInstance
{
    if (SdkStatusStarted != self.sdkStatus) {
        DLog(@"GexinSDK未启动");
        return NO;
    }
    return YES;
}

- (void)setDeviceToken:(NSString *)aToken data:(NSData *)deviceData
{
    if (![self checkSdkInstance]) {
        return;
    }
    
    [GeTuiSdk registerDeviceToken:aToken];
}

- (BOOL)setTags:(NSArray *)aTags error:(NSError **)error
{
    if (![self checkSdkInstance]) {
        return NO;
    }
    
    return [GeTuiSdk setTags:aTags];
}

- (NSString *)sendMessage:(NSData *)body error:(NSError **)error {
    if (![self checkSdkInstance]) {
        return nil;
    }
    
    return [GeTuiSdk sendMessage:body error:error];
}
- (void)setAlias:(NSString *)alias {
    
}

- (void)cancelALias {
    
}

- (void)networkDidReceiveMessage:(NSNotification *)notification
{
    //    NSDictionary *resultDic =[notification object];
    //    NSString *tempStr = [NSString stringWithFormat:@"title:%@\ncontent:%@",[resultDic objectForKey:@"title"],[resultDic objectForKey:@"details"]];
    //    DLog(@"%@",tempStr);
}

#pragma mark - GexinSdkDelegate

- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId
{
    // [4-EXT-1]: 个推SDK已注册
    self.sdkStatus = SdkStatusStarted;
    
    self.clientId = clientId;
    
    [[YNUpdateGeTuiClientID currentRequest] setGetuiPushId:clientId];
}

- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId
{
    NSString *payload = [[NSString alloc] initWithData:payloadData encoding:NSUTF8StringEncoding];
    
    DLog(@"%d, %@, %@", ++_lastPayloadIndex, [NSDate date], payload);
    
    [[AppDelegate sharedDelegate] showPayload:payload];
}

- (void)GeTuiSdkDidSendMessage:(NSString *)messageId result:(int)result;
{
    // [4-EXT]:发送上行消息结果反馈
    DLog(@"Received sendmessage:%@ result:%d", messageId, result);
}

- (void)GeTuiSdkDidOccurError:(NSError *)error;
{
    // [EXT]:个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
    DLog(@">>>[GexinSdk error]:%@", [error localizedDescription]);
}

- (void)GeTuiSDkDidNotifySdkState:(SdkStatus)aStatus
{
    self.sdkStatus = aStatus;
}

@end
