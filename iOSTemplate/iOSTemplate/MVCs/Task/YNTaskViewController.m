//
//  YNTaskViewController.m
//  service
//
//  Created by ArthurWang on 2016/12/26.
//  Copyright © 2016年 骑迹. All rights reserved.
//

#import "YNTaskViewController.h"

#import "YNWebViewController.h"


@interface YNTaskViewController ()

@end

@implementation YNTaskViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialNavigatonBar];
}


#pragma mark - Initial Methods

- (void)initialNavigatonBar
{
    self.navigationItem.title = @"待更换电池";
    
    self.navigationItem.leftBarButtonItem = nil;
}

- (IBAction)onClickBtn:(id)sender
{
    YNWebViewController *webVC = [[YNWebViewController alloc] init];
    webVC.url = [NSURL URLWithString:@"http://exchange.dbike.co/auth.html"];
    
    [self.navigationController pushViewController:webVC animated:YES];
}


@end
