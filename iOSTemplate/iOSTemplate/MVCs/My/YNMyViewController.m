//
//  YNMyViewController.m
//  service
//
//  Created by ArthurWang on 2016/12/26.
//  Copyright © 2016年 骑迹. All rights reserved.
//

#import "YNMyViewController.h"

@interface YNMyViewController ()

@end

@implementation YNMyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = nil;
    
    [self loadUrl];
}

- (void)loadUrl
{
    static BOOL localTest = NO;
    
    if (localTest) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"js_bridge_demo_1.0" ofType:@"html"];
        NSURL *url = [NSURL fileURLWithPath:path];
        
        self.url = url;
    } else {
        self.url = [NSURL URLWithString:@"http://exchange.dbike.co/person.html"];
    }
}



@end
