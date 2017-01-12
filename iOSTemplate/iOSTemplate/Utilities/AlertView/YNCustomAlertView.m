//
//  YNCustomAlertView.m
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import "YNCustomAlertView.h"

#import "YNAppDeviceHelper.h"
#import "UIWindow+Extension.h"

static YNCustomAlertView *alertViewSingle = nil;

@interface YNCustomAlertView ()<UIAlertViewDelegate>

@property (nonatomic, assign) BOOL didRightToLeft;

@property (nonatomic, strong) NSString *cancelButtonTitle;
@property (nonatomic, strong) NSString *otherButtonTitle;

@property (nonatomic, strong) UIAlertController *alertVC;

@end

@implementation YNCustomAlertView

+ (instancetype)shareAlertView
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (nil == alertViewSingle) {
            alertViewSingle = [[[self class] alloc] init];
        }
    });
    
    return alertViewSingle;
}


#pragma mark - Initail Methods

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
              leftButtonTitle:(NSString *)cancelButtonTitle
            rightButtonTitles:(NSString *)otherButtonTitle
{
    YNCustomAlertView *alertView = [YNCustomAlertView shareAlertView];
    if (nil != alertView) {
        alertView.titleStr          = title;
        alertView.messageStr        = message;
        alertView.didRightToLeft    = NO;
        alertView.leftBtnBlock      = nil;
        alertView.rightBtnBlock     = nil;
        alertView.cancelButtonTitle = cancelButtonTitle;
        alertView.otherButtonTitle  = otherButtonTitle;
        
        // default, should create alert view before setting alignment
        alertView.messageLabelAlignment   = MESSAGE_LABEL_ALIGNMENT_CENTER;
    }
    
    return alertView;
}

- (void)dealloc
{
    self.titleStr           = nil;
    self.messageStr         = nil;
    self.leftBtnBlock       = nil;
    self.rightBtnBlock      = nil;
}

#pragma mark - Public Methods

- (void)show
{
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:self.titleStr message:self.messageStr preferredStyle:UIAlertControllerStyleAlert];
    if (nil != self.cancelButtonTitle) {
        UIAlertAction *leftAction = [UIAlertAction actionWithTitle:self.cancelButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            if (nil != self.leftBtnBlock) {
                self.leftBtnBlock();
            }
            
        }];
        
        [alertVC addAction:leftAction];
    }
    
    if (nil != self.otherButtonTitle) {
        UIAlertAction *rightAction = [UIAlertAction actionWithTitle:self.otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (nil != self.rightBtnBlock) {
                self.rightBtnBlock();
            }
        }];
        
        [alertVC addAction:rightAction];
    }
    
    
    
    UIViewController *vc = [self getCurrentVC];
    
    if (vc.presentedViewController) {
        [vc.presentedViewController presentViewController:alertVC animated:YES completion:nil];
    }
    else {
        [vc presentViewController:alertVC animated:YES completion:nil];
    }
    
    self.alertVC = alertVC;
}


#pragma mark - Close Alert View

- (void)closePreviousAlertView
{
    if (nil != self.alertVC) {
        [self.alertVC dismissViewControllerAnimated:NO completion:nil];
        
        self.alertVC = nil;
    }
    
}

//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    UIViewController *result = [window topVisibleViewController];
    
    return result;
}

@end
