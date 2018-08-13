//
//  JSCustomNC.m
//  QianLvTiaoYi
//
//  Created by JSHENG on 16/3/10.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSCustomNC.h"
#import "JSContact.h"
@interface JSCustomNC ()

@end

@implementation JSCustomNC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.j
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"whitePoint"] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = [UIImage imageNamed:@"colorLine"];
    self.navigationBar.translucent = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
 
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

@end
