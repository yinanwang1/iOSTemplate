//
//  YNTaskViewController.m
//  service
//
//  Created by ArthurWang on 2016/12/26.
//  Copyright © 2016年 骑迹. All rights reserved.
//

#import "YNTaskViewController.h"

#import "YNWebViewController.h"
#import "YNQRCode.h"


@interface YNTaskViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

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
    self.navigationItem.title = @"主页1";
    
    self.navigationItem.leftBarButtonItem = nil;
}

- (IBAction)onClickBtn:(id)sender
{
//    YNWebViewController *webVC = [[YNWebViewController alloc] init];
//    webVC.url = [NSURL URLWithString:@"http://exchange.dbike.co/auth.html"];
//    
//    [self.navigationController pushViewController:webVC animated:YES];
    
    UIImage *image = [YNQRCode createQRCodeImageWithString:@"http://www.baidu.com" size:300];
    
    self.imageView.image = image;
    
    NSString *string = [YNQRCode createQRCodeBase64WithString:@"http://www.baidu.com" size:300];
    NSLog(@"string is %@>", string);
}


@end
