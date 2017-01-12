//
//  YNPageControl.h
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YNPageControl : UIPageControl

/**
 *  设置当前页面及不在当前页面的图片
 *
 *  @param imagesArr 第一个为当前页面的图片  第二个为不是当前页面的图片
 */
- (void)updateImages:(NSArray<UIImage *> *)imagesArr;

@end
