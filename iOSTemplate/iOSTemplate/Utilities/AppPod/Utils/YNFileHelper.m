//
//  YNFileHelper.m
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import "YNFileHelper.h"

#define DATA_PATH @"Data"

@implementation YNFileHelper

+ (NSString *)absolutePathForDataFile:(NSString *)fileName {
    NSArray *dirs = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    if (dirs == nil || [dirs count] == 0)
        return nil;
    NSString *path = [[dirs objectAtIndex:0] stringByAppendingPathComponent:DATA_PATH];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:path
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:&error];
        if (error != nil) {
            return nil;
        } else
            return [path stringByAppendingPathComponent:fileName];
    } else
        return [path stringByAppendingPathComponent:fileName];
}

+ (BOOL)existsDataFile:(NSString *)fileName {
    return [[NSFileManager defaultManager] fileExistsAtPath:[self absolutePathForDataFile:fileName]];
}

+ (void)writeDataFile:(NSString *)fileName withData:(NSData *)data {
    NSString *absFile = [self absolutePathForDataFile:fileName];
    [data writeToFile:absFile atomically:YES];
}

+ (NSString *)absolutePathForDocumentFile:(NSString *)docFile {
    NSArray *dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if (dirs == nil || [dirs count] == 0)
        return nil;
    else
        return [[dirs objectAtIndex:0] stringByAppendingPathComponent:docFile];
}

+ (void)writeDocumentFile:(NSString *)fileName withData:(NSData *)data {
    NSString *absFile = [self absolutePathForDocumentFile:fileName];
    [data writeToFile:absFile atomically:YES];
}

+ (BOOL)existsDocumentFile:(NSString *)fileName {
    return [[NSFileManager defaultManager] fileExistsAtPath:[self absolutePathForDocumentFile:fileName]];
}

@end

