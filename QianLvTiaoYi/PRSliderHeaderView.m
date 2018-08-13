//
//  PRSliderHeaderView.m
//  QianLvTiaoYi
//
//  Created by JSHENG on 15/12/16.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import "PRSliderHeaderView.h"

@implementation PRSliderHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.imgView.layer.borderWidth = 0.5f;
}

@end
