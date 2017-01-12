//
//  YNImageUtil.m
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import "YNImageUtil.h"

@implementation YNImageUtil

+ (UIImage*)scaleImage:(UIImage *)srcImg toSize:(CGSize)targetSize{
    
    UIImage *sourceImage = srcImg;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    
    @synchronized(self) {
        UIGraphicsBeginImageContext(targetSize); // this will crop
        
        CGRect thumbnailRect = CGRectZero;
        thumbnailRect.origin = thumbnailPoint;
        thumbnailRect.size.width  = scaledWidth;
        thumbnailRect.size.height = scaledHeight;
        
        [sourceImage drawInRect:thumbnailRect];
        
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        
        if(newImage == nil)
            NSLog(@"could not scale image");
        
        //pop the context to get back to the default
        UIGraphicsEndImageContext();
    }
    return newImage;
}

+ (UIImage *)scaleImage:(UIImage *)srcImg toMaxPixels:(float)maxLength{
    UIImage *sourceImage = srcImg;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    float ratio;
    if (height>width) {
        if (height > maxLength) {
            ratio = maxLength/height;
            height = maxLength;
            width = width * ratio;
        }else {
            return srcImg;
        }
    }else {
        if (width > maxLength) {
            ratio = maxLength/width;
            width = maxLength;
            height = height * ratio;
        }else {
            return srcImg;
        }
    }
    return [self scaleImage:srcImg toSize:CGSizeMake(width, height)];
}

@end
