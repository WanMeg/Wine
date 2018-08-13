//
//  WMMemberCenterTVC.m
//  QianLvTiaoYi
//
//  Created by JSHENG on 16/4/6.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "WMMemberCenterTVC.h"

#import "JSContact.h"
#import "JSGuessLikeCV.h"
#import "JSMemberCenterCV.h"
#import "UINavigationBar+Awesome.h"
#import "GetUserData.h"
#import "PRAlertView.h"
#import "UINavigationController+CustomStyle.h"

#define NAVBAR_CHANGE_POINT 5

@interface WMMemberCenterTVC ()<UICollectionViewDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *avatarIV;//头像按钮
@property (weak, nonatomic) IBOutlet UIButton *accountButton;//登陆注册按钮
@property (weak, nonatomic) IBOutlet JSGuessLikeCV *guessLikeCV;//猜你喜欢collView
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *allOrderFiveViews;//全部订单下的五个view


@end

@implementation WMMemberCenterTVC


#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updateUI];
    [self setupAllOrderFiveViewsClick];
    
    _guessLikeCV.goodsList = [Goods creatTempGoodsListWithCount:10];
    _guessLikeCV.delegate = self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tableView.delegate = self;
    //隐藏navigationBar 调用
    [self scrollViewDidScroll:self.tableView];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self setupLoginButton];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setBarOfWhiteStyle];
    self.tableView.delegate = nil;
    [self.navigationController.navigationBar lt_reset];
}

#pragma mark - Private Methods
/**
 *  设置顶部导航的隐藏和添加消息按钮
 */
- (void)updateUI
{
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTranslucent:YES];
    //导航栏右侧按钮
    UIImage *image = [[UIImage imageNamed:@"xiaoxi2.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *item1= [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(handleRightButtons:)];
    UIBarButtonItem *item2= [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(handleRightButtons:)];
    item2.tag = 1;
    self.navigationItem.rightBarButtonItems = @[item1,];
    //self.scrollView.delegate = self;
}
/**
 *  设置头像按钮
 */
- (void)setupLoginButton
{
    _avatarIV.layer.cornerRadius = 30;
    _avatarIV.layer.masksToBounds = YES;
    Member *member = [GetUserData fetchActivateMemberData];
    if (member) {
        [_accountButton setTitle:member.userName forState:UIControlStateNormal];
        _accountButton.userInteractionEnabled = NO;
    }else {
        [_accountButton setTitle:@"登录/注册" forState:UIControlStateNormal];
        _accountButton.userInteractionEnabled = YES;
    }
}
/**
 *  判断是否登录
 *
 *  @return
 */
- (BOOL)isLogin {
    Member *member = [GetUserData fetchActivateMemberData];
    if (member) {
        return YES;
    }else {
        PRAlertView *alertView = [[PRAlertView alloc] init];
        [alertView showNoLoginAlertViewWithCallBack:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                UIViewController * NC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginNC"];
                [self.navigationController presentViewController:NC animated:YES completion:nil];
            }
        }];
        return NO;
    }
}
/**
 *  登录按钮点击事件
 */
- (IBAction)someAction:(UIButton *)sender
{
    if (sender.tag == 78) {
        Member *member = [GetUserData fetchActivateMemberData];
        if (!member) {
            UIViewController * NC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginNC"];
            [self.navigationController presentViewController:NC animated:YES completion:nil];
        }
    }else{
        //头像按钮点击事件
        if (![self isLogin]) {
            return;
        }
        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MemberInfoTVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
/**
 *  导航条右侧按钮点击事件
 *
 *  @param sender barItem
 */
- (void)handleRightButtons:(UIBarButtonItem *)sender {
    if (![self isLogin]) {
        return;
    }
    
    if (sender.tag == 1) {
        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MemberInfoTVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutUSVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
/**
 *  给全部订单下五个view增加点击手势
 */
- (void)setupAllOrderFiveViewsClick {
    [_allOrderFiveViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.tag = idx;
        obj.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapOfAllOrderFiveViews:)];
        [obj addGestureRecognizer:tap];
    }];
}
/**
 *  全部订单列表view点击事件
 *
 *  @param sender 点击手势
 */
- (void)handleTapOfAllOrderFiveViews:(UITapGestureRecognizer *)sender {
    if (![self isLogin])
    {
        return;
    }
    
}

#pragma mark - scrollView delegate
/**
 *  导航条滑动渐变动画  关联UINavigationBar+Awesome 分类
 *
 *  @param scrollView 滚动视图
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //滑动设置导航条是否显示
    UIColor * color = QLTY_MAIN_COLOR;
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > NAVBAR_CHANGE_POINT) {
        CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64));
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
    } else {
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
    }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 || section == 1)
    {
        return 2;
    }
    else
    {
        return 1;
    }
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
