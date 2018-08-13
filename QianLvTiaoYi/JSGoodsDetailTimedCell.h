//
//  JSGoodsDetailTimedCell.h
//  QianLvTiaoYi
//
//  Created by 优hui on 16/5/26.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsBaseInfo.h"

@interface JSGoodsDetailTimedCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *soldLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *allSalesLabel;
@property (weak, nonatomic) IBOutlet UILabel *stockLabel;
@property (weak, nonatomic) IBOutlet UILabel *startNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *capacityLabel;
@property (weak, nonatomic) IBOutlet UILabel *soldNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *oldPrice;


- (void)updateUIWithObject:(GoodsBaseInfo *)goods;
@end
