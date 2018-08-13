//
//  JSSCDistributeStyleCell.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/5/13.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSSCDistributeStyleCell.h"

@implementation JSSCDistributeStyleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    self.distributeStyleButton.layer.borderColor = [UIColor redColor].CGColor;
    self.distributeStyleButton.layer.borderWidth = 0.8f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
