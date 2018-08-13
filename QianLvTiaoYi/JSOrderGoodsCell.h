//
//  JSOrderGoodsCell.h
//  QianLvTiaoYi
//
//  Created by JiaSheng on 15/11/9.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSOrderGoodsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;//图片
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;//名称
@property (weak, nonatomic) IBOutlet UILabel *activityLabel;//活动lab
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;//价格
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;//数量


//@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
//@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
//
//@property (weak, nonatomic) IBOutlet UIButton *deleteOrderBtn;


@end
