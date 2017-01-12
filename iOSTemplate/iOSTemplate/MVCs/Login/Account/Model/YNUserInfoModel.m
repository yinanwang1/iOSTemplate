//
//  YNUserInfoModel.m
//  59dorm
//
//  Created by BeyondChao on 16/7/30.
//  Copyright © 2016年 Huanxiao. All rights reserved.
//

#import "YNUserInfoModel.h"

@implementation YNUserInfoModel

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *itemMapping = @{@"uidStr":         @"uid",
                                  @"unameStr":          @"uname",
                                  @"portraitURLStr":    @"portrait",
                                  @"bigPortraitURLStr": @"big_portrait",
                                  @"phoneStr":          @"phone",
                                  @"nickNameStr":       @"nickname",
                                  @"realNameStr":       @"real_name",
                                  @"walletAmountDoubleNum": @"wallet_amount",
                                  @"walletFreeDoubleNum":   @"wallet_free",
                                  @"walletLimitDoubleNum":  @"wallet_limit",
                                  @"pledgeDoubleNum":       @"pledge",
                                  @"authenticationIntNum":  @"authentication",
                                  @"powerMode":             @"drive_power_mode"
                                  };
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:itemMapping];
}

@end
