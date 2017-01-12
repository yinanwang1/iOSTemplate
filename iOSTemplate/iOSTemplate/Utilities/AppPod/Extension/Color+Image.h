//
//  "Color+Image.h"
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (util)
+(UIColor *)colorWithR:(uint8_t)R G:(uint8_t)G B:(uint8_t)B A:(CGFloat)A;
+(UIColor *)colorWithHexString: (NSString *) hexString;
@end


@interface UIImage (util)
+(UIImage*) resizableImageWithColor:(UIColor*)color size:(CGSize)size caps:(UIEdgeInsets)caps;
+(UIImage*) imageWithColor:(UIColor*)color;
+ (UIImage *)imageWithColor:(UIColor *)color withSize:(CGSize)size;

+ (id) imageFromImage:(UIImage*)image leftString:(NSString*)string textColor:(UIColor*)textColor font:(UIFont *)font;

@end
