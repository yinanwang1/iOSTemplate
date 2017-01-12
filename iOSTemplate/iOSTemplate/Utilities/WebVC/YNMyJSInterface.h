//
//  YNMyJSInterface.h
//  59dorm
//
//  Created by J006 on 16/8/2.
//  Copyright © 2016年 Huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YNWebViewController.h"
#import "WKWebViewJavascriptBridge.h"

@interface YNMyJSInterface : NSObject

@property (nonatomic, weak)   YNWebViewController      *currentViewController;
@property (nonatomic, strong) WKWebViewJavascriptBridge *bridge;

- (void)setUpWithBridge:(WKWebViewJavascriptBridge *)bridge;

@end
