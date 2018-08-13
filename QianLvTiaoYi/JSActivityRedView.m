//
//  JSActivityRedView.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/6/30.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSActivityRedView.h"

@implementation JSActivityRedView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 6.0f);
    _rushProgress.transform = transform;
    
    
//    UIView *writeView = [[UIView alloc]initWithFrame:CGRectMake(_price.frame.origin.x, 15, _price.frame.size.width, 1)];
//    writeView.backgroundColor = [UIColor whiteColor];
//    [self addSubview:writeView];
    

}

@end
