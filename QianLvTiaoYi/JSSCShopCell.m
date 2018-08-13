//
//  JSSCShopCell.m
//  QianLvTiaoYi
//
//  Created by Gollum on 16/4/3.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSSCShopCell.h"

@implementation JSSCShopCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setPicked:(BOOL)picked {
    _picked = picked;
    [_selectButton setSelected:picked];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
