//
//  JSToosButtonCell.m
//  QianLvTiaoYi
//
//  Created by JSHENG on 16/3/7.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSToosButtonCell.h"

@implementation JSToosButtonCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)buttonsActions:(UIButton *)sender {
    if (_buttonActionBlock) {
        _buttonActionBlock(sender);
    }
}

@end
