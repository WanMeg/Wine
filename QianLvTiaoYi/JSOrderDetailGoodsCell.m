//
//  JSOrderDetailGoodsCell.m
//  QianLvTiaoYi
//
//  Created by JSHENG on 15/12/29.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import "JSOrderDetailGoodsCell.h"
#import "JSContact.h"

@implementation JSOrderDetailGoodsCell

- (void)awakeFromNib {
    // Initialization code
    
    self.returnButton.layer.borderColor = QLTY_MAIN_COLOR.CGColor;
    self.returnButton.layer.borderWidth = 0.5f;
    self.returnButton.layer.cornerRadius = 3;
    self.returnButton.layer.masksToBounds = YES;
    
    self.serviceButton.layer.borderColor = QLTY_MAIN_COLOR.CGColor;
    self.serviceButton.layer.borderWidth = 0.5f;
    self.serviceButton.layer.cornerRadius = 3;
    self.serviceButton.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
