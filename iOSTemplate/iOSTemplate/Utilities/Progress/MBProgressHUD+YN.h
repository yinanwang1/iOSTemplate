//
//  MBProgressHUD+YN.h
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (YN)

+ (instancetype)showInViewWithoutIndicator:(UIView *)view status:(NSString *)text afterDelay:(NSTimeInterval)delay;
+ (instancetype)showInViewWithoutIndicator:(UIView *)view status:(NSString *)text image:(UIImage *)image afterDelay:(NSTimeInterval)delay;

+ (instancetype)showInView:(UIView *)view;
+ (instancetype)showInView:(UIView *)view status:(NSString *)text;

@end
