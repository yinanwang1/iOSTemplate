//
//  UIColor+Extensions.h
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extensions)

@property (nonatomic, readonly) CGColorSpaceModel colorSpaceModel;
@property (nonatomic, readonly) BOOL canProvideRGBComponents;
@property (nonatomic, readonly) CGFloat red;	// Only valid if canProvideRGBComponents is YES
@property (nonatomic, readonly) CGFloat green;	// Only valid if canProvideRGBComponents is YES
@property (nonatomic, readonly) CGFloat blue;	// Only valid if canProvideRGBComponents is YES
@property (nonatomic, readonly) CGFloat white;	// Only valid if colorSpaceModel == kCGColorSpaceModelMonochrome
@property (nonatomic, readonly) CGFloat alpha;
@property (nonatomic, readonly) UInt32 rgbHex;
@property (nonatomic, readonly) UInt32 argbHex;

- (NSString*) colorSpaceString;

- (NSArray*) arrayFromRGBAComponents;

- (BOOL) red: (CGFloat*) r green: (CGFloat*) g blue: (CGFloat*) b alpha: (CGFloat*) a;

- (float) luminance;
- (float) brightness;

- (UIColor*) colorByLuminanceMapping;

- (UIColor*) colorByMultiplyingByRed: (CGFloat) red green: (CGFloat) green blue: (CGFloat) blue alpha: (CGFloat) alpha;
- (UIColor*) colorByAddingRed: (CGFloat) red green: (CGFloat) green blue: (CGFloat) blue alpha: (CGFloat) alpha;
- (UIColor*) colorByLighteningToRed: (CGFloat) red green: (CGFloat) green blue: (CGFloat) blue alpha: (CGFloat) alpha;
- (UIColor*) colorByDarkeningToRed: (CGFloat) red green: (CGFloat) green blue: (CGFloat) blue alpha: (CGFloat) alpha;

- (UIColor*) colorByMultiplyingBy: (CGFloat) f;
- (UIColor*) colorByAdding: (CGFloat) f;
- (UIColor*) colorByLighteningTo: (CGFloat) f;
- (UIColor*) colorByDarkeningTo: (CGFloat) f;

- (UIColor*) colorByMultiplyingByColor: (UIColor*) color;
- (UIColor*) colorByAddingColor: (UIColor*) color;
- (UIColor*) colorByLighteningToColor: (UIColor*) color;
- (UIColor*) colorByDarkeningToColor: (UIColor*) color;

- (UIColor*) colorByBlendingWithColor:(UIColor*)color alpha:(CGFloat)alpha;

- (NSString*) stringFromColor;
- (NSString*) hexStringFromColor;
- (NSString*) hexStringFromColorWithAlpha;

- (BOOL) isEqualToColor: (UIColor*) color;

+ (UIColor*) randomColor;

+ (UIColor*) colorWithRGBHex: (UInt32) hex;
+ (UIColor*) colorWithARGBHex: (UInt32) hex;
+ (UIColor*) colorWithHexString: (NSString*) stringToConvert;
+ (UIColor*) colorWithHexStringWithAlpha: (NSString*) stringToConvert;

+ (UIColor*) colorWithName: (NSString*) cssColorName;

+(UIColor*) highlightedColor:(UInt32) hex;
+(UIColor*) highlightedColorFromColor:(UIColor*)color;

@end
