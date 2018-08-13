//
//  JSIntegralTabVCell.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/4/19.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSIntegralTabVCell.h"

@implementation JSIntegralTabVCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    
    self.IntegralStyleLab.layer.borderWidth = 0.5f;
    self.IntegralStyleLab.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.IntegralStyleLab.layer.cornerRadius = 5;
    self.IntegralStyleLab.clipsToBounds = YES;

}


@end
