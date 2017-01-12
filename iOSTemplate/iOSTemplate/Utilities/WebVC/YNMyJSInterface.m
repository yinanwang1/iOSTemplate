//
//  YNMyJSInterface.m
//  59dorm
//
//  Created by J006 on 16/8/2.
//  Copyright © 2016年 Huanxiao. All rights reserved.
//

#import "YNMyJSInterface.h"

static CGFloat kHeightOfNavigationAndStatusBar = 64;
#define PADDING_LEFT_BAR_ITEM  10

@implementation YNMyJSInterface

#pragma mark init set

- (void)setUpWithBridge:(WKWebViewJavascriptBridge *)bridge
{
    // WebViewJavascriptBridge & WKWebViewJavascriptBridge
    self.bridge = bridge;
    
    //设置本地监听
    __weak typeof(self) weakSelf = self;
    [bridge registerHandler:@"pushViewWithUrlAndTitle" handler:^(id data, WVJBResponseCallback responseCallback) {
        if(![data isKindOfClass:[NSDictionary class]]) {
            data = [NSDictionary dictionary];
        }
        NSString *url;
        NSString *title;
        SET_NULLTONIL(url, [data objectForKey:@"url"]);
        SET_NULLTONIL(title, [data objectForKey:@"title"]);
        NSString *status = [weakSelf pushViewWithUrl:url
                                            andTitle:title];
        
        responseCallback(@{@"status":status, @"message":@"push view success"});
    }];
    
    //设置导航栏右上角按钮
    [bridge registerHandler:@"setNavigationButton" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSString *status = @"1";
        
        if([data isKindOfClass:[NSDictionary class]]) {
            status = [weakSelf.currentViewController setUpNavigationRightButton:data];
        }
        
        responseCallback(@{@"status":status, @"message":@"push view success"});
    }];
    
    // 获取app和设备信息
    [bridge registerHandler:@"getPlatformInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSDictionary *info = @{@"status":@"0",
                               @"message":@"获取成功",
                               @"data":@{
                                       @"appName":[YNAppConfig sharedInstance].appName,
                                       @"appBuild":[YNAppConfig sharedInstance].appBuild,
                                       @"appBundle":[[[NSBundle mainBundle] infoDictionary]
                                                     objectForKey:@"CFBundleIdentifier"],
                                       @"appVersion":[YNAppConfig sharedInstance].appVersion,
                                       @"deviceId":[YNAppDeviceHelper uniqueDeviceIdentifier],
                                       @"system":[NSString stringWithFormat:@"iOS %@", [[UIDevice currentDevice] systemVersion]],
                                       @"screen":[NSString stringWithFormat:@"%.0fX%.0f/%0.1f", SCREEN_WIDTH*[[UIScreen mainScreen] scale],SCREEN_HEIGHT*[[UIScreen mainScreen] scale], [[UIScreen mainScreen] scale]]
                                       }
                               };
        responseCallback(info);
    }];
    
    // 结束当前页面
    [bridge registerHandler:@"closeCurrentView" handler:^(id data, WVJBResponseCallback responseCallback) {
        responseCallback(@{@"status":[weakSelf closeCurrentView], @"message":@""});
    }];
    
    // 显示/隐藏Tab Bar
    [bridge registerHandler:@"setTabBarHidden"
                    handler:^(id data, WVJBResponseCallback responseCallback) {
                        NSString *hideStr = (NSString *)data;
                        BOOL hidden = NO;
                        if ([hideStr isEqualToString:@"YES"]) {
                            hidden = YES;
                        } else {
                            hidden = NO;
                        }
                        
                        [weakSelf changeTabBarHidden:hidden];
                        
                        responseCallback(@{@"status":@"0", @"message":@"hide success"});
                    }];
    
    // 显示/隐藏Navigation Bar
    [bridge registerHandler:@"setNavigationBarHidden"
                    handler:^(id data, WVJBResponseCallback responseCallback) {
                        NSString *hideStr = (NSString *)data;
                        BOOL hidden = NO;
                        if ([hideStr isEqualToString:@"YES"]) {
                            hidden = YES;
                        } else {
                            hidden = NO;
                        }
                        
                        [weakSelf changeNavigationBarHidden:hidden];
                        
                        responseCallback(@{@"status":@"0", @"message":@"hide success"});
                    }];
    
    // 显示/隐藏Navigation Bar 的返回按钮
    [bridge registerHandler:@"setNavigationBarBackButtonHidden"
                    handler:^(id data, WVJBResponseCallback responseCallback) {
                        NSString *hideStr = (NSString *)data;
                        BOOL hidden = NO;
                        if ([hideStr isEqualToString:@"YES"]) {
                            hidden = YES;
                        } else {
                            hidden = NO;
                        }
                        
                        [weakSelf changeNavigationBarBackButton:hidden];
                        
                        responseCallback(@{@"status":@"0", @"message":@"hide success"});
                    }];
    
    // 设置Navigation Bar的标题
    [bridge registerHandler:@"setNavigationBarTitle"
                    handler:^(id data, WVJBResponseCallback responseCallback) {
                        NSString *titleStr = (NSString *)data;
                        
                        if (([titleStr isKindOfClass:[NSString class]])
                            && (0 < [titleStr length])) {
                            weakSelf.currentViewController.navigationItem.title = titleStr;
                        }
                        
                        responseCallback(@{@"status":@"0", @"message":@"hide success"});
                    }];
    
    // 登录成功
    [bridge registerHandler:@"setLogin" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        if ([data isKindOfClass:[NSString class]]) {
            NSString *token = (NSString *)data;
            if (0 < [token length]) {
                [YNUserAccount currentAccount].strToken = token;
            }
        }
        
        [[YNUserAccount currentAccount] fetchUserInfoCompleted:^(ErrorCode status, NSString *message, NSDictionary *dic) {
            if (kNoError != status) {
                responseCallback(@{@"status":@"0", @"message":message});
                return ;
            }
            
            responseCallback(@{@"status":@"1", @"message":@"login success"});
        }];
        
        
    }];
    
    // 登出成功
    [bridge registerHandler:@"setLogout" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSString *status = @"1";
        
        [[YNUserAccount currentAccount] logout];
        
        responseCallback(@{@"status":status, @"message":@"logout success"});
    }];
    
    // 是否登陆
    [bridge registerHandler:@"isLogin" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSString *status = @"1";
        
        NSString *isLoginStr = nil;
        if ([[YNUserAccount currentAccount] isLogin]) {
            isLoginStr = @"YES";
        } else {
            isLoginStr = @"NO";
        }
        
        
        responseCallback(@{@"status":status,
                           @"message":@"isLogin success",
                           @"data":@{@"isLogin":isLoginStr}
                           });
    }];
}


