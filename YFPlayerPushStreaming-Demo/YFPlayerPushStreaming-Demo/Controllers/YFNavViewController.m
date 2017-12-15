//
//  YFNavViewController.m
//  YFPlayerPushStreaming-Demo
//
//  Created by apple on 3/31/17.
//  Copyright © 2017 YunFan. All rights reserved.
//

#import "YFNavViewController.h"

@interface YFNavViewController ()

@end

@implementation YFNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBar.tintColor = [UIColor colorWithRed:0 green:228/255.0 blue:226/255.0 alpha:1];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    viewController.hidesBottomBarWhenPushed = YES;
    [self setNavigationBarHidden:YES];
    [super pushViewController:viewController animated:animated];
}

@end
