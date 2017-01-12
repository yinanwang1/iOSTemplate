//
//  YNBlurImageView.h
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YNBlurImageView : UIImageView

- (void)blurSetImage:(UIImage *)image;
- (void)blurSetImage:(UIImage *)image colorLevel:(CGFloat)level;
- (void)blurSetImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;
- (BOOL)hasImageNow;

@end
