//
//  YNGuideViewController.m
//  service
//
//  Created by ArthurWang on 2016/12/26.
//  Copyright © 2016年 骑迹. All rights reserved.
//

#import "YNGuideViewController.h"

@interface YNGuideViewController ()

@end

@implementation YNGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onClickMainBtn:(id)sender
{
    if (nil != self.block) {
        self.block();
    }
}

@end
