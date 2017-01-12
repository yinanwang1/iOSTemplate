//
//  YNBaseJSONModel.m
//  Pods
//
//  Created by ArthurWang on 16/8/16.
//
//

#import "YNBaseJSONModel.h"

#import "UIColor+Extensions.h"

@implementation YNBaseJSONModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end

@interface JSONValueTransformer (UIColor)

@end

@implementation JSONValueTransformer (UIColor)

- (UIColor *)UIColorFromNSString:(NSString *)string
{
    return [UIColor colorWithHexString:string];
}

- (NSString *)JSONObjectFromUIColor:(UIColor *)color
{
    int r,g,b,a;
    
    r = (int)(255.0 * color.red);
    g = (int)(255.0 * color.green);
    b = (int)(255.0 * color.blue);
    a = (int)(255.0 * color.alpha);
    
    return [NSString stringWithFormat:@"%02x%02x%02x%02x",r,g,b,a];
}

@end
