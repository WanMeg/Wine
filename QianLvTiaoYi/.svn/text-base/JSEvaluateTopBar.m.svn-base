//
//  JSEvaluateTopBar.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 15/11/19.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import "JSEvaluateTopBar.h"

@implementation JSEvaluateTopBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    [_actionViews enumerateObjectsUsingBlock:^(UIView *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.tag = idx;
        obj.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [obj addGestureRecognizer:tap];
    }];
    _lineHeight.constant = 0.5f;
}


- (void)updateNumLabeWithIndex:(NSInteger)idx num:(NSInteger)num {
    UILabel *label = _numLabels[idx];
    label.text = [NSString stringWithFormat:@"%ld", (long)num];
}

- (void)handleTap:(UIGestureRecognizer *)sender {
    self.selectedIndex = sender.view.tag;
}

- (void)evaluateTopBarDidChangeSelectedIndex: (EvaluateCallBackBlock)callBackBlock {
    _evaluateCallBack = callBackBlock;
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    if (self.evaluateCallBack){
        _evaluateCallBack(selectedIndex);
    }
    
    for (int i = 0; i < _titleLabels.count; i++) {
         UILabel *titleLabel = _titleLabels[i];
        UILabel *numLabel = _numLabels[i];
        if (i == selectedIndex) {
            titleLabel.textColor = QLTY_MAIN_COLOR;
            numLabel.textColor = QLTY_MAIN_COLOR;
        }else{
            titleLabel.textColor = [UIColor colorWithRed:0x66/255.0 green:0x66/255.0 blue:0x66/255.0 alpha:1.0];
             numLabel.textColor = [UIColor colorWithRed:0x66/255.0 green:0x66/255.0 blue:0x66/255.0 alpha:1.0];
        }
    }
}

@end
