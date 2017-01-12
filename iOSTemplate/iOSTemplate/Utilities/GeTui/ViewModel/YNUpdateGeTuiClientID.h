//
//  YNUpdateGeTuiClientID.h
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YNUpdateGeTuiClientID : NSObject

+ (YNUpdateGeTuiClientID *) currentRequest;

- (void)setDeviceToken:(NSString *)deviceToken;
- (void)setGetuiPushId:(NSString *)getuiPushId;

- (void)startUpdate;

- (void)cleanCaches;

@end
