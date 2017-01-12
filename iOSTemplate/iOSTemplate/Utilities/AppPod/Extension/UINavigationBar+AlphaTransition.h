//
//  UINavigationBar+AlphaTransition.h
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UINavigationBar (AlphaTransition)

- (void)at_setBackgroundColor:(UIColor *)backgroundColor;

- (void)at_setElementsAlpha:(CGFloat)alpha;

- (void)at_resetBackgroundColor:(UIColor *)backgroundColor translucent:(BOOL)translucent;

- (void)at_setTitleAlpha:(CGFloat)alpha;

@end
