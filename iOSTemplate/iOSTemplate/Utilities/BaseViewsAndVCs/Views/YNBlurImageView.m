//
//  YNBlurImageView.m
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import "YNBlurImageView.h"

#import <Accelerate/Accelerate.h>
#import "UIImageView+WebCache.h"
#import "YNMacrosUtils.h"

@implementation YNBlurImageView

- (BOOL)hasImageNow
{
    return self.image != nil;
}

- (void)blurSetImage:(UIImage *)image
{
    [self blurSetImage:image colorLevel:0.3f];
}

- (void)blurSetImage:(UIImage *)image colorLevel:(CGFloat)level
{
    if (image) {
        UIImage *blured = [self blurryImage:image withBlurLevel:level];
        CATransition *animation = [CATransition animation];
        animation.type = kCATransitionFade;
        animation.duration = 0.05f;
        [self.layer addAnimation:animation forKey:nil];
        self.image = blured;
    }else {
        self.image = image;
    }
}

- (void)blurSetImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;
{
    if (url) {
        __weak YNBlurImageView *wself = self;
        self.image = nil;
        [self sd_setImageWithURL:url
                placeholderImage:placeholder
                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                           if (image) {
                               BEGIN_MAIN_THREAD
                               UIImage *blured = [wself blurryImage:image withBlurLevel:0.2f];
                               CATransition *animation = [CATransition animation];
                               animation.type = kCATransitionFade;
                               animation.duration = 0.15f;
                               [wself.layer addAnimation:animation forKey:nil];
                               wself.image = blured;
                               END_MAIN_THREAD
                           }
                       }];

        
    }else {
        if (placeholder == nil) {
            self.image = nil;
        }
        self.image = placeholder;
        if (placeholder) {
            UIImage *blured = [self blurryImage:placeholder withBlurLevel:0.2f];
            CATransition *animation = [CATransition animation];
            animation.type = kCATransitionFade;
            animation.duration = 0.05f;
            [self.layer addAnimation:animation forKey:nil];
            self.image = blured;
        }
    }
}

- (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur {
    if ((blur < 0.0f) || (blur > 1.0f)) {
        blur = 0.5f;
    }
    
    int boxSize = (int)(blur * 100);
    boxSize -= (boxSize % 2) + 1;
    
    CGImageRef img = image.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL,
                                       0, 0, boxSize, boxSize, NULL,
                                       kvImageEdgeExtend);
    
    
    if (error) {
        DLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             CGImageGetBitmapInfo(image.CGImage));
    
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    CGImageRelease(imageRef);
    
    return returnImage;
}

@end
