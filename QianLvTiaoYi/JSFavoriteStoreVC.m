//
//  JSFavoriteStoreVC.m
//  QianLvTiaoYi
//
//  Created by JSHENG on 16/4/11.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSFavoriteStoreVC.h"
#import "JSGoodsFavoriteVC.h"

@interface JSFavoriteStoreVC ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *storeSegmentC;

@end

@implementation JSFavoriteStoreVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)storeSegmentAction:(UISegmentedControl *)sender
{
    JSGoodsFavoriteVC *goodsVC = [[JSGoodsFavoriteVC alloc]initWithNibName:@"JSGoodsFavoriteVC" bundle:nil];
    [self.view addSubview:goodsVC.view];
}

- (IBAction)backMemberCenterVCAction:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)storeSearchAction:(UIBarButtonItem *)sender
{
    
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
