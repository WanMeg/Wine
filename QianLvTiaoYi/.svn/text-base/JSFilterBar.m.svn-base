//
//  JSFilterBar.m
//  QianLvTiaoYi
//
//  Created by JSHENG on 16/3/11.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSFilterBar.h"

@implementation JSFilterBar


- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    self.frame = CGRectMake(0, 0, WIDTH, 40);
}

- (void)awakeFromNib {
    [super awakeFromNib];

// 4s运行会显示有问题 写到了上面
//    self.frame = CGRectMake(0, 0, WIDTH, 40);
    
    _line.constant = 0.5f;
    
    [self setupTopBar];
}

- (void)setupTopBar{
    [_backViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.userInteractionEnabled = YES;
        obj.tag = idx;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goodsListTopBarTapHandle:)];
        [obj addGestureRecognizer:tap];
    }];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    
    if(_selectBlock)_selectBlock(selectedIndex);
  
    for (int i = 0; i < _titleLabels.count; i++) {
        UILabel *label = _titleLabels[i];
        if (i == selectedIndex) {
            label.textColor = QLTY_MAIN_COLOR;
        }else {
            label.textColor = [UIColor colorWithRed:0x66/255.0 green:0x66/255.0 blue:0x66/255.0 alpha:1.0];
        }
    }
}

- (void) goodsListTopBarTapHandle:(UIGestureRecognizer *)sender {
    [self setSelectedIndex:sender.view.tag];
}

@end
