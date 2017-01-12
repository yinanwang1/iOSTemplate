//
//  YNLoadingAnimation.m
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import "YNLoadingAnimation.h"

#import "UIColor+Extensions.h"

static NSInteger const kCircleCount = 4;
static NSArray * fillColors = nil;

@implementation YNLoadingAnimation

#pragma mark - YNLoadingAnimaitonProtocol

+ (void)initialize {
    fillColors = [NSArray arrayWithObjects: [UIColor colorWithRGBHex:0xfa679b], // 粉色
                  [UIColor colorWithRGBHex:0x3d96f5], // 蓝色
                  [UIColor colorWithRGBHex:0xff8459], // 蓝色
                  [UIColor colorWithRGBHex:0x3ad5d0],nil]; // 青色
}

- (void)setupAnimationInLayer:(CALayer *)layer withSize:(CGSize)size {
    
    NSTimeInterval beginTime = CACurrentMediaTime();
    
    CGFloat circleSize = size.width / 3.0f;
    CGFloat circleRadius = circleSize * 0.5f;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, circleSize, circleSize)];
    
    // 计算圆的坐标
    CGPoint pointA = CGPointMake(circleRadius, circleRadius);
    CGPoint pointB = CGPointMake(pointA.x, size.height - circleRadius);
    CGPoint pointC = CGPointMake(size.width - circleRadius, pointB.y);
    CGPoint pointD = CGPointMake(pointC.x, pointA.y);
    
    for (int i = 0; i < kCircleCount; i++) {
        CAShapeLayer *circle = [CAShapeLayer layer];
        circle.path = path.CGPath;
        circle.fillColor = [self fillColorsWithIndex:i].CGColor;
        circle.strokeColor = nil;
        circle.bounds = CGRectMake(0, 0, circleSize, circleSize);
        circle.position = pointA;
        circle.anchorPoint = CGPointMake(0.5f, 0.5f);
        circle.transform = CATransform3DMakeScale(0.0f, 0.0f, 0.0f);
        circle.shouldRasterize = YES;
        circle.rasterizationScale = [[UIScreen mainScreen] scale];
        
        CAKeyframeAnimation *transformAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        transformAnimation.removedOnCompletion = NO;
        transformAnimation.repeatCount = HUGE_VALF;
        transformAnimation.duration = 2.0f;
        transformAnimation.beginTime = beginTime - (i * transformAnimation.duration / 4.0f);;
        transformAnimation.keyTimes = @[@(0.0f), @(1.0f / 4.0f), @(2.0f / 4.0f), @(3.0f / 4.0f), @(1.0)];
        
        transformAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:     kCAMediaTimingFunctionEaseInEaseOut],
                                               [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                               [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                               [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                               [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        
        CATransform3D t1 = CATransform3DMakeTranslation(pointB.x - pointA.x, pointB.y - pointA.y, 0.0f);
        
        CATransform3D t2 = CATransform3DMakeTranslation(pointC.x - pointA.x, pointC.y - pointA.y, 0.0f);
        
        CATransform3D t3 = CATransform3DMakeTranslation(pointD.x - pointA.x, pointD.y - pointA.y, 0.0f);
        
        CATransform3D t4 = CATransform3DMakeTranslation(0.0f, 0.0f, 0.0f);
        
        transformAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DIdentity],
                                      [NSValue valueWithCATransform3D:t1],
                                      [NSValue valueWithCATransform3D:t2],
                                      [NSValue valueWithCATransform3D:t3],
                                      [NSValue valueWithCATransform3D:t4]];
        
        [layer addSublayer:circle];
        [circle addAnimation:transformAnimation forKey:@"animation"];
    }
}

- (UIColor *)fillColorsWithIndex:(NSInteger)index {
    
    return fillColors[index];
}

@end
