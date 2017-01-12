//
//  YNGeTuiSdkManager.h
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GeTuiSdk.h"
#import "YNUpdateGeTuiClientID.h"

@interface YNGeTuiSdkManager : NSObject <GeTuiSdkDelegate>

+ (YNGeTuiSdkManager *)sharedInstance;

- (void)startSdk;

- (void)stopSdk;

- (void)setDeviceToken:(NSString *)aToken data:(NSData *)deviceData;

- (void)setAlias:(NSString *)alias;

@end
