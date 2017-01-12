//
//  YNDirectoryManager.m
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import "YNDirectoryManager.h"
#import <sys/xattr.h>
#import "YNAppDeviceHelper.h"
#import "NSString+Addition.h"

@implementation YNDirectoryManager

+ (NSString *) getLibraryDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    return documentsDirectory;
}

+ (NSString *) getCachesDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSMutableString *path = [paths objectAtIndex:0];
    
    return path;
}

+ (BOOL) createDirectoryAtCachesWithName:(NSString *)dirName
{
    NSString *dirPath = [[YNDirectoryManager getCachesDirectory] stringByAppendingPathComponent:dirName];
    
    return [YNDirectoryManager createDirectoryAtPath:dirPath];
}

+ (NSString *) getDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    return documentsDirectory;
}

+ (NSArray*) enumarateDirectoryAtPath:(NSString *)path inCaches:(BOOL)isInCaches
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *enumPath;
    NSArray *enumArray;
    
    if (isInCaches)
        enumPath = [NSString stringWithString:[[YNDirectoryManager getCachesDirectory] stringByAppendingPathComponent:path]];
    else
        enumPath = [NSString stringWithString:path];
    
    
    enumArray = [fileManager contentsOfDirectoryAtPath:enumPath error:nil];
    
    return enumArray;
}

+ (NSString *) getTempDirectory
{
    return NSTemporaryDirectory();
}

+ (BOOL) createDirectoryAtPath:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path isDirectory:nil])
    {
        return NO;
    }
    else
    {
        return [fileManager createDirectoryAtPath:path withIntermediateDirectories:NO attributes:NULL error:NULL];
    }
    
}

//+ (NSArray*) enumarateDirectoryAtPath:(NSString *)path inDocuments:(BOOL)isInDocuments {
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSString *enumPath;
//    NSArray *enumArray;
//
//    if (isInDocuments)
//        enumPath = [NSString stringWithString:[[DirectoryManager getDocumentsDirectory] stringByAppendingPathComponent:path]];
//    else
//        enumPath = [NSString stringWithString:path];
//
//
//    enumArray = [fileManager contentsOfDirectoryAtPath:enumPath error:nil];
//
//    return enumArray;
//}

//+ (BOOL) createDirectoryAtDocumentsWithName:(NSString *)dirName {
//    NSString *dirPath = [[DirectoryManager getDocumentsDirectory] stringByAppendingPathComponent:dirName];
//
//    return [DirectoryManager createDirectoryAtPath:dirPath];
//}

//+ (NSMutableArray*)createURLStartWith:(NSString *)start AtPath:(NSString *)path inDocuments:(BOOL)isInDocuments {
//    NSMutableArray *result = [[NSMutableArray alloc] init];
//    NSArray *fileList = [DirectoryManager enumarateDirectoryAtPath:path inDocuments:isInDocuments];
//
//    if (path != nil) {
//        for (int i = 0; i < fileList.count; ++i) {
//            NSString *tmpString = [[NSString alloc] initWithFormat:@"%@%@/%@", start, path, [fileList objectAtIndex:i]];
//            [result addObject:tmpString];
//            [tmpString release];
//        }
//    } else {
//        for (int i = 0; i < fileList.count; ++i) {
//            NSString *tmpString = [[NSString alloc] initWithFormat:@"%@%@", start, [fileList objectAtIndex:i]];
//            [result addObject:tmpString];
//            [tmpString release];
//        }
//    }
//    return result;
//}

+ (void)moveFilesFrom:(NSString *)fromFile to:(NSString *)toFile
{
    NSError * error;
    NSArray * files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:fromFile error:&error];
    
    if(files && files.count > 0)
    {
        for(NSString * selectedFile in files)
        {
            NSString * fromFilePath = [fromFile stringByAppendingPathComponent: selectedFile];
            NSString * toFilePath = [toFile stringByAppendingPathComponent: selectedFile];
            
            BOOL isDir;
            //判断是否是为目录
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:fromFilePath isDirectory:&isDir] && isDir)
            {//目录
                
                [[NSFileManager defaultManager] createDirectoryAtPath:toFilePath withIntermediateDirectories:NO attributes:nil error:nil];
                
                [YNDirectoryManager moveFilesFrom:fromFilePath to:toFilePath];
            }
            else
            {//文件
                [[NSFileManager defaultManager] moveItemAtPath:fromFilePath toPath:toFilePath error:nil];
            }
        }
    }
}

+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    if(URL == nil)
        return NO;
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    if (SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(@"5.0.1")) { // iOS <= 5.0.1
        const char* filePath = [[URL path] fileSystemRepresentation];
        
        const char* attrName = "com.apple.MobileBackup";
        u_int8_t attrValue = 1;
        
        int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
        return result == 0;
    } else { // iOS >= 5.1
        NSError *error = nil;
        [URL setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error];
        return error == nil;
    }
}

+ (NSString *)getAdImagePath:(NSString *)image_url {
    NSString *imagePath = [YNDirectoryManager getCachesDirectory];
    imagePath = [imagePath stringByAppendingPathComponent:@"LaunchAd"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:imagePath isDirectory:nil])
    {
        [YNDirectoryManager createDirectoryAtPath:imagePath];
    }
    imagePath = [imagePath stringByAppendingString:[NSString md5:image_url]];
    return imagePath;
}

@end
