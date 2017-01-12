//
//  YNRootViewController.m
//  service
//
//  Created by ArthurWang on 2016/12/26.
//  Copyright © 2016年 骑迹. All rights reserved.
//

#import "YNRootViewController.h"

#import "YNGuideViewController.h"
#import "YNAdViewController.h"
#import "YNLoginViewController.h"
#import "YNMainViewController.h"

#import "YNUserAccount.h"

@interface YNRootViewController ()

@property (nonatomic, strong) UIViewController *currentPresentedVC;
@property (nonatomic, assign) BOOL hasFetchedUserInfo;

@end

@implementation YNRootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialNotification];
    
    [self dealWithLoginStatus];
    
    /* 这个版本不显示引导页和广告页
    [self showGuideOrAdVC];
     */
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kLoginCompleteNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kLogoutCompleteNotification
                                                  object:nil];
}


#pragma mark - Initial Methods

- (void)initialNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(login)
                                                 name:kLoginCompleteNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(logout)
                                                 name:kLogoutCompleteNotification
                                               object:nil];
}

#pragma mark - Show Guide & Ad 

- (void)showGuideOrAdVC
{
    NSString *appVersionStr = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString *firstLaunchKeyStr = [NSString stringWithFormat:@"first_launch_%@", appVersionStr];
    if(![[NSUserDefaults standardUserDefaults] objectForKey:firstLaunchKeyStr]
       && !IPAD)
    {
        [self showGuideWithKey:firstLaunchKeyStr];
    }else {
        [self showAd];
    }
}


- (void)showGuideWithKey:(NSString *)key
{
    __weak typeof(self) weakSelf = self;
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    YNGuideViewController * guideViewController = [story instantiateViewControllerWithIdentifier:@"YNGuideViewController"];
    
    guideViewController.block = ^{
        [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [weakSelf dealWithLoginStatus];
    };
    
    if (nil != self.currentPresentedVC) {
        [self.currentPresentedVC removeFromParentViewController];
    }
    
    [guideViewController willMoveToParentViewController:self];
    [self addChildViewController:guideViewController];
    [self.view addSubview:guideViewController.view];
    
    [guideViewController didMoveToParentViewController:self];
    
    self.currentPresentedVC = guideViewController;
}

- (void)showAd
{
    __weak typeof(self) weakSelf = self;
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    YNAdViewController *adViewController = [story instantiateViewControllerWithIdentifier:@"YNAdViewController"];
    
    adViewController.block = ^{
        [weakSelf dealWithLoginStatus];
    };
    
    if (nil != self.currentPresentedVC) {
        [self.currentPresentedVC removeFromParentViewController];
    }
    
    [adViewController willMoveToParentViewController:self];
    [self addChildViewController:adViewController];
    [self.view addSubview:adViewController.view];
    
    [adViewController didMoveToParentViewController:self];
    
    self.currentPresentedVC = adViewController;
}

- (void)showLogin
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    YNLoginViewController *loginViewController = [story instantiateViewControllerWithIdentifier:@"YNLoginViewController"];
    
    if (nil != self.currentPresentedVC) {
        [self.currentPresentedVC removeFromParentViewController];
    }
    
    [loginViewController willMoveToParentViewController:self];
    [self addChildViewController:loginViewController];
    [self.view addSubview:loginViewController.view];
    
    [loginViewController didMoveToParentViewController:self];
    
    self.currentPresentedVC = loginViewController;
}

- (void)showRootViewController
{
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    YNMainViewController *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"YNMainViewController"];
    
    [self.navigationController pushViewController:rootViewController animated:NO];
}


#pragma mark - Deal With Login Status

- (void)dealWithLoginStatus
{
    if ([YNUserAccount currentAccount].isLogin) {
        [self showRootViewController];
    } else {
        [self showLogin];
    }
}


#pragma mark - Target Methods

- (void)login
{
    [[YNUserAccount currentAccount] fetchUserInfoCompleted:nil];
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[YNMainViewController class]]) {
            return;
        }
    }
    
    [self showRootViewController];
}

- (void)logout
{
    [self showLogin];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
