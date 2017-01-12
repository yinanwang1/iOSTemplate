//
//  YNQRCode.h
//  iOSTemplate
//
//  Created by ArthurWang on 2017/1/12.
//  Copyright © 2017年 wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YNQRCode : NSObject

/* 根据string绘画image */
+ (UIImage *)createQRCodeImageWithString:(NSString *)contentStr size:(CGFloat)size;

/* 根据string绘画image, 转化为Base64 返回 */
+ (NSString *)createQRCodeBase64WithString:(NSString *)contentStr size:(CGFloat)size;

@end
