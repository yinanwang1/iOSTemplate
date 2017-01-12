//
//  YNLoginViewController.m
//  service
//
//  Created by ArthurWang on 2017/1/4.
//  Copyright © 2017年 骑迹. All rights reserved.
//

#import "YNLoginViewController.h"

@interface YNLoginViewController ()

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation YNLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = nil;
    
    [self loadUrl];
    
    [self.view bringSubviewToFront:self.loginBtn];
}

- (void)loadUrl
{
    static BOOL localTest = NO;
    
    if (localTest) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"js_bridge_demo_1.0" ofType:@"html"];
        NSURL *url = [NSURL fileURLWithPath:path];
        
        self.url = url;
    } else {
        self.url = [NSURL URLWithString:@"http://www.baidu.com"];
    }
}

- (IBAction)onClickLoginBtn:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginCompleteNotification
                                                        object:nil];
}



@end
