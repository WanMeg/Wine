//
//  JSSCRecommentCVCell.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/5/12.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSSCRecommentCVCell.h"

@implementation JSSCRecommentCVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.layer.borderColor = [UIColor grayColor].CGColor;
    self.layer.borderWidth = 0.5f;
}

@end
