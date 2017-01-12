//
//  YNLoadingAnimaitonProtocol.h
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YNLoadingAnimaitonProtocol <NSObject>

- (void)setupAnimationInLayer:(CALayer *)layer withSize:(CGSize)size;

@end
