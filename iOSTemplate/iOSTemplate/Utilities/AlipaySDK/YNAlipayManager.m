//
//  YNAlipayManager.m
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import "YNAlipayManager.h"

#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "NSString+Addition.h"
#import "YNMacrosUtils.h"
#import "ApplicationSettings.h"
#import "YNOrderInfo.h"
#import "YNMacrosEnum.h"

static YNAlipayManager * alipay_instance = nil;

@interface YNAlipayManager()

@end

@implementation YNAlipayManager

+ (YNAlipayManager *) sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (alipay_instance == nil) alipay_instance = [[YNAlipayManager alloc] init];
    });
    return alipay_instance;
}

- (id) init
{
    self = [super init];
    if (self != nil)
    {
        
    }
    
    return self;
}

- (BOOL)handleOpenURL:(NSURL *)url {
    if (url && [url.host isEqualToString:@"safepay"]) {
        
        NSString * urlString = [NSString decodeString:url.query];
        id json = [NSJSONSerialization JSONObjectWithData:[urlString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];;
        if(json && [json isKindOfClass:[NSDictionary class]]) {
            if(DIC_HAS_DIC(json, @"memo")) {
                NSDictionary * memoDic = [json objectForKey:@"memo"];
                if(DIC_HAS_STRING(memoDic, @"memo") && DIC_HAS_STRING(memoDic, @"ResultStatus")) {
                    NSString * message = [memoDic objectForKey:@"memo"];
                    NSString * status = [memoDic objectForKey:@"ResultStatus"];
                    NSDictionary * result = nil;
                    if(DIC_HAS_DIC(memoDic, @"result")) {
                        result = [memoDic objectForKey:@"result"];
                    }
                    
                    if(self.delegate && [self.delegate respondsToSelector:@selector(payCallBack:message:result:)]) {
                        [self.delegate payCallBack:status message:message result:result];
                    }
                }
            }
        }
        
        return YES;
    }
    
    return NO;
}

- (void)pay:(NSDictionary *)orderInfoDic delegate:(id<YNAlipayDelegate>)delegate
{
    YNOrderInfo *orderInfo = [[YNOrderInfo alloc] initWithDictionary:orderInfoDic error:nil];
    
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    NSString *partner = nil;
    NSString *seller = nil;
    NSString *privateKey = nil;
    EnvironmentType environmentType = [[ApplicationSettings instance] currentEnvironmentType];
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    if (EnvironmentStage == environmentType
        || EnvironmentQA == environmentType
        || EnvironmentTemai == environmentType) {
        partner = @"";
        seller = @"";
        privateKey = @"";
    } else {
        partner = @"";
        seller = @"";
        privateKey = @"";
    }
    
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    self.delegate = delegate;
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = orderInfo.order_sn; //订单ID（由商家自行制定）
    order.productName = [NSString stringWithFormat:@"%@订单", orderInfo.typeName]; //商品标题
    // 商品价格
    order.amount = [NSString stringWithFormat:@"%.2f",orderInfo.order_amount.floatValue]; // 不分期
    
    if (0 < [orderInfo.attach length]) {
        order.productDescription = orderInfo.attach;
    }
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"http://www.baidu.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"YN";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            if(resultDic) {
                if(DIC_HAS_DIC(resultDic, @"memo")) {
                    NSDictionary * memoDic = [resultDic objectForKey:@"memo"];
                    if(DIC_HAS_STRING(memoDic, @"memo") && DIC_HAS_STRING(memoDic, @"ResultStatus")) {
                        NSString * message = [memoDic objectForKey:@"memo"];
                        NSString * status = [memoDic objectForKey:@"ResultStatus"];
                        NSDictionary * result = nil;
                        if(DIC_HAS_DIC(memoDic, @"result")) {
                            result = [memoDic objectForKey:@"result"];
                        }
                        
                        if(self.delegate && [self.delegate respondsToSelector:@selector(payCallBack:message:result:)]) {
                            [self.delegate payCallBack:status message:message result:result];
                        }
                    }
                }else if(DIC_HAS_STRING(resultDic, @"memo") && [resultDic objectForKey:@"resultStatus"]) {
                    NSString * message = [resultDic objectForKey:@"memo"];
                    NSString * status = [NSString stringWithFormat:@"%@", [resultDic objectForKey:@"resultStatus"]];
                    NSString * result = [resultDic objectForKey:@"result"];
                    if(self.delegate && [self.delegate respondsToSelector:@selector(payCallBack:message:result:)]) {
                        [self.delegate payCallBack:status message:message result:@{@"result":result}];
                    }
                }
            }
        }];
    }
}

@end
