//
//  JSAdressListCell.h
//  QianLvTiaoYi
//
//  Created by JiaSheng on 15/11/6.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSAdressListCell : UITableViewCell

/****地址管理****/


//收货人姓名
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

//电话号码
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;

//地址
@property (weak, nonatomic) IBOutlet UILabel *adressLabel;

//编辑按钮
@property (weak, nonatomic) IBOutlet UIButton *editButton;

//删除按钮
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

//选中按钮
@property (weak, nonatomic) IBOutlet UIButton *selectButton;

//红色默认lab
@property (weak, nonatomic) IBOutlet UILabel *moRenLab;


//
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lindeHeight;

@end
