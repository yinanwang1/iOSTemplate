//
//  YNDirectoryManager.h
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YNDirectoryManager : NSObject

+ (NSString *) getLibraryDirectory;

+ (NSString *) getCachesDirectory;
+ (BOOL) createDirectoryAtCachesWithName:(NSString*)dirName;
+ (NSArray*) enumarateDirectoryAtPath:(NSString*)path inCaches:(BOOL)isInCaches;

+ (NSString *) getDocumentsDirectory;
+ (NSString *) getTempDirectory;
+ (BOOL) createDirectoryAtPath:(NSString*)path;
//+ (BOOL) createDirectoryAtDocumentsWithName:(NSString*)dirName;
//+ (NSArray*) enumarateDirectoryAtPath:(NSString*)path inDocuments:(BOOL)isInDocuments;
//+ (NSMutableArray*) createURLStartWith:(NSString*)start AtPath:(NSString*)path inDocuments:(BOOL)isInDocuments;

+ (void)moveFilesFrom:(NSString *)fromFile to:(NSString *)toFile;
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;
+ (NSString *)getAdImagePath:(NSString *)image_url;

@end
