//
//  YNImageUtil.h
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YNImageUtil : NSObject

+ (UIImage*)scaleImage:(UIImage *)srcImg toSize:(CGSize)targetSize;

+ (UIImage *)scaleImage:(UIImage *)srcImg toMaxPixels:(float)maxLength;

@end
