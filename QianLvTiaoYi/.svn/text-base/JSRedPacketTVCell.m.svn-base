//
//  JSRedPacketTVCell.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/4/27.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSRedPacketTVCell.h"

@implementation JSRedPacketTVCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    
    self.bottomView.layer.cornerRadius = 6;
    self.bottomView.clipsToBounds = YES;
    
    self.blue2View.layer.cornerRadius = 10;
    self.blue2View.clipsToBounds = YES;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_blueBottomView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(6, 6)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _blueBottomView.bounds;
    maskLayer.path = maskPath.CGPath;
    _blueBottomView.layer.mask = maskLayer;
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(nowGetViewTapClick:)];
    
    [self.nowGetView addGestureRecognizer:tap];
}


- (void)nowGetViewTapClick:(UIGestureRecognizer *)sender
{

    _nowGetBlock(sender.view.tag);
}




@end
