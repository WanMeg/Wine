//
//  JSShoppingCartCell.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 15/11/2.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import "JSShoppingCartCell.h"


@implementation JSShoppingCartCell


- (void)awakeFromNib {
    // Initialization code 
}

- (void)setPicked:(BOOL)picked {
    _picked = picked;
    [_pickButton setSelected:picked];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
   
    // Configure the view for the selected state
}

@end
