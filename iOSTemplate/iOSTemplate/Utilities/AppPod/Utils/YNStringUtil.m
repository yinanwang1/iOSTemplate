//
//  YNStringUtil.m
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import "YNStringUtil.h"


@implementation YNStringUtil

+(NSString *)substringForString:(NSString *)str beginPattern:(NSString *)p0 endPattern:(NSString *)p1 {
    if(str == nil)
        return nil;
    NSString *substr = nil;
    NSRange pmRange = [str rangeOfString:p0];
    if (pmRange.location != NSNotFound) {
        NSRange pmRange1 = [str rangeOfString:p1];
        substr = [str substringWithRange:NSMakeRange(pmRange.location+[p0 length], pmRange1.location-pmRange.location-[p0 length])];
        if ([substr length] == 0)
            return nil;
        else
            return substr;
    } else
        return nil;
}

+(NSString *)shortenString:(NSString *)str withFont:(UIFont *)font toPixelWidth:(float)width {
    if (str == nil || [str length] <= 1)
        return str;
    if ([str sizeWithAttributes:@{NSFontAttributeName:font}].width < width)
        return str;
    int i;
    for(i=1;i<[str length];i++) {
        if([[str substringToIndex:i] sizeWithAttributes:@{NSFontAttributeName:font}].width >= width-12)
            break;
    }
    if (i==1)
        return [[str substringToIndex:1] stringByAppendingString:@"..."];
    else
        return [[str substringToIndex:i-1] stringByAppendingString:@"..."];
}


+ (CGSize)sizeInOnelineOfText:(NSString *)text font:(UIFont *)font{
    CGSize result =CGSizeZero ;
    if (text) {
        CGSize size;
        if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0) {
            //iOS 7
            size = [text sizeWithAttributes:@{NSFontAttributeName:font}];
        }
        else
        {
            //iOS 6.0
            size = [text sizeWithAttributes:@{NSFontAttributeName:font}];
        }
        result = size;
    }
    return result;
}
+ (CGFloat)heightForText:(NSString *)text havingWidth:(CGFloat)widthValue font:(UIFont *)font
{
    return [[self class] heightForText:text havingWidth:widthValue font:font attributes:nil];
}
+ (CGFloat)heightForText:(NSString *)text havingWidth:(CGFloat)widthValue font:(UIFont *)font attributes:(NSDictionary *)attributes {
    CGFloat result = font.lineHeight;
    if (text) {
        NSMutableDictionary *attr = [NSMutableDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        if (attributes) {
            [attr addEntriesFromDictionary:attributes];
        }
        CGRect frame = [text boundingRectWithSize:CGSizeMake(widthValue, CGFLOAT_MAX)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:attr
                                          context:nil];
        CGSize size = CGSizeMake(frame.size.width, frame.size.height+1);
        
        result = MAX(size.height, result); //At least one row
    }
    result = ceilf(result);
    return result;
}
@end
