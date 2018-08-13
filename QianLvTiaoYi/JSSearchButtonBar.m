//
//  JSSearchButtonBar.m
//  QianLvTiaoYi
//
//  Created by JSHENG on 16/3/12.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSSearchButtonBar.h"

#import "JSContact.h"

@implementation JSSearchButtonBar


- (void)drawRect:(CGRect)rect {
    // Drawing code
    
//    self.frame = CGRectMake(0, 0, WIDTH, 64);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.frame = CGRectMake(0, 0, WIDTH, 64);
    
    _searchButton.layer.cornerRadius = 3.0f;
    _searchButton.layer.masksToBounds = YES;
    
    _rightButton.tag = 2;
    _searchButton.tag = 1;
    _leftButton.tag = 0;
}
- (IBAction)buttonActions:(UIButton *)sender {
    if (_buttonActionsBlock) {
        _buttonActionsBlock(sender.tag);
    }
}


//4s测试 点击分类会崩 把searchBar的frame设置在了上面
//- (void)layoutSubviews {
//    [super layoutSubviews];
//    self.frame = CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), 64);
//}


@end
