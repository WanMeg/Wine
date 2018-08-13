//
//  JSGoodsCVCell.m
//  QianLvTiaoYi
//
//  Created by JSHENG on 16/3/7.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSGoodsCVCell.h"

@implementation JSGoodsCVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 0.5f;
    
}

@end