#pragma mark - Target Methods

- (NSString *)pushViewWithUrl:(NSString *)url
                     andTitle:(NSString *)title
{
    DLog(@"pushViewWithUrl: %@ title: %@", url, title);
    
    if(self.currentViewController) {
        YNWebViewController *webViewController = [YNWebViewController controllerFromXib];
        [webViewController setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@",url]]];
        webViewController.title = title;
        [self.currentViewController.navigationController pushViewController:webViewController animated:YES];
        
        return @"0";
    }
    return @"1";
}


- (void)changeTabBarHidden:(BOOL)hidden
{
    UITabBarController *tabBarController = nil;
    UIViewController *vc = self.currentViewController.parentViewController;
    
    while (nil != vc) {
        if ([vc isKindOfClass:[UITabBarController class]]) {
            tabBarController = (UITabBarController *)vc;
            
            break;
        }
        
        vc = vc.parentViewController;
    }
    
    if (nil == tabBarController) {
        return;
    }
    
    if (hidden != tabBarController.tabBar.hidden) {
        tabBarController.tabBar.hidden = hidden;
        
        CGRect currentFrame = self.currentViewController.view.frame;
        
        if (hidden)
        {
            currentFrame.size.height += kHeightTabBar;
        } else {
            currentFrame.size.height -= kHeightTabBar;
        }
        
        self.currentViewController.view.frame = currentFrame;
    }
    
}

- (void)changeNavigationBarHidden:(BOOL)hidden
{
    if (nil == self.currentViewController.navigationController.navigationBar) {
        return;
    }
    
    if (self.currentViewController.navigationController.navigationBar.hidden != hidden) {
        self.currentViewController.navigationController.navigationBar.hidden = hidden;
        
        CGRect frame = self.currentViewController.view.frame;
        
        if (hidden) {
            frame.origin.y = 0;
            frame.size.height += kHeightOfNavigationAndStatusBar;
        } else {
            frame.origin.y = kHeightOfNavigationAndStatusBar;
            frame.size.height -= kHeightOfNavigationAndStatusBar;
        }
        
        self.currentViewController.view.frame = frame;
    }
}

- (void)changeNavigationBarBackButton:(BOOL)hidden
{
    if (hidden) {
        self.currentViewController.navigationItem.leftBarButtonItem = nil;
    } else {
        UIImage *backImage = [UIImage imageNamed:@"btn_back_normal"];
        
        self.currentViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backImage style:UIBarButtonItemStylePlain target:self action:@selector(justBack)];
    }
}

- (NSString *)closeCurrentView {
    
    if (self.currentViewController) {
        [self.currentViewController.navigationController popViewControllerAnimated:YES];
        
        return @"0";
    }
    
    return @"1";
}


#pragma mark - Private Methods

- (void)justBack
{
    [self.currentViewController justBack];
}



@end
