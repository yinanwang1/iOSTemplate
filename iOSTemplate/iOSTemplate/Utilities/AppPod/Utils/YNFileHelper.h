//
//  YNFileHelper.h
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YNFileHelper : NSObject

+ (NSString *)absolutePathForDataFile:(NSString *)fileName;
+ (BOOL)existsDataFile:(NSString *)fileName;
+ (void)writeDataFile:(NSString *)fileName withData:(NSData *)data;

+ (NSString *)absolutePathForDocumentFile:(NSString *)docFile;
+ (BOOL)existsDocumentFile:(NSString *)fileName;
+ (void)writeDocumentFile:(NSString *)fileName withData:(NSData *)data;

@end
