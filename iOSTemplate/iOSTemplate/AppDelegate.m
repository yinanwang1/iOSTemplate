//
//  AppDelegate.m
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import "AppDelegate.h"

// Controllers
#import "YNBaseNavigationController.h"
#import "YNCustomAlertView.h"

#import "ApplicationSettings.h"
#import "YNDirectoryManager.h"
#import "YNGeTuiSdkManager.h"
#import "Color+Image.h"

// View Model
#import "YNGeTuiSdkManager.h"
#import "YNWXApiManager.h"
#import "YNAlipayManager.h"

// Third Framework
#import "AFNetworking.h"
#import <JSPatchPlatform/JSPatch.h>
#import <AlicloudHttpDNS/AlicloudHttpDNS.h>
#import "YNAppDeviceHelper.h"
#import "UMMobClick/MobClick.h"
#import <AMapFoundationKit/AMapFoundationKit.h>

// System
#import <UserNotifications/UserNotifications.h>

#define kChanelKey          @""                            //渠道key
#define kMobclickKey        @""         //友盟统计key
#define kJSPatchKey         @""                 // JSPatch appKey
static NSString * const kAliHttpNDSAccountID = @"";       // Ali HTTPDNS

@interface AppDelegate () <UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setupJSPath];
    
    [self setupAliHttpDNS];
    
    [self setupCache];
    
    [self setupInitialStatusOfBusiness];
    
    [self initialAPNSiOS10];
    
    [self setupRemoteNotificationWithOptions:launchOptions];
    
    [self setupUserAgent];
    
    [self setupAmapServicesKey];
    
    [self updateToken];
    
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[YNGeTuiSdkManager sharedInstance] stopSdk];
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[YNGeTuiSdkManager sharedInstance] startSdk];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}


#pragma mark - Notification Methods

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    DLog(@"deviceToken:%@", token);
    
    // [3]:向个推服务器注册deviceToken
    [[YNGeTuiSdkManager sharedInstance] setDeviceToken:token data:deviceToken];
    [[YNGeTuiSdkManager sharedInstance] setAlias:[YNAppDeviceHelper uniqueDeviceIdentifier]];
    [[YNUpdateGeTuiClientID currentRequest] setDeviceToken:token];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    // [3-EXT]:如果APNS注册失败，通知个推服务器
    [[YNGeTuiSdkManager sharedInstance] setDeviceToken:@"" data:nil];
    
    DLog(@"didFailToRegisterForRemoteNotificationsWithError:%@", [error localizedDescription]);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userinfo
{
    [self dealWithRemoteNotification:userinfo];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [[YNWXApiManager sharedManager] handleOpenURL:url]
    || [[YNAlipayManager sharedManager] handleOpenURL:url];
}

#pragma mark - Public Methods

+ (AppDelegate *)sharedDelegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (UIViewController *)rootViewController
{
    UIViewController *controller = [UIApplication sharedApplication].keyWindow.rootViewController;;
    
    if([controller isKindOfClass:[UINavigationController class]]) {
        UINavigationController * nav = (UINavigationController *)controller;
        for(UIViewController * root in nav.viewControllers) {
            if([root isKindOfClass:[UIViewController class]]) {
                return (UIViewController *)root;
            }
        }
    }
    
    return nil;
}


#pragma mark - Set up Methods

- (void)setupJSPath
{
    // JSPatch 初始化
    [JSPatch startWithAppKey:kJSPatchKey];
    
    [JSPatch sync];
}

- (void)setupAliHttpDNS
{
    HttpDnsService *httpdns = [HttpDnsService sharedInstance];
    
    [httpdns setAccountID:[kAliHttpNDSAccountID intValue]];
    
    [httpdns setPreResolveHosts:[[ApplicationSettings instance] hosts]];
    
    [httpdns setExpiredIPEnabled:YES];
}

- (void)setupCache
{
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024
                                                         diskCapacity:200 * 1024 * 1024
                                                             diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    
    [YNDirectoryManager addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:[YNDirectoryManager getDocumentsDirectory]]];
    [YNDirectoryManager addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:[YNDirectoryManager getLibraryDirectory]]];
}

- (void)setupInitialStatusOfBusiness
{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    // Override point for customization after application launch.
#if !DEBUG
    UMConfigInstance.appKey = kMobclickKey;
    UMConfigInstance.ePolicy = REALTIME;
    UMConfigInstance.channelId = kChanelKey;
    
    [MobClick startWithConfigure:UMConfigInstance];
#endif
    // 推送
    [[YNGeTuiSdkManager sharedInstance] startSdk];
    
    [self initCustomUniversal];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self initCustomControlPhone];
    }
}

- (void)initialAPNSiOS10
{
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10.0")){
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            if( !error ){
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            }
        }];
    }
}

