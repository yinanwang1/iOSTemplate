//
//  YNRegisterVerifyButton.h
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 * @Important: when you alloc YNVerifyButton in code or drag a UIButton in storyboard,
 *             please make the UIButtonType to UIButtonTypeCustom.
 * The UIButtonTypeSystem will lead a flush when update title to 获取验证码(xx)
 
 
 *
 * 注册时的 获取验证码 按钮风格跟在 外卖中 获取验证码直接注册登录的风格不一致，直接修改 YNVerifyButton 会影响到外卖中的风格, 所以直接建一个新的算了
 */

@interface YNRegisterVerifyButton : UIButton

@property (nonatomic, readonly) BOOL isCounting;

- (void)countingSeconds:(NSInteger)seconds;

@end
