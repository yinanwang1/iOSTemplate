//
//  YNURLShortenService.h
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YNURLShortenService : NSObject

+(YNURLShortenService *)sharedInstance;

-(void)shortenURL:(NSString *)url target:(id)target selector:(SEL)selector;

@end
