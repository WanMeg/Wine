//
//  PRFilterButton1Item.m
//  QianLvTiaoYi
//
//  Created by JSHENG on 16/3/14.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "PRFilterButton1Item.h"

@implementation PRFilterButton1Item
- (void)awakeFromNib {
    [super awakeFromNib];
    _button.layer.cornerRadius = 3.0f;
    _button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _button.layer.masksToBounds = YES;
    _button.layer.borderWidth = 0.5f;
}

- (void)updateButtonUI:(BOOL)isSelected {
    _picked = isSelected;
    if (self.isPicked) {
        _button.layer.borderColor = [UIColor redColor].CGColor;
        [_button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_button setImage:[UIImage imageNamed:@"red_right"] forState:UIControlStateNormal];
    }else {
        _button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [_button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_button setImage:nil forState:UIControlStateNormal];
    }
}


@end
