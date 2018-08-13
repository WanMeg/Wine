//
//  PRTabBarController.m
//  QianLvTiaoYi
//
//  Created by 优hui on 16/4/25.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "PRTabBarController.h"
#import "PRAlertManager.h"
#import "PRAlertView.h"

@interface PRTabBarController ()<UITabBarControllerDelegate>

@end

@implementation PRTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    // Do any additional setup after loading the view.
}



- (void)showAlertView
{
    NSString *str = [NSString stringWithFormat:@"tel:%@",@"4001531919"];
    UIWebView *callWebView = [[UIWebView alloc]init];
    [callWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebView];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if ([viewController.title isEqualToString:@"客服"]) {
        [self showAlertView];
        return NO;
    } else {
        return YES;
    }
}



@end
