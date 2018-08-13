//
//  JSGoodsFavFliterVC.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/4/14.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#define WHITE_WIDTH 40.0f


#import "JSGoodsFavFliterVC.h"
#import "JSContact.h"

#import "JSGoodsFavFliterTopNav.h"

#import "JSGoodsFavFliterTVCell.h"

@interface JSGoodsFavFliterVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) JSGoodsFavFliterTopNav *fliterTopNav;
@property(nonatomic, strong) UITableView *goodsFavFliterTV;

@property(nonatomic, strong) UIView *goodsFavFliterNavView;

@end

@implementation JSGoodsFavFliterVC

#pragma mark - Life Cycle

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self animationViewsIn];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"筛选";
    
    [self createNavigationBar];
    [self initTableView];
}

#pragma mark - touches Methods

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self exitVCAnimationWithDely:0];
}

#pragma mark - Private Methods

/**
 *  自定义导航栏
 */
- (void)createNavigationBar
{
    _goodsFavFliterNavView = [[UIView alloc]initWithFrame:CGRectMake(WIDTH, 0, WIDTH - WHITE_WIDTH, 64)];
    
    [self.view addSubview:_goodsFavFliterNavView];
    
    _fliterTopNav = [[NSBundle mainBundle]loadNibNamed:@"JSGoodsFavFliterTopNav" owner:self options:nil].firstObject;
    
    [_goodsFavFliterNavView addSubview:_fliterTopNav];
}

/**
 *  自定义tableView
 */
- (void)initTableView
{
    _goodsFavFliterTV = [[UITableView alloc] initWithFrame:CGRectMake(WIDTH, 64,WIDTH - WHITE_WIDTH , HEIGHT - 64) style:UITableViewStyleGrouped];
    _goodsFavFliterTV.delegate = self;
    _goodsFavFliterTV.dataSource = self;
    [self.view addSubview:_goodsFavFliterTV];

    
    //_goodsFavFliterTV.contentInset = UIEdgeInsetsMake(20, 0, 44, 0);
    
    [_goodsFavFliterTV registerNib:[UINib nibWithNibName:@"JSGoodsFavFliterTVCell" bundle:nil] forCellReuseIdentifier:@"GoodsFavFliterCell"];
}

/**
 *  进入动画
 */
- (void)animationViewsIn
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.goodsFavFliterTV.frame = CGRectMake(WHITE_WIDTH, 64, WIDTH - WHITE_WIDTH, HEIGHT - 64);
        self.goodsFavFliterNavView.frame = CGRectMake(WHITE_WIDTH, 0, WIDTH - WHITE_WIDTH, 64);
        _fliterTopNav.frame = CGRectMake(0, 0, WIDTH - WHITE_WIDTH, 64);
    } completion:nil];
}

/**
 *  退出界面的动画方法
 */
- (void)exitVCAnimationWithDely:(float)time
{
    [UIView animateWithDuration:0.3 delay:time options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.goodsFavFliterTV.frame = CGRectMake(WIDTH, 64, WIDTH - WHITE_WIDTH, HEIGHT - 64);
        self.goodsFavFliterNavView.frame = CGRectMake(WIDTH, 0, WIDTH - WHITE_WIDTH, 64);
        _fliterTopNav.frame = CGRectMake(0, 0, WIDTH - WHITE_WIDTH, 64);
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}


#pragma mark - Actions

/**
 *  开关按钮点击事件
 */
- (void)switchAction:(UISwitch *)sender
{
    if (sender.isOn)
    {
        
        [UIView animateWithDuration:0.3 delay:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.goodsFavFliterTV.frame = CGRectMake(WIDTH, 64, WIDTH - WHITE_WIDTH, HEIGHT - 64);
            self.goodsFavFliterNavView.frame = CGRectMake(WIDTH, 0, WIDTH - WHITE_WIDTH, 64);
            _fliterTopNav.frame = CGRectMake(0, 0, WIDTH - WHITE_WIDTH, 64);
            
            [M_NOTIFICATION postNotificationName:@"FliterHaveGoodsNotifi" object:nil];
            
        } completion:^(BOOL finished) {
            [self dismissViewControllerAnimated:NO completion:nil];
        }];
    }
}


#pragma mark - UITableViewDelegate & datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JSGoodsFavFliterTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsFavFliterCell" forIndexPath:indexPath];
    
    [cell.goodsFavFliterSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 100;
}


//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _goodsFavFliterTV.frame.size.width, 100)];
//    
//    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    clearButton.center = footerView.center;
//    clearButton.bounds = CGRectMake(0, 0, 80, 30);
//    clearButton.backgroundColor = [UIColor whiteColor];
//    [clearButton setTitle:@"清除选项" forState:UIControlStateNormal];
//    [clearButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    clearButton.titleLabel.font = [UIFont systemFontOfSize:15];
//    
//    [clearButton addTarget:self action:@selector(clearButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    [footerView addSubview:clearButton];
//    
//    return footerView;
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
