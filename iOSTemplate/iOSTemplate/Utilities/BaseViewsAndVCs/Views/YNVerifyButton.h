//
//  YNVerifyButton.h
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import "UIRenderingButton.h"

/*
 * @Important: when you alloc YNVerifyButton in code or drag a UIButton in storyboard, 
 *             please make the UIButtonType to UIButtonTypeCustom.
 * The UIButtonTypeSystem will lead a flush when update title to 获取验证码(xx)
*/
@interface YNVerifyButton : UIRenderingButton

@property (nonatomic, readonly) BOOL isCounting;
- (void)countingSeconds:(NSInteger)seconds;

@end
