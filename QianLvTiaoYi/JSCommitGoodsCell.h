//
//  JSCommitGoodsCell.h
//  QianLvTiaoYi
//
//  Created by JSHENG on 15/12/25.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSCommitGoodsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *specLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
@property (weak, nonatomic) IBOutlet UIButton *goodsActionBtn;

@end
