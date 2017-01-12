//
//  YNURLShortenService.m
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import "YNURLShortenService.h"
#import <objc/message.h>

#define BITLY_LOGIN @"YN"
#define BITLY_KEY @""

static YNURLShortenService *_shareYNURLShortenService = nil;

@interface YNURLShortenItem : NSObject {
@private
    NSString *url;
    id target;
    SEL selector;
}

@property(nonatomic, strong) NSString *url;
@property(nonatomic, strong) id target;
@property(nonatomic, assign) SEL selector;

@end

@implementation YNURLShortenItem

@synthesize url, target, selector;

@end

@implementation YNURLShortenService

+(YNURLShortenService *)sharedInstance {
    if (_shareYNURLShortenService != nil)
        return _shareYNURLShortenService;
    
    _shareYNURLShortenService = [[YNURLShortenService alloc] init];
    return _shareYNURLShortenService;
}

-(void)shortenURL:(NSString *)url target:(id)target selector:(SEL)selector {
    YNURLShortenItem *item = [[YNURLShortenItem alloc] init];
    item.url = url;
    item.target = target;
    item.selector = selector;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self shortenURL:item];
    });
}

-(NSString *)encodeURL:(NSString *)value{
    if (value == nil)
        return @"";
    
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                             (CFStringRef)value,
                                                                                             NULL,
                                                                                             CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                             kCFStringEncodingUTF8));
    return result;
}

- (void)shortenURL:(YNURLShortenItem *)item{
    
    NSString *reqURL = [NSString stringWithFormat:@"http://api.bit.ly/v3/shorten?login=%@&apikey=%@&longUrl=%@&format=txt",
                        BITLY_LOGIN,
                        BITLY_KEY,
                        [self encodeURL:item.url]];
    NSURLResponse *resp = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:reqURL]] returningResponse:&resp error:&error];
    
    NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    result = [result stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    if (result == nil || [result isEqualToString:@"ALREADY_A_BITLY_LINK"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //[item.target performSelector:item.selector withObject:item.url];
            ((void(*)(id, SEL, id))objc_msgSend)(item.target, item.selector, item.url);
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            //[item.target performSelector:item.selector withObject:result];
            ((void(*)(id, SEL, id))objc_msgSend)(item.target, item.selector, result);
        });
    }
}

@end
