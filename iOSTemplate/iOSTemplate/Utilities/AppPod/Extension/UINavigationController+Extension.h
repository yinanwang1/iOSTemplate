//
//  UINavigationController+Extension.h
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UINavigationController (Extension)

- (UIViewController *)firstViewControllerOfClass:(NSString *)className;

- (BOOL)containedController:(NSString *)className;

@end
