//
//  JSSetTVC.m
//  QianLvTiaoYi
//
//  Created by JSHENG on 16/4/9.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSSetTVC.h"

#import "GetUserData.h"
#import "JSContact.h"
#import "JSImageQualityTVC.h"

@interface JSSetTVC ()

@property (weak, nonatomic) IBOutlet UILabel *imageQualityStatusLab;

@property (nonatomic, copy) NSString *imageQuailtyName;
@property (nonatomic, assign) NSInteger index;
@end

@implementation JSSetTVC

#pragma mark - Life Cycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
    
    
    //本地取出 点击的行数 设置cell右侧的图片
    _index = [M_USERDEFAULTS integerForKey:@"ImageQualityIndex"];
    
    switch (_index) {
        case 0:{
            _imageQualityStatusLab.text = @"智能模式";
        }
            break;
        case 1:{
            _imageQualityStatusLab.text = @"高质量模式";
        }
            break;
        case 2:{
            _imageQualityStatusLab.text = @"普通模式";
        }
            break;
            
        default:
            break;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}


#pragma mark - Click Actions

- (IBAction)backMemberCenterVCClick:(UIBarButtonItem *)sender
{
    //返回会员中心界面
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)exitRegisterClick:(UIButton *)sender
{
    //当前账号退出登陆
    [GetUserData deleteMemberLoginStatus];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0 ? 10 : 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return section == 2 ? 10 : 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    } else if (section == 1) {
        return 1;
    } else {
        return 2;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)  {
        if (indexPath.row == 0) {
            //个人信息界面
            UIViewController *myInfoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MemberInfoTVC"];
            [self.navigationController pushViewController:myInfoVC animated:YES];
        } else if (indexPath.row == 1) {
            //账户管理界面
            UIViewController *userSecurityVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UserManagerTabVC"];
            [self.navigationController pushViewController:userSecurityVC animated:YES];
        } else {
            //消息通知提醒界面
            
            UIViewController *messageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SystemMessageTVC"];
            [self.navigationController pushViewController:messageVC animated:YES];
        }
    } else if (indexPath.section == 1) {
        //图片质量
        JSImageQualityTVC *imageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ImageQualityTVC"];

        if ([_imageQualityStatusLab.text isEqualToString:@"智能模式"]) {
            imageVC.isCapacity = YES;
        }
        
        [self.navigationController pushViewController:imageVC animated:YES];
    } else {
        if (indexPath.row == 0) {
            //关于我们
            UIViewController *aboutVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutUSVC"];
            [self.navigationController pushViewController:aboutVC animated:YES];
        } else {
            //意见反馈
            UIViewController *aboutVC = [self.storyboard instantiateViewControllerWithIdentifier:@"IdeaBackVC"];
            [self.navigationController pushViewController:aboutVC animated:YES];
        }
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
