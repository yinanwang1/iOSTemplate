//
//  YNBaseViewController.h
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YNWarningBarView;

static UInt32 navBarWhiteBgColorValue = 0xfafbfd;
static UInt32 navBarWhiteTitleVolorValue = 0x303030;

@interface YNBaseViewController : UIViewController

@property (nonatomic, strong) YNWarningBarView *warnBarView;
@property (nonatomic, assign, getter=isFirstLoading) BOOL firstLoading;

@property (nonatomic, weak) IBOutlet UIImageView *cannotFindImageView;
@property (nonatomic, weak) IBOutlet UILabel *cannotFindLabel;

- (void)showWarning:(NSString *)wStr;
- (void)dismissWarning;

- (void)tokenRefreshed;

- (void)replaceCurrentViewControllerWith:(UIViewController *)viewController animated:(BOOL)animated;

- (void)initialNavigationLeftItem; // back + close buttons
- (void)turnBack;
- (void)close;
- (void)changeNavigationBarBackgroundColor:(UIColor *)backGroundColor
                      pushBackButItemImage:(UIImage *)pushBackImage
                   presentBackButItemImage:(UIImage *)presentBackImage
                                titleColor:(UIColor *)titleColor;

- (void)changeNavigationBarNormal;

@end
