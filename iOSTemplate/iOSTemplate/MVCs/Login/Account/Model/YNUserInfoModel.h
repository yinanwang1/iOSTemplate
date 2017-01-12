//
//  YNUserInfoModel.h
//  59dorm
//
//  Created by BeyondChao on 16/7/30.
//  Copyright © 2016年 Huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, YNAuthenticationStatus){
    kYNAuthenticationStatusNotPass = 0,
    kYNAuthenticationStatusPass = 1,
};


@interface YNUserInfoModel : YNBaseJSONModel

@property (nonatomic, strong) NSString *uidStr;
@property (nonatomic, strong) NSString *unameStr;
@property (nonatomic, strong) NSString *portraitURLStr;
@property (nonatomic, strong) NSString *bigPortraitURLStr;
@property (nonatomic, strong) NSString *phoneStr;
@property (nonatomic, strong) NSString *nickNameStr;
@property (nonatomic, strong) NSString *realNameStr;
@property (nonatomic, strong) NSNumber *walletAmountDoubleNum;      // 钱包总额 元，free+limit
@property (nonatomic, strong) NSNumber *walletFreeDoubleNum;        // 钱包余额 可消费可提现
@property (nonatomic, strong) NSNumber *walletLimitDoubleNum;       // 冻结金额 不可提现的钱, 只能用于消费
@property (nonatomic, strong) NSNumber *pledgeDoubleNum;            // 押金
@property (nonatomic, strong) NSNumber *authenticationIntNum;       // 0-认证不通过 1-认证通过
@property (nonatomic, assign) BikePowerMode powerMode;              // 骑行模式

@end
