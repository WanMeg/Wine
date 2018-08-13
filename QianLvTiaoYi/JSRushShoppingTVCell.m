//
//  JSRushShoppingTVCell.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/5/9.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSRushShoppingTVCell.h"

@implementation JSRushShoppingTVCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    
    self.rushShopUpView.layer.borderColor = [UIColor redColor].CGColor;
    self.rushShopUpView.layer.borderWidth = 1.0f;
    
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 3.0f);
    _rushShopProgress.transform = transform;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
