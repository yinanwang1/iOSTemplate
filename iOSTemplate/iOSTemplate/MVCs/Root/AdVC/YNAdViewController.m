//
//  YNAdViewController.m
//  iOSTemple
//
//  Created by ArthurWang on 2017/1/12.
//  Copyright © 2017年 wang. All rights reserved.
//

#import "YNAdViewController.h"

@interface YNAdViewController ()

@end

@implementation YNAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)onClickMainBtn:(id)sender
{
    if (nil != self.block) {
        self.block();
    }
}

@end
