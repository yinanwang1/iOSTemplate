//
//  YNQRCode.m
//  iOSTemplate
//
//  Created by ArthurWang on 2017/1/12.
//  Copyright © 2017年 wang. All rights reserved.
//

#import "YNQRCode.h"

#import "Base64Encoding.h"

@interface YNQRCode ()

@property (nonatomic, strong) NSString *contentStr;
@property (nonatomic, assign) CGFloat size;

@end

@implementation YNQRCode

+ (instancetype)QRCode
{
    static YNQRCode *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[YNQRCode alloc] init];
    });
    
    return instance;
}

#pragma mark - Public Methods

/* 根据string绘画image */
+ (UIImage *)createQRCodeImageWithString:(NSString *)contentStr size:(CGFloat)size
{
    YNQRCode *QRCode = [YNQRCode QRCode];
    
    QRCode.contentStr = contentStr;
    QRCode.size = size;
    
    UIImage *image = [QRCode createQRCode];
    
    return image;
}

/* 根据string绘画image, 转化为Base64 返回 */
+ (NSString *)createQRCodeBase64WithString:(NSString *)contentStr size:(CGFloat)size
{
    UIImage *image = [YNQRCode createQRCodeImageWithString:contentStr size:size];
    
    NSData *data = UIImagePNGRepresentation(image);
    NSString *base64String = [Base64Encoding base64StringFromData:data];
    
    return base64String;
}


#pragma mark - Private Methods

- (UIImage *)createQRCode
{
    // 1.创建过滤器
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2.恢复默认
    [filter setDefaults];
    // 3.给过滤器添加数据(正则表达式/账号和密码)
    NSString *dataString = self.contentStr;
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    // 4.获取输出的二维码
    CIImage *outputImage = [filter outputImage];
    // 5.将CIImage转换成UIImage，并放大显示
    UIImage *image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:self.size];
    
    return image;
}
/**
 * 根据CIImage生成指定大小的UIImage
 *
 * @param image CIImage
 * @param size 图片宽度
 */
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

@end
