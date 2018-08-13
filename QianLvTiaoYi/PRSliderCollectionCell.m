//
//  PRSliderCollectionCell.m
//  QianLvTiaoYi
//
//  Created by JSHENG on 15/12/17.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import "PRSliderCollectionCell.h"

@implementation PRSliderCollectionCell

- (void)awakeFromNib {
    self.layer.cornerRadius = 5.0f;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.layer.borderWidth = 0.5f;
}

@end
