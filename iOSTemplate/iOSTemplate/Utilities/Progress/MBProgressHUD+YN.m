//
//  MBProgressHUD+YN.m
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import "MBProgressHUD+YN.h"

#import "YNLoadingAnimation.h"

@interface LoadingBackgroundView : UIView

@end

@implementation LoadingBackgroundView

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(60, 60);
}

@end

@implementation MBProgressHUD (YN)

+ (instancetype)showInViewWithoutIndicator:(UIView *)view status:(NSString *)text afterDelay:(NSTimeInterval)delay
{
    if (nil == view) {
        return nil;
    }
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.bezelView.color = [UIColor blackColor];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    [hud setMode:MBProgressHUDModeText];
    hud.detailsLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    hud.detailsLabel.text = text;
    hud.detailsLabel.textColor = [UIColor whiteColor];
    [hud hideAnimated:YES afterDelay:delay];
    

    return hud;
}

+ (instancetype)showInViewWithoutIndicator:(UIView *)view status:(NSString *)text image:(UIImage *)image afterDelay:(NSTimeInterval)delay
{
    if (nil == view) {
        return nil;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    UIImage *temimage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    hud.customView = [[UIImageView alloc] initWithImage:temimage];
    hud.label.font = [UIFont systemFontOfSize:15];
    hud.label.text = text;
    [hud hideAnimated:YES afterDelay:delay];
    
    return hud;
}

+ (instancetype)showInView:(UIView *)view
{
    if (nil == view) {
        return nil;
    }
    
    if (nil == view) {
        return nil;
    }
    
    LoadingBackgroundView *tempView = [[LoadingBackgroundView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
    [tempView setBackgroundColor:[UIColor clearColor]];
    
    id <YNLoadingAnimaitonProtocol> animation = [[YNLoadingAnimation alloc] init];
    if ([animation respondsToSelector:@selector(setupAnimationInLayer:withSize:)]) {
        [animation setupAnimationInLayer:tempView.layer withSize:tempView.bounds.size];
        tempView.layer.speed = 1.0; // start animation
    }
    
    MBProgressHUD *hud  = [MBProgressHUD showHUDAddedTo:view animated:YES];
    [hud setMode:MBProgressHUDModeCustomView];
    hud.customView = tempView;
    hud.margin     = 0.0f;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor clearColor];
    hud.backgroundView.color = [UIColor clearColor];
    
    return hud;
}

+ (instancetype)showInView:(UIView *)view status:(NSString *)text
{
    if (nil == view) {
        return nil;
    }
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.bezelView.backgroundColor = [UIColor colorWithRGBHex:0x999999];
    hud.label.text = text;
    
    return hud;
}


@end

