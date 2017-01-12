//
//  YNUserAccount.h
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YNUserInfoModel.h"

extern NSString * const kLoginCompleteNotification;
extern NSString * const kLogoutCompleteNotification;

@interface YNUserAccount : NSObject

@property (nonatomic, copy) NSString *strToken;
@property (nonatomic, copy) NSString *phone;

@property (nonatomic, assign) double userLocationLatitude;
@property (nonatomic, assign) double userLocationLongitude;

@property (nonatomic, copy) NSString *currentCity;

@property (nonatomic, assign) BOOL rideOngoing;

@property (nonatomic, strong) YNUserInfoModel *userInfoModel;

@property (nonatomic, assign) BOOL isLabourPower;

+ (YNUserAccount *)currentAccount;

- (BOOL)isLogin;

- (void)updateToken;

- (void)fetchUserInfoCompleted:(void (^)(ErrorCode status, NSString *message, NSDictionary *dic))block;

- (void)logout;

@end
