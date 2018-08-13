//
//  JSGoodsDetailTimedCell.m
//  QianLvTiaoYi
//
//  Created by 优hui on 16/5/26.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSGoodsDetailTimedCell.h"

@implementation JSGoodsDetailTimedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)updateUIWithObject:(GoodsBaseInfo *)goods{
    _priceLabel.text = goods.goodsPrice;
    _soldLabel.text = [NSString stringWithFormat:@"已抢: %ld%%    ", goods.awardedNum];
    _soldNumLabel.text = [NSString stringWithFormat:@"已抢: %ld%@", goods.partakeNumber, goods.unit];
    _nameLabel.text = goods.name;
    _discountLabel.text = goods.goodsRebate;
    _commentLabel.text = [NSString stringWithFormat:@"%ld人评价", goods.commentCount];
    _allSalesLabel.text = [NSString stringWithFormat:@"%ld人付款", goods.goodsSales];
    _stockLabel.text = [NSString stringWithFormat:@"%ld", goods.stock];
    _startNumLabel.text = [NSString stringWithFormat:@"%ld%@", goods.startNum, goods.unit];
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:goods.price
                                                                  attributes: @{NSFontAttributeName:[UIFont systemFontOfSize:20.f],
                                                                                NSForegroundColorAttributeName:[UIColor lightGrayColor],
                                                                                NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
                                                                                NSStrikethroughColorAttributeName:[UIColor lightGrayColor]}];
    _oldPrice.attributedText = attrStr;
    //_capacityLabel.text =
}
@end
