//
//  JSUserSecurityTabVC.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/4/16.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSUserSecurityTabVC.h"

#import "JSUserSecurityTVCell.h"

@interface JSUserSecurityTabVC ()<UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *userSecurityPhoneBtn;

@property (nonatomic, strong) JSUserSecurityTVCell *cell;

@end

@implementation JSUserSecurityTabVC

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    _userSecurityPhoneBtn.layer.cornerRadius = 5;
    _userSecurityPhoneBtn.clipsToBounds = YES;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"JSUserSecurityTVCell" bundle:nil] forCellReuseIdentifier:@"SecurityTVCell"];
}


#pragma mark - Actions

- (IBAction)backUpVCClick:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)callPhoneBtnClick:(UIButton *)sender
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否拨打客服热线" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拨打", nil];
    [alert show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        //拨打客服电话
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4001531919"]];
    }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JSUserSecurityTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SecurityTVCell" forIndexPath:indexPath];

    cell.userSecurityTitleLab.text = @"123154阿大声道";
    cell.userSecurityMessageLab.text = @"大家可舒服哈大家开始发货的考虑时间规划的房间开三个环节是对方过后就开了啥地方刚回家考虑啥地方规划等放假快乐时光是大法官连锁店";
    
    return cell;
}

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
