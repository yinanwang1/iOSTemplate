//
//  YNWXApiManager.m
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import "YNWXApiManager.h"

#import "YNWebService.h"
#import "ApplicationSettings.h"
#import "YNOrderInfo.h"

static YNWXApiManager * wx_instance = nil;


#define YN_WXPAY_PREPAY_ID           @"pay/wxpay/prepay_id"     // 获取预支付订单id

// 账号帐户资料
//wechat
#define kWeixinAppId     @""
#define kWeixinAppSecret @""


@interface YNWXApiManager ()

@property (nonatomic, strong) YNOrderInfo *orderInfo;


@end

@implementation YNWXApiManager

+ (YNWXApiManager *) sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (wx_instance == nil) wx_instance = [[YNWXApiManager alloc] init];
    });
    return wx_instance;
}

- (id) init
{
    self = [super init];
    if (self != nil)
    {
        [WXApi registerApp:kWeixinAppId];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *wechatInfo = [defaults objectForKey:@"WXAuthData"];
        if ([wechatInfo objectForKey:@"AccessTokenKey"] && [wechatInfo objectForKey:@"ExpirationDateKey"] && [wechatInfo objectForKey:@"UserIDKey"] && [wechatInfo objectForKey:@"RefreshToken"])
        {
            self.accessToken = [wechatInfo objectForKey:@"AccessTokenKey"];
            self.expirationDate = [wechatInfo objectForKey:@"ExpirationDateKey"];
            self.userID = [wechatInfo objectForKey:@"UserIDKey"];
            self.refresh_token = [wechatInfo objectForKey:@"RefreshToken"];
        }
    }
    
    return self;
}

- (BOOL)isWechatInstalled {
    return [WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi];
}

- (void)storeAuthData
{
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              self.accessToken, @"AccessTokenKey",
                              self.expirationDate, @"ExpirationDateKey",
                              self.userID, @"UserIDKey",
                              self.refresh_token, @"RefreshToken", nil];
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"WXAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (void)removeAuthData
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"WXAuthData"];
}

- (BOOL)handleOpenURL:(NSURL *)url {
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)isLoggedIn {
    return self.accessToken != nil;
}

- (void)logIn {
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc ] init ];
    req.scope = @"snsapi_userinfo" ;
    req.state = @"123" ;
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
}

- (void)logOut {
    [self removeAuthData];
    self.accessToken = nil;
    self.userID = nil;
    self.expirationDate = nil;
}

- (void)shareAppToWeixinFriends:(BOOL)isTimeLine callback:(YNShareCallbackBlock)callback
{
    self.shareCallBack = callback;
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"YN";
    message.description = @"YN";
    [message setThumbImage:[UIImage imageNamed:@"share_icon"]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    NSString * url = isTimeLine ? @"YN":@"YN";
    ext.webpageUrl = url;
    
    message.mediaObject = ext;
    message.mediaTagName = @"WECHAT_TAG_JUMP_SHOWRANK";
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = isTimeLine?WXSceneTimeline:WXSceneSession;
    [WXApi sendReq:req];
}

- (void)shareToWeixinWithTitle:(NSString *)title text:(NSString *)text image:(UIImage *)image url:(NSString *)url timeLine:(BOOL)isTimeLine callback:(YNShareCallbackBlock)callback
{
    self.shareCallBack = callback;
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title?title:@"";
    message.description = text;
    [message setThumbImage:image];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = url;
    
    message.mediaObject = ext;
    message.mediaTagName = @"WECHAT_TAG_JUMP_SHOWRANK";
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = isTimeLine?WXSceneTimeline:WXSceneSession;
    [WXApi sendReq:req];
}

#pragma mark - WXApiDelegate

- (void)onReq:(BaseReq *)req
{
    // Do nothing
}

- (void)onResp:(BaseResp *)resp
{
    NSString *strMsg;
    YNShareResult result;
    
    if([resp isKindOfClass:[SendMessageToWXResp class]]) {
        switch (resp.errCode) {
                
            case WXSuccess:
            {
                strMsg = @"分享成功！";
                result = kYNShareResultOk;
            }
                break;
            case WXErrCodeCommon:
            {
                strMsg = @"分享失败！";
                result = kYNShareResultFailed;
            }
                break;
            case WXErrCodeUserCancel:
            {
                strMsg = @"分享取消！";
                result = kYNShareResultCancel;
            }
                
                break;
            default:
                strMsg = [NSString stringWithFormat:@"分享失败！"];
                result = kYNShareResultFailed;
                break;
        }
        
        if (self.shareCallBack) {
            self.shareCallBack(result, strMsg);
            
            self.shareCallBack = nil;
        }
        
        return;
    }
    
    //启动微信支付的response
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        switch (resp.errCode) {
            case 0:
                strMsg = @"支付结果：成功！";
                break;
            case -1:
                strMsg = @"支付结果：失败！";
                break;
            case -2:
                strMsg = @"用户已经退出支付！";
                break;
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                break;
        }
        
        if (self.wechatPayDelegate
            && [self.wechatPayDelegate respondsToSelector:@selector(wechatPayCallBack:message:result:)]) {
            [self.wechatPayDelegate wechatPayCallBack:resp.errCode
                                              message:strMsg
                                               result:nil];
            
            self.wechatPayDelegate = nil;
        }
        
        return;
    }
}

