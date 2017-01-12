//
//  UIView+Utilities.h
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Utilities)

- (void)shake;

+ (void)printView:(UIView*)view prefix: (NSString*)prefix;

+ (instancetype)viewFromNib;

+ (instancetype)viewFromNibWithModuleName:(NSString *)moduleNameStr;

@end
