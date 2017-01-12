//
//  YNStringUtil.h
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YNStringUtil : NSObject {
    
}

+(NSString *)substringForString:(NSString *)str beginPattern:(NSString *)p0 endPattern:(NSString *)p1;
+(NSString *)shortenString:(NSString *)str withFont:(UIFont *)font toPixelWidth:(float)width;

+ (CGSize)sizeInOnelineOfText:(NSString *)text font:(UIFont *)font;
+ (CGFloat)heightForText:(NSString *)text havingWidth:(CGFloat)widthValue font:(UIFont *)font;
+ (CGFloat)heightForText:(NSString *)text havingWidth:(CGFloat)widthValue font:(UIFont *)font attributes:(NSDictionary *)attributes;

@end
