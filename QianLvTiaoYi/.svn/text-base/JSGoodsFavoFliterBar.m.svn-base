//
//  JSGoodsFavoFliterBar.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/4/13.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSGoodsFavoFliterBar.h"
#import "JSContact.h"
#import "JSGoodsFavFliterVC.h"

@implementation JSGoodsFavoFliterBar


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.frame = CGRectMake(0, 0, WIDTH, 40);

}

- (void)awakeFromNib
{
    [super awakeFromNib];
    

    [self setupGoodsFavTopBar];
}

//设置商藏顶部工具栏
- (void)setupGoodsFavTopBar
{
    [_goodsFavBottomViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
        obj.userInteractionEnabled = YES;
        obj.tag = idx;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goodsListTopBarTapHandle:)];
        [obj addGestureRecognizer:tap];
    }];
}

//view点击手势
- (void)goodsListTopBarTapHandle:(UIGestureRecognizer *)sender
{
    [self setGoodsFavSelectedIndex:sender.view.tag];
}

//改变label状态的方法
- (void)setGoodsFavSelectedIndex:(NSInteger)selectedIndex
{
    
    if(_goodsFavSelectBlock)_goodsFavSelectBlock(selectedIndex);
    
    for (int i = 0; i < _goodsFavLabels.count; i++)
    {
        UILabel *label = _goodsFavLabels[i];
        if (i == selectedIndex)
        {
            label.textColor = QLTY_MAIN_COLOR;
            
        } else
        {
            label.textColor = [UIColor colorWithRed:0x66/255.0 green:0x66/255.0 blue:0x66/255.0 alpha:1.0];
        }
    }
}



@end
