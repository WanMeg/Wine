//
//  JSSCEditCell.m
//  QianLvTiaoYi
//
//  Created by Gollum on 16/4/4.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSSCEditCell.h"

@implementation JSSCEditCell

- (void)awakeFromNib {
    // Initialization code
    _numberTF.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setEditItemsUserInteractionEnabled:(BOOL)enabled {
    _numberTF.userInteractionEnabled = enabled;
    _minusButton.userInteractionEnabled = enabled;
    _plusButton.userInteractionEnabled = enabled;
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSInteger num = _numberTF.text.integerValue;
    num = num>0?num:1;
    if (_didChangeNumBlock) {
        _didChangeNumBlock(num);
    }
}

- (IBAction)minusButtonAction:(UIButton *)sender {
    NSInteger num = _numberTF.text.integerValue-1;
    num = num>0?num:1;
    _numberTF.text = [NSString stringWithFormat:@"%ld", (long)num];
    if (_didChangeNumBlock) {
        _didChangeNumBlock(num);
    }
}

- (IBAction)plusButtonAction:(UIButton *)sender {
    NSInteger num = _numberTF.text.integerValue+1;
    _numberTF.text = [NSString stringWithFormat:@"%ld", (long)num];
    if (_didChangeNumBlock) {
        _didChangeNumBlock(num);
    }
}

@end
