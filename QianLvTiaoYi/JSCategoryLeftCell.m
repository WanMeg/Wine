//
//  JSCategoryLeftCell.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 15/11/13.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import "JSCategoryLeftCell.h"

@implementation JSCategoryLeftCell

- (void)awakeFromNib {
    // Initialization code
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
    self.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
