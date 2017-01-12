//
//  YNOrderInfo.h
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YNBaseJSONModel.h"

@interface YNOrderInfo : YNBaseJSONModel

@property (nonatomic, strong) NSString * typeName;
@property (nonatomic, strong) NSString * order_sn;          // 订单号
@property (nonatomic, strong) NSNumber * order_amount;      // food_amount + delivery_fee - discount
@property (nonatomic, strong) NSString * attach;

@end
