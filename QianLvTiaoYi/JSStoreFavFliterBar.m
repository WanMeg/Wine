//
//  JSStoreFavFliterBar.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/4/13.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSStoreFavFliterBar.h"
#import "JSContact.h"
@implementation JSStoreFavFliterBar


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.


- (void)drawRect:(CGRect)rect
{
    // Drawing code
    self.frame = CGRectMake(0, 0, WIDTH, 40);
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    
    [self setupStoreFavTopBar];
}
//顶部工具栏
- (void)setupStoreFavTopBar
{
    [_storeFavBottomViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.userInteractionEnabled = YES;
        obj.tag = idx;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goodsListTopBarTapHandle:)];
        [obj addGestureRecognizer:tap];
    }];
}

- (void)setStoreFavSelectedIndex:(NSInteger)selectedIndex {
    
    if(_storeFavSelectBlock)_storeFavSelectBlock(selectedIndex);
    
    for (int i = 0; i < _storeFavLabels.count; i++) {
        UILabel *label = _storeFavLabels[i];
        if (i == selectedIndex) {
            label.textColor = QLTY_MAIN_COLOR;
        }else {
            label.textColor = [UIColor colorWithRed:0x66/255.0 green:0x66/255.0 blue:0x66/255.0 alpha:1.0];
        }
    }
}

- (void) goodsListTopBarTapHandle:(UIGestureRecognizer *)sender {
    [self setStoreFavSelectedIndex:sender.view.tag];
}

@end
