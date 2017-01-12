//
//  Base64Encoding.h
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Base64Encoding : NSObject

+(NSString *)base64StringFromData:(NSData *)data;
+ (NSString*)base64forData:(NSData*)theData;
+ (NSData *)dataWithBase64String:(NSString *)string;

@end
