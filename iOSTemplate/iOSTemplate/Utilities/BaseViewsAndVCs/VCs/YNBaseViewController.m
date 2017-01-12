//
//  YNBaseViewController.m
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import "YNBaseViewController.h"

#import "YNWarningBarView.h"
#import "YNMacrosUtils.h"
#import "YNMacrosDefault.h"
#import "UMMobClick/MobClick.h"
#import "SDImageCache.h"
#import "UIViewController+Extensions.h"
#import "UINavigationBar+AlphaTransition.h"

#define PADDING_LEFT_BAR_ITEM  10

@interface YNBaseViewController ()

@end

@implementation YNBaseViewController

#pragma mark - UIViewContriller LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.firstLoading = YES;
    
    [self initSuperNavigationBarStatus];
    
    // Do any additional setup after loading the view.
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenRefreshed) name:kTokenRefreshed object:nil];
    
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kTokenRefreshed object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Initial Methods

- (void)initSuperNavigationBarStatus
{
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationItem.backBarButtonItem = nil;

    if (nil == self.navigationItem.leftBarButtonItem) {
        UIImage *leftItemImage = [UIImage imageNamed:(self.navigationController.viewControllers.count == 1 ? @"icon_back_down" : @"btn_back_normal")];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:leftItemImage
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self
                                                                                action:@selector(back)];
        self.navigationItem.leftBarButtonItem.imageInsets = self.navigationController.viewControllers.count == 1 ? UIEdgeInsetsZero : UIEdgeInsetsMake(0, -5, 0, 5);
    }
}

#pragma mark - Public Methods

- (void)showWarning:(NSString *)wStr
{
    if(wStr == nil || wStr.length == 0)
        return;
    CGFloat warningHeight = 44;
    if (!self.warnBarView) {
        self.warnBarView = [[YNWarningBarView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), warningHeight)];
    }
    [self.warnBarView customWarningText:wStr];
    [self.view addSubview:self.warnBarView];
    
    __weak typeof(self) weakSelf = self;
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [weakSelf.warnBarView removeMyselfViewFromSuperview];
        weakSelf.warnBarView = nil;
    });
}

- (void)dismissWarning
{
    self.warnBarView.hidden = YES;
}

- (void)tokenRefreshed
{
    
}

- (void)replaceCurrentViewControllerWith:(UIViewController *)viewController animated:(BOOL)animated {
    NSMutableArray * viewControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    [viewControllers replaceObjectAtIndex:(viewControllers.count - 1) withObject:viewController];
    [self.navigationController setViewControllers:viewControllers animated:animated];
}

- (void)initialNavigationLeftItem
{
    if (1 == [self.navigationController.viewControllers count]) { // Just contain this
        UIImage *leftItemImage = [UIImage imageNamed:@"icon_back_down"];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:leftItemImage
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self
                                                                                action:@selector(turnBack)];
        self.navigationItem.leftBarButtonItem.imageInsets = UIEdgeInsetsZero;
    } else {
        UIImage *backImage = [UIImage imageNamed:@"btn_back_normal"];
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setBackgroundColor:[UIColor clearColor]];
        [backButton setImage:backImage forState:UIControlStateNormal];
        [backButton addTarget:self
                       action:@selector(turnBack)
             forControlEvents:UIControlEventTouchUpInside];
        
        UIImage *closeImage = [UIImage imageNamed:@"ico_delete"];
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeButton setBackgroundColor:[UIColor clearColor]];
        [closeButton setImage:closeImage forState:UIControlStateNormal];
        [closeButton addTarget:self
                        action:@selector(close)
              forControlEvents:UIControlEventTouchUpInside];
        
        // set frame
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, backImage.size.width + (PADDING_LEFT_BAR_ITEM * 2) + closeImage.size.width, MAX(backImage.size.height, backImage.size.height))];
        
        [backButton setFrame:CGRectMake(0, 0, backImage.size.width, backImage.size.height)];
        [view addSubview:backButton];
        
        [closeButton setFrame:CGRectMake(CGRectGetMaxX(backButton.frame) + PADDING_LEFT_BAR_ITEM * 2, 0, closeImage.size.width, closeImage.size.height)];
        [view addSubview:closeButton];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    }
}


#pragma mark Navigtaion Left Item Methods

- (void)turnBack
{
    if(self.navigationController.viewControllers.count == 1) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)close
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)changeNavigationBarBackgroundColor:(UIColor *)backGroundColor
                      pushBackButItemImage:(UIImage *)pushBackImage
                   presentBackButItemImage:(UIImage *)presentBackImage
                                titleColor:(UIColor *)titleColor {
    
    UIImage *leftItemImage = self.navigationController.viewControllers.count == 1 ?  presentBackImage: pushBackImage;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[leftItemImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(back)];
    [self.navigationController.navigationBar at_resetBackgroundColor:backGroundColor translucent:YES];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: titleColor}];
}

- (void)changeNavigationBarNormal
{
    [self.navigationController.navigationBar at_resetBackgroundColor:MAIN_COLOR translucent:YES];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
}

@end
