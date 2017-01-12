//
//  YNAlipayManager.h
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YNAlipayDelegate <NSObject>

- (void)payCallBack:(NSString *)status message:(NSString *)message result:(NSDictionary *)result;

@end

@interface YNAlipayManager : NSObject

@property (nonatomic, weak) id<YNAlipayDelegate> delegate;

+ (YNAlipayManager *) sharedManager;

- (BOOL)handleOpenURL:(NSURL *)url;

- (void)pay:(NSDictionary *)orderInfoDic delegate:(id<YNAlipayDelegate>)delegate;

@end