- (void)setupRemoteNotificationWithOptions:(NSDictionary *)launchOptions
{
    // remote notification
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)setupUserAgent
{
    //设置webview的user-agent
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"]) {
        
        NSString *userAgent = [NSString stringWithFormat:@"%@/%@; iOS %@; %.0fX%.0f/%0.1f", [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleNameKey] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleIdentifierKey], [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleVersionKey], [[UIDevice currentDevice] systemVersion], SCREEN_WIDTH*[[UIScreen mainScreen] scale],SCREEN_HEIGHT*[[UIScreen mainScreen] scale], [[UIScreen mainScreen] scale]];
        if (userAgent) {
            if (![userAgent canBeConvertedToEncoding:NSASCIIStringEncoding]) {
                NSMutableString *mutableUserAgent = [userAgent mutableCopy];
                if (CFStringTransform((__bridge CFMutableStringRef)(mutableUserAgent), NULL, (__bridge CFStringRef)@"Any-Latin; Latin-ASCII; [:^ASCII:] Remove", false)) {
                    userAgent = mutableUserAgent;
                }
            }
        }
        
        UIWebView *tempWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
        NSString *originalUserAgent = [tempWebView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
        NSString *userAgentStr = [NSString stringWithFormat:@"%@\\%@; %@; %@", originalUserAgent, [YNAppDeviceHelper modelString], userAgent,[NSString stringWithFormat:@"IsJailbroken/%d",[YNAppDeviceHelper isJailbroken]]];
        [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent":userAgentStr, @"User-Agent":userAgentStr}];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)setupAmapServicesKey {
    
    [AMapServices sharedServices].apiKey = kAmapKey;
}

- (void)updateToken
{
    if (nil == [YNUserAccount currentAccount].strToken) {
        [[YNUserAccount currentAccount] updateToken];
    }
}


#pragma mark - Initial Methods

- (void)initCustomUniversal
{
    // UINavigationBar
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:MAIN_COLOR] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleDefault];
    [[UINavigationBar appearance] setBackgroundColor:[UIColor clearColor]];
    [[UINavigationBar appearance] setBarTintColor:MAIN_COLOR];
    
    NSShadow * shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor clearColor];
    shadow.shadowOffset = CGSizeZero;
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor],
                                                         NSFontAttributeName : [UIFont systemFontOfSize:17.0f],
                                                         NSShadowAttributeName:shadow};
    [UINavigationBar appearance].shadowImage = [[UIImage alloc] init];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTintColor:[UIColor whiteColor]];
}

- (void)initCustomControlPhone
{
    // UITabBar
    [UITabBar appearance].backgroundColor = [UIColor whiteColor];
    [UITabBar appearance].backgroundImage = [UIImage imageWithColor:[UIColor whiteColor]];
    [UITabBar appearance].shadowImage = [UIImage imageWithColor:MAIN_COLOR];
    [UITabBar appearance].selectionIndicatorImage = [UIImage imageWithColor:[UIColor clearColor]];
    [[UITabBar appearance] setBarStyle:UIBarStyleDefault];
    
    NSShadow * shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor clearColor];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: MAIN_COLOR,
                                                        NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:10],
                                                        NSShadowAttributeName:shadow}
                                             forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: MAIN_COLOR,
                                                        NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:10],
                                                        NSShadowAttributeName:shadow}
                                             forState:UIControlStateNormal];
}

- (void)showPayload:(NSString *)payload
{
    NSDictionary *userinfo = [NSJSONSerialization JSONObjectWithData:[payload dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    if(![userinfo isKindOfClass:[NSDictionary class]]) {
        userinfo = [NSDictionary dictionary];
    }
    
    [self dealWithRemoteNotification:userinfo];
    
    [self checkMessageAndUrlInUserInfo:userinfo];
}

- (void)checkMessageAndUrlInUserInfo:(NSDictionary *)userinfo
{
    NSDictionary *dataDic = nil;
    if(DIC_HAS_DIC(userinfo, @"data")){
        dataDic = [userinfo objectForKey:@"data"];
    }
    
    if(nil != dataDic){
        
        NSString *url = nil;
        if(DIC_HAS_STRING(dataDic, @"link")) {
            SET_NULLTONIL(url, [dataDic objectForKey:@"link"]);
        }
        NSString *msg = nil;
        if (DIC_HAS_STRING(userinfo, @"msg")) {
            SET_NULLTONIL(msg, [userinfo objectForKey:@"msg"]);
        }
        
        //封装的alertView
        if(0 < url.length) {
            //封装的alertView
            YNCustomAlertView *alertView = [[YNCustomAlertView alloc] initWithTitle:@"推送消息"
                                                                              message:msg
                                                                      leftButtonTitle:@"取消"
                                                                    rightButtonTitles:@"查看"];
            alertView.rightBtnBlock = ^{
                [[AppDelegate sharedDelegate] showURL:url];
            };
            [alertView show];
        }
        
    }
}

- (void)showURL:(NSString *)url
{
    DLog(@"url  %@", url);
    
    if((nil != url)
       && [url isKindOfClass:[NSString class]]
       && (0 < url.length)) {
        // 此版本不提供
    }
}



#pragma mark - UNUserNotificationCenterDelegate

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler
{
    // 当App正在前台时，此时若收到通知，将触发该方法
    
    DLog(@"notification %@", notification);
    
    completionHandler(UNNotificationPresentationOptionAlert);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler
{
    // 当用户点击通知、点击action、回复/评论时，将触发该方法
    
    DLog(@"Userinfo %@", response.notification.request.content.userInfo);
    
    [self dealWithRemoteNotification:response.notification.request.content.userInfo];
}


#pragma mark - Push Notice Methods

- (void)dealWithRemoteNotification:(NSDictionary *)userinfo
{
    DLog(@"userinfo is %@", userinfo);
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}


@end
