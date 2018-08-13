//
//  UINavigationController+CustomStyle.m
//  QianLvTiaoYi
//
//  Created by JSHENG on 15/12/30.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import "UINavigationController+CustomStyle.h"

@implementation UINavigationController (CustomStyle)

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setBarOfWhiteStyle {
    [self.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                              [UIColor darkGrayColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:18], NSFontAttributeName, nil];
    [self.navigationBar setTintColor:[UIColor darkGrayColor]];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}


- (void)setBarOfRedStyle {
    if (self.viewControllers.count <= 2) {
        [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"redPoint.png"] forBarMetrics:UIBarMetricsDefault];
        self.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                  [UIColor whiteColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:18], NSFontAttributeName, nil];
        [self.navigationBar setTintColor:[UIColor whiteColor]];
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
