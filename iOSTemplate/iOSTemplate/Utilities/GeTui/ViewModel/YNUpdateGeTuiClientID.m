//
//  YNUpdateGeTuiClientID.m
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import "YNUpdateGeTuiClientID.h"

#import "YNAppDeviceHelper.h"
#import "YNWebService.h"
#import "YNUserAccount.h"

#define UPDATE_DEVICE_TOKEN         @"device_token"
#define UPDATE_GETUI_PUSH_ID        @"getui_pushid"

#define UPDATE_DEVICE_FINISHED      @"device_update_finished"

// URL
#define DEVICE_UPDATE           @"userappapi/device/update"

static YNUpdateGeTuiClientID * device_update_instance = nil;

@implementation YNUpdateGeTuiClientID

+ (YNUpdateGeTuiClientID *)currentRequest
{
    @synchronized (self)
    {
        if (device_update_instance == nil)
        {
            device_update_instance = [[YNUpdateGeTuiClientID alloc] init];
        }
    }
    
    return device_update_instance;
}

- (id)init
{
    if(self = [super init]) {
        if(![[NSUserDefaults standardUserDefaults] objectForKey:UPDATE_DEVICE_FINISHED]) {
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:UPDATE_DEVICE_FINISHED];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    
    return self;
}

- (void)setDeviceToken:(NSString *)deviceToken
{
    //先保存在本地，获取所有信息后调用startUpdate
    NSString *currentToken = [[NSUserDefaults standardUserDefaults] objectForKey:UPDATE_DEVICE_TOKEN];
    BOOL updateFinish = [[NSUserDefaults standardUserDefaults] boolForKey:UPDATE_DEVICE_FINISHED];
    
    [[NSUserDefaults standardUserDefaults] setObject:deviceToken forKey:UPDATE_DEVICE_TOKEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if(currentToken == nil || ![currentToken isEqualToString:deviceToken] || !updateFinish) {
        [self startUpdate];
    }
}

- (void)setGetuiPushId:(NSString *)getuiPushId
{
    //先保存在本地，获取所有信息后调用startUpdate
    NSString *currentPushId = [[NSUserDefaults standardUserDefaults] objectForKey:UPDATE_GETUI_PUSH_ID];
    BOOL updateFinish = [[NSUserDefaults standardUserDefaults] boolForKey:UPDATE_DEVICE_FINISHED];
    
    [[NSUserDefaults standardUserDefaults] setObject:getuiPushId forKey:UPDATE_GETUI_PUSH_ID];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if(currentPushId == nil || ![currentPushId isEqualToString:getuiPushId] || !updateFinish) {
        [self startUpdate];
    }
}

- (void)startUpdate
{
    //有可能调用多次
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:UPDATE_DEVICE_FINISHED];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(doStartUpdate) object:nil];
    
    [self performSelector:@selector(doStartUpdate) withObject:nil afterDelay:2.0];
}

- (void)doStartUpdate
{
    NSString * deviceId = [YNAppDeviceHelper uniqueDeviceIdentifier];
    NSString * deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:UPDATE_DEVICE_TOKEN];
    NSString * getuiPushId = [[NSUserDefaults standardUserDefaults] objectForKey:UPDATE_GETUI_PUSH_ID];
    if (deviceId == nil || ![YNUserAccount currentAccount].strToken)
    {
        return;
    }
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:deviceId forKey:SYNC_DEVICE_ID];
    if (deviceToken != nil)
        [dic setObject:deviceToken forKey:SYNC_DEVICE_TOEKN];
    if (getuiPushId != nil)
        [dic setObject:getuiPushId forKey:@"getui_client_id"];
    [dic setObject:[NSNumber numberWithFloat:[YNAppDeviceHelper iosVersion]] forKey:SYNC_SYSTEM_VERSION];
    [dic setObject:[YNUserAccount currentAccount].strToken forKey:@"token"];
    
    [YNWebService postRequest:DEVICE_UPDATE
                    parameters:dic
                      progress:nil
                       success:^(ErrorCode status, NSString *msg, NSDictionary *data) {
                           if(status == kNoError) {
                               [[NSUserDefaults standardUserDefaults] setBool:YES forKey:UPDATE_DEVICE_FINISHED];
                               [[NSUserDefaults standardUserDefaults] synchronize];
                           }
                       } failure:^(ErrorCode status, NSString *msg, NSDictionary * data) {
                           // Do nothing
                       }];
}

- (void)cleanCaches
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UPDATE_DEVICE_FINISHED];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