- (void)getAuthInfo:(NSString *)code
{
    NSString *url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code", kWeixinAppId, kWeixinAppSecret, code];
    
    __weak typeof(self) weakSelf = self;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:url]
                                                       completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                           NSDictionary * wechatInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                                                           if ([wechatInfo objectForKey:@"access_token"] && [wechatInfo objectForKey:@"expires_in"] && [wechatInfo objectForKey:@"openid"] && [wechatInfo objectForKey:@"refresh_token"])
                                                           {
                                                               weakSelf.accessToken = [wechatInfo objectForKey:@"access_token"];
                                                               weakSelf.expirationDate = [NSDate dateWithTimeIntervalSinceNow:[[wechatInfo objectForKey:@"expires_in"] integerValue]];
                                                               weakSelf.userID = [wechatInfo objectForKey:@"openid"];
                                                               weakSelf.refresh_token = [wechatInfo objectForKey:@"refresh_token"];
                                                               dispatch_sync(dispatch_get_main_queue(), ^{
                                                                   [weakSelf storeAuthData];
                                                                   
                                                               });
                                                               
                                                           }
                                                       }];
    
    [task resume];
    
}


#pragma mark - Box Order Share Methods

- (void)shareAppToWeixinFriends:(BOOL)isTimeLine
               withActivityInfo:(YNOrderActivityInfo *)activityInfo
                          image:(UIImage *)image
                       callback:(YNShareCallbackBlock)callback
{
    self.shareCallBack = callback;
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = activityInfo.title;
    message.description = activityInfo.text;
    [message setThumbImage:image];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    NSString * url = activityInfo.url;
    ext.webpageUrl = url;
    
    message.mediaObject = ext;
    message.mediaTagName = @"WECHAT_TAG_JUMP_SHOWRANK";
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = isTimeLine ? WXSceneTimeline : WXSceneSession;
    
    [WXApi sendReq:req];
}

- (void)shareAppToWeixin:(BOOL)isTimeLine
        withActivityInfo:(YNOrderActivityInfo *)activityInfo
                   image:(UIImage *)image
                callback:(YNShareCallbackBlock)callback
{
    self.shareCallBack = callback;
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = activityInfo.title;
    message.description = activityInfo.text;
    [message setThumbImage:image];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    NSString * url = activityInfo.url;
    ext.webpageUrl = url;
    
    message.mediaObject = ext;
    message.mediaTagName = @"WECHAT_TAG_JUMP_SHOWRANK";
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = isTimeLine ? WXSceneTimeline : WXSceneSession;
    
    [WXApi sendReq:req];
}


#pragma mark - Wechat Pay

// pay
- (void)wechatPay:(NSDictionary *)orderInfoDic delegate:(id)delegate
{
    YNOrderInfo *orderInfo = [[YNOrderInfo alloc] initWithDictionary:orderInfoDic error:nil];
    
    self.orderInfo = orderInfo;
    self.wechatPayDelegate = delegate;
    
    NSString *nameStr = [NSString stringWithFormat:@"%@订单", self.orderInfo.typeName]; //商品标题
    // 商品价格
    NSNumber *priceNum = orderInfo.order_amount; // 单位（元）
    
    NSString *attach = nil;
    
    NSDictionary *paramsDic = @{
                                @"app_type":@1,
                                @"order_id":self.orderInfo.order_sn,
                                @"food_name":nameStr,
                                @"money":priceNum,
                                @"attach":attach,
                                };
    
    __weak typeof(self) weakSelf = self;
    [YNWebService postRequest:YN_WXPAY_PREPAY_ID
                       parameters:paramsDic
                         progress:nil
                          success:^(ErrorCode status, NSString *msg, NSDictionary *data) {
                              if (kNoError != status) {
                                  if (weakSelf.wechatPayDelegate
                                      && [weakSelf.wechatPayDelegate respondsToSelector:@selector(wechatPayCallBack:message:result:)]) {
                                      [weakSelf.wechatPayDelegate wechatPayCallBack:YNWechatPayStatusParamError
                                                                            message:nil
                                                                             result:nil];
                                      
                                      weakSelf.wechatPayDelegate = nil;
                                  }
                                  
                                  return ;
                              }
                              
                              [weakSelf sendReqOfWechat:data];
                              
                          } failure:^(ErrorCode status, NSString *msg, NSDictionary *data) {
                              if (weakSelf.wechatPayDelegate
                                  && [weakSelf.wechatPayDelegate respondsToSelector:@selector(wechatPayCallBack:message:result:)]) {
                                  [weakSelf.wechatPayDelegate wechatPayCallBack:YNWechatPayStatusParamError
                                                                    message:nil
                                                                     result:nil];
                                  
                                  weakSelf.wechatPayDelegate = nil;
                              }
                          }];
}



- (void)sendReqOfWechat:(NSDictionary *)dict
{
    NSMutableString *stamp  = [dict objectForKey:@"time_stamp"];
    
    //调起微信支付
    PayReq* req   = [[PayReq alloc] init];
    
    req.openID    = [dict objectForKey:@"app_id"];
    req.partnerId = [dict objectForKey:@"partner_id"];
    req.prepayId  = [dict objectForKey:@"prepay_id"];
    req.nonceStr  = [dict objectForKey:@"nonce_str"];
    req.timeStamp = stamp.intValue;
    req.package   = [dict objectForKey:@"package"];
    req.sign      = [dict objectForKey:@"sign"];
    
    [WXApi sendReq:req];
}

@end
