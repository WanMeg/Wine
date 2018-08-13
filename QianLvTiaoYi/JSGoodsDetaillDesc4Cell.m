//
//  JSGoodsDetaillDesc4Cell.m
//  QianLvTiaoYi
//
//  Created by JSHENG on 16/3/18.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSGoodsDetaillDesc4Cell.h"

@implementation JSGoodsDetaillDesc4Cell

- (void)awakeFromNib {
    // Initialization code
    _numLabel.layer.cornerRadius = 3;
    _numLabel.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
