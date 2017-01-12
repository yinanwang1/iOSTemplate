//
//  UIWindow+Extension.h
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIWindow (Extension)

- (UIViewController *)topVisibleViewController;

+ (UIViewController*) getTopMostViewController; // iOS 7 used

@end
