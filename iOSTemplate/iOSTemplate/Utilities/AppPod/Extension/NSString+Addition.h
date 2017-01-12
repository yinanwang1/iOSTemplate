//
//  NSString+Addition.h
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Additional)

+ (NSString *)GetUUID;
- (BOOL)startWith:(NSString *)str;
- (NSString *) hashStr;
+ (NSString *)md5:(NSString *)string;
+ (NSString*)encodeString:(NSString*)unencodedString;
+ (NSString *)decodeString:(NSString*)encodedString;
+ (BOOL)stringContainsEmoji:(NSString *)string;

/** 计算'/n'的个数 */
- (NSInteger)numberOfNewLine;

- (NSString *)urlencode;

@end
